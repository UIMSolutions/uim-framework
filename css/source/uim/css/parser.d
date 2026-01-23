/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.css.parser;

import std.string;
import std.array;
import std.algorithm;
import std.conv;
import uim.css.types;

@safe:

/**
 * Exception thrown when CSS parsing fails
 */
class CSSParseException : Exception {
    this(string msg, string file = __FILE__, size_t line = __LINE__) pure nothrow @safe {
        super(msg, file, line);
    }
}

/**
 * Parser for CSS strings
 */
class CSSParser {
    private string source;
    private size_t pos;
    
    this(string source) pure nothrow @safe {
        this.source = source;
        this.pos = 0;
    }
    
    /**
     * Parses the CSS and returns a stylesheet
     */
    CSSStyleSheet parse() @safe {
        auto sheet = new CSSStyleSheet();
        skipWhitespace();
        
        while (!isEof()) {
            // Check for @ rules (media queries, etc.)
            if (peek() == '@') {
                auto mediaQuery = parseMediaQuery();
                if (mediaQuery !is null) {
                    sheet.addMediaQuery(mediaQuery);
                }
            }
            // Check for CSS variables in :root
            else if (source[pos .. $].startsWith(":root")) {
                parseRootVariables(sheet);
            }
            // Regular rule
            else {
                auto rule = parseRule();
                if (rule !is null) {
                    sheet.addRule(rule);
                }
            }
            
            skipWhitespace();
        }
        
        return sheet;
    }
    
    private void parseRootVariables(CSSStyleSheet sheet) @safe {
        // Skip ":root"
        pos += 5;
        skipWhitespace();
        
        if (peek() != '{') {
            return;
        }
        pos++; // Skip '{'
        skipWhitespace();
        
        while (!isEof() && peek() != '}') {
            auto prop = parseProperty();
            if (prop.name.startsWith("--")) {
                sheet.setVariable(prop.name, prop.value);
            }
            skipWhitespace();
        }
        
        if (!isEof()) {
            pos++; // Skip '}'
        }
    }
    
    private CSSMediaQuery parseMediaQuery() @safe {
        // Skip '@media'
        if (!consumeString("@media")) {
            return null;
        }
        
        skipWhitespace();
        
        // Parse media type and conditions
        string mediaType = "all";
        string[] conditions;
        
        // Read until '{'
        size_t start = pos;
        while (!isEof() && peek() != '{') {
            pos++;
        }
        
        string queryStr = source[start .. pos].strip;
        
        // Simple parsing: split by "and"
        auto parts = queryStr.split(" and ");
        if (parts.length > 0) {
            mediaType = parts[0].strip;
            foreach (i, part; parts[1 .. $]) {
                auto condition = part.strip;
                // Remove parentheses
                if (condition.startsWith("(") && condition.endsWith(")")) {
                    condition = condition[1 .. $-1];
                }
                conditions ~= condition;
            }
        }
        
        auto query = new CSSMediaQuery(mediaType, conditions);
        
        if (peek() == '{') {
            pos++; // Skip '{'
            skipWhitespace();
            
            // Parse rules inside media query
            while (!isEof() && peek() != '}') {
                auto rule = parseRule();
                if (rule !is null) {
                    query.addRule(rule);
                }
                skipWhitespace();
            }
            
            if (!isEof()) {
                pos++; // Skip '}'
            }
        }
        
        return query;
    }
    
    private CSSRule parseRule() @safe {
        // Parse selectors
        auto selectors = parseSelectors();
        if (selectors.length == 0) {
            return null;
        }
        
        auto rule = new CSSRule();
        foreach (selector; selectors) {
            rule.addSelector(selector);
        }
        
        skipWhitespace();
        
        // Parse declarations
        if (peek() != '{') {
            return null;
        }
        pos++; // Skip '{'
        skipWhitespace();
        
        while (!isEof() && peek() != '}') {
            auto prop = parseProperty();
            if (prop.name.length > 0) {
                rule.addProperty(prop.name, prop.value, prop.important);
            }
            skipWhitespace();
        }
        
        if (!isEof()) {
            pos++; // Skip '}'
        }
        
        return rule;
    }
    
    private string[] parseSelectors() @safe {
        string[] selectors;
        size_t start = pos;
        
        while (!isEof() && peek() != '{') {
            if (peek() == ',') {
                string selector = source[start .. pos].strip;
                if (selector.length > 0) {
                    selectors ~= selector;
                }
                pos++; // Skip ','
                skipWhitespace();
                start = pos;
            } else {
                pos++;
            }
        }
        
        // Add last selector
        string selector = source[start .. pos].strip;
        if (selector.length > 0) {
            selectors ~= selector;
        }
        
        return selectors;
    }
    
    private CSSProperty parseProperty() @safe {
        // Parse property name
        size_t start = pos;
        while (!isEof() && peek() != ':' && peek() != ';' && peek() != '}') {
            pos++;
        }
        
        string name = source[start .. pos].strip;
        if (name.length == 0 || peek() != ':') {
            // Skip to next semicolon or closing brace
            while (!isEof() && peek() != ';' && peek() != '}') {
                pos++;
            }
            if (!isEof() && peek() == ';') {
                pos++;
            }
            return CSSProperty("", "");
        }
        
        pos++; // Skip ':'
        skipWhitespace();
        
        // Parse property value
        start = pos;
        bool important = false;
        
        while (!isEof() && peek() != ';' && peek() != '}') {
            pos++;
        }
        
        string value = source[start .. pos].strip;
        
        // Check for !important
        if (value.endsWith("!important")) {
            important = true;
            value = value[0 .. $-10].strip;
        }
        
        if (!isEof() && peek() == ';') {
            pos++; // Skip ';'
        }
        
        return CSSProperty(name, value, important);
    }
    
    private void skipWhitespace() pure nothrow @safe {
        while (!isEof()) {
            char c = peek();
            if (c == ' ' || c == '\t' || c == '\n' || c == '\r') {
                pos++;
            }
            // Skip comments
            else if (c == '/' && pos + 1 < source.length && source[pos + 1] == '*') {
                pos += 2;
                // Find end of comment
                while (!isEof() && !(peek() == '*' && pos + 1 < source.length && source[pos + 1] == '/')) {
                    pos++;
                }
                if (!isEof()) {
                    pos += 2; // Skip */
                }
            }
            else {
                break;
            }
        }
    }
    
    private char peek() const pure nothrow @safe {
        if (isEof()) {
            return '\0';
        }
        return source[pos];
    }
    
    private bool isEof() const pure nothrow @safe {
        return pos >= source.length;
    }
    
    private bool consumeString(string str) pure nothrow @safe {
        if (pos + str.length <= source.length && source[pos .. pos + str.length] == str) {
            pos += str.length;
            return true;
        }
        return false;
    }
}

/**
 * Convenience function to parse CSS
 */
CSSStyleSheet parseCSS(string css) @safe {
    auto parser = new CSSParser(css);
    return parser.parse();
}
