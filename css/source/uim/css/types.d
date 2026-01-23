/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.css.types;

import std.string;
import std.array;
import std.algorithm;

@safe:

/**
 * Represents a CSS property-value pair
 */
struct CSSProperty {
    string name;
    string value;
    bool important;
    
    this(string name, string value, bool important = false) pure nothrow {
        this.name = name;
        this.value = value;
        this.important = important;
    }
    
    /**
     * Returns the CSS string representation
     */
    string toString() const {
        if (important) {
            return name ~ ": " ~ value ~ " !important";
        }
        return name ~ ": " ~ value;
    }
}

/**
 * Represents a CSS selector
 */
struct CSSSelector {
    string selector;
    
    this(string selector) pure nothrow {
        this.selector = selector.strip;
    }
    
    string toString() const pure nothrow {
        return selector;
    }
}

/**
 * Represents a CSS rule (selector + declarations)
 */
class CSSRule {
    CSSSelector[] selectors;
    CSSProperty[] properties;
    
    this() pure nothrow @safe {
    }
    
    this(string selector) @safe {
        addSelector(selector);
    }
    
    /**
     * Adds a selector to this rule
     */
    void addSelector(string selector) @safe {
        selectors ~= CSSSelector(selector);
    }
    
    /**
     * Adds a property to this rule
     */
    void addProperty(string name, string value, bool important = false) pure nothrow @safe {
        properties ~= CSSProperty(name, value, important);
    }
    
    /**
     * Gets a property value by name
     */
    string getProperty(string name) const pure nothrow @safe {
        foreach (prop; properties) {
            if (prop.name == name) {
                return prop.value;
            }
        }
        return null;
    }
    
    /**
     * Checks if a property exists
     */
    bool hasProperty(string name) const pure nothrow @safe {
        return properties.any!(p => p.name == name);
    }
    
    /**
     * Removes a property by name
     */
    void removeProperty(string name) @safe {
        properties = properties.filter!(p => p.name != name).array;
    }
    
    /**
     * Sets or updates a property
     */
    void setProperty(string name, string value, bool important = false) @safe {
        foreach (ref prop; properties) {
            if (prop.name == name) {
                prop.value = value;
                prop.important = important;
                return;
            }
        }
        addProperty(name, value, important);
    }
    
    /**
     * Returns the CSS string representation
     */
    override string toString() const {
        if (selectors.length == 0 || properties.length == 0) {
            return "";
        }
        
        string[] selectorStrings;
        foreach (sel; selectors) {
            selectorStrings ~= sel.toString();
        }
        
        string[] propertyStrings;
        foreach (prop; properties) {
            propertyStrings ~= "  " ~ prop.toString() ~ ";";
        }
        
        return selectorStrings.join(", ") ~ " {\n" ~ 
               propertyStrings.join("\n") ~ "\n}";
    }
}

/**
 * Represents a CSS media query
 */
class CSSMediaQuery {
    string mediaType;
    string[] conditions;
    CSSRule[] rules;
    
    this(string mediaType, string[] conditions = null) pure nothrow @safe {
        this.mediaType = mediaType;
        this.conditions = conditions;
    }
    
    /**
     * Adds a rule to this media query
     */
    void addRule(CSSRule rule) pure nothrow @safe {
        rules ~= rule;
    }
    
    /**
     * Returns the CSS string representation
     */
    override string toString() const {
        string query = "@media " ~ mediaType;
        if (conditions.length > 0) {
            query ~= " and (" ~ conditions.join(") and (") ~ ")";
        }
        
        string[] ruleStrings;
        foreach (rule; rules) {
            auto ruleStr = rule.toString();
            if (ruleStr.length > 0) {
                // Indent rules inside media query
                ruleStrings ~= ruleStr.split("\n").map!(line => "  " ~ line).join("\n");
            }
        }
        
        return query ~ " {\n" ~ ruleStrings.join("\n\n") ~ "\n}";
    }
}

/**
 * Represents a complete CSS stylesheet
 */
class CSSStyleSheet {
    CSSRule[] rules;
    CSSMediaQuery[] mediaQueries;
    string[string] variables;  // CSS custom properties (variables)
    
    this() pure nothrow @safe {
    }
    
    /**
     * Adds a rule to the stylesheet
     */
    void addRule(CSSRule rule) pure nothrow @safe {
        rules ~= rule;
    }
    
    /**
     * Adds a media query to the stylesheet
     */
    void addMediaQuery(CSSMediaQuery query) pure nothrow @safe {
        mediaQueries ~= query;
    }
    
    /**
     * Sets a CSS variable
     */
    void setVariable(string name, string value) @safe {
        if (!name.startsWith("--")) {
            name = "--" ~ name;
        }
        variables[name] = value;
    }
    
    /**
     * Gets a CSS variable
     */
    string getVariable(string name) const @safe {
        if (!name.startsWith("--")) {
            name = "--" ~ name;
        }
        return variables.get(name, null);
    }
    
    /**
     * Finds rules by selector
     */
    const(CSSRule)[] findRules(string selector) const @safe {
        const(CSSRule)[] found;
        foreach (rule; rules) {
            foreach (sel; rule.selectors) {
                if (sel.selector == selector) {
                    found ~= rule;
                    break;
                }
            }
        }
        return found;
    }
    
    /**
     * Returns the complete CSS string
     */
    override string toString() const {
        string[] parts;
        
        // Add variables if any
        if (variables.length > 0) {
            string[] varStrings;
            foreach (name, value; variables) {
                varStrings ~= "  " ~ name ~ ": " ~ value ~ ";";
            }
            parts ~= ":root {\n" ~ varStrings.join("\n") ~ "\n}";
        }
        
        // Add regular rules
        foreach (rule; rules) {
            auto ruleStr = rule.toString();
            if (ruleStr.length > 0) {
                parts ~= ruleStr;
            }
        }
        
        // Add media queries
        foreach (query; mediaQueries) {
            auto queryStr = query.toString();
            if (queryStr.length > 0) {
                parts ~= queryStr;
            }
        }
        
        return parts.join("\n\n");
    }
}
