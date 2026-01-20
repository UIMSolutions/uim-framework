/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.plist.xml;

import uim.plist.propertylist;
import uim.plist.value;
import uim.plist.exceptions;
import std.conv;
import std.string;
import std.array;
import std.algorithm;

@safe:

/**
 * XMLPlistWriter - Writes property lists in XML format
 * 
 * Generates Apple's XML plist format (version 1.0)
 */
class XMLPlistWriter {
    private int _indentLevel = 0;
    private string _indent = "  ";

    /**
     * Converts a PropertyList to XML format
     */
    string write(const PropertyList plist) {
        auto result = appender!string();
        
        // XML header
        result.put("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
        result.put("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" ");
        result.put("\"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n");
        result.put("<plist version=\"1.0\">\n");
        
        // Root dictionary
        _indentLevel = 1;
        result.put(getIndent());
        result.put("<dict>\n");
        
        _indentLevel = 2;
        auto data = plist.getData();
        foreach (key; data.keys.sort) {
            writeKeyValue(result, key, data[key]);
        }
        
        _indentLevel = 1;
        result.put(getIndent());
        result.put("</dict>\n");
        result.put("</plist>\n");
        
        return result.data;
    }

    private void writeKeyValue(ref Appender!string result, string key, PlistValue value) {
        // Write key
        result.put(getIndent());
        result.put("<key>");
        result.put(escapeXML(key));
        result.put("</key>\n");
        
        // Write value
        writeValue(result, value);
    }

    private void writeValue(ref Appender!string result, PlistValue value) {
        result.put(getIndent());
        
        switch (value.type) {
            case PlistType.String:
                result.put("<string>");
                result.put(escapeXML(value.asString()));
                result.put("</string>\n");
                break;
                
            case PlistType.Integer:
                result.put("<integer>");
                result.put(value.asInt().to!string);
                result.put("</integer>\n");
                break;
                
            case PlistType.Float:
                result.put("<real>");
                result.put(value.asFloat().to!string);
                result.put("</real>\n");
                break;
                
            case PlistType.Boolean:
                result.put(value.asBool() ? "<true/>\n" : "<false/>\n");
                break;
                
            case PlistType.Date:
                result.put("<date>");
                result.put(value.asString());
                result.put("</date>\n");
                break;
                
            case PlistType.Data:
                result.put("<data>");
                result.put(value.asString());
                result.put("</data>\n");
                break;
                
            case PlistType.Array:
                result.put("<array>\n");
                _indentLevel++;
                foreach (item; value.asArray()) {
                    writeValue(result, item);
                }
                _indentLevel--;
                result.put(getIndent());
                result.put("</array>\n");
                break;
                
            case PlistType.Dict:
                result.put("<dict>\n");
                _indentLevel++;
                auto dict = value.asDict();
                foreach (key; dict.keys.sort) {
                    writeKeyValue(result, key, dict[key]);
                }
                _indentLevel--;
                result.put(getIndent());
                result.put("</dict>\n");
                break;
                
            default:
                throw new PlistFormatException("Unknown value type");
        }
    }

    private string getIndent() const {
        string result = "";
        for (int i = 0; i < _indentLevel; i++) {
            result ~= _indent;
        }
        return result;
    }

    private string escapeXML(string str) const {
        return str
            .replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&apos;");
    }
}

/**
 * XMLPlistParser - Parses property lists from XML format
 * 
 * Parses Apple's XML plist format (version 1.0)
 */
class XMLPlistParser {
    private string _content;
    private size_t _position;

    /**
     * Parses XML content into a PropertyList
     */
    PropertyList parse(string xmlContent) {
        _content = xmlContent;
        _position = 0;
        
        // Skip XML declaration and DOCTYPE
        skipToTag("plist");
        skipToTag("dict");
        
        auto data = parseDict();
        auto plist = new PropertyList(data);
        
        return plist;
    }

    private void skipToTag(string tagName) {
        auto searchStr = "<" ~ tagName;
        auto pos = _content.indexOf(searchStr, _position);
        if (pos < 0) {
            throw new PlistParseException("Expected tag: " ~ tagName);
        }
        _position = pos + searchStr.length;
        
        // Skip to end of opening tag
        pos = _content.indexOf(">", _position);
        if (pos < 0) {
            throw new PlistParseException("Malformed XML");
        }
        _position = pos + 1;
    }

    private PlistValue[string] parseDict() {
        PlistValue[string] result;
        
        while (true) {
            skipWhitespace();
            
            // Check for end of dict
            if (peekTag() == "</dict>") {
                consumeTag("</dict>");
                break;
            }
            
            // Parse key
            if (peekTag() != "<key>") {
                throw new PlistParseException("Expected <key>");
            }
            consumeTag("<key>");
            string key = readUntil("</key>");
            consumeTag("</key>");
            
            skipWhitespace();
            
            // Parse value
            auto value = parseValue();
            result[key] = value;
        }
        
        return result;
    }

    private PlistValue[] parseArray() {
        PlistValue[] result;
        
        while (true) {
            skipWhitespace();
            
            // Check for end of array
            if (peekTag() == "</array>") {
                consumeTag("</array>");
                break;
            }
            
            result ~= parseValue();
        }
        
        return result;
    }

    private PlistValue parseValue() {
        skipWhitespace();
        
        auto tag = peekTag();
        
        if (tag.startsWith("<string>")) {
            consumeTag("<string>");
            auto value = unescapeXML(readUntil("</string>"));
            consumeTag("</string>");
            return PlistValue(value);
        }
        else if (tag.startsWith("<integer>")) {
            consumeTag("<integer>");
            auto value = readUntil("</integer>").to!long;
            consumeTag("</integer>");
            return PlistValue(value);
        }
        else if (tag.startsWith("<real>")) {
            consumeTag("<real>");
            auto value = readUntil("</real>").to!double;
            consumeTag("</real>");
            return PlistValue(value);
        }
        else if (tag.startsWith("<true")) {
            consumeTag("<true/>");
            return PlistValue(true);
        }
        else if (tag.startsWith("<false")) {
            consumeTag("<false/>");
            return PlistValue(false);
        }
        else if (tag.startsWith("<array>")) {
            consumeTag("<array>");
            return PlistValue(parseArray());
        }
        else if (tag.startsWith("<dict>")) {
            consumeTag("<dict>");
            return PlistValue(parseDict());
        }
        else if (tag.startsWith("<data>")) {
            consumeTag("<data>");
            auto value = readUntil("</data>");
            consumeTag("</data>");
            return PlistValue(value); // Store as string, will be decoded when accessed
        }
        else {
            throw new PlistParseException("Unknown value type: " ~ tag);
        }
    }

    private void skipWhitespace() {
        while (_position < _content.length && 
               (_content[_position] == ' ' || _content[_position] == '\t' || 
                _content[_position] == '\n' || _content[_position] == '\r')) {
            _position++;
        }
    }

    private string peekTag() {
        auto startPos = _position;
        while (startPos < _content.length && _content[startPos] != '<') {
            startPos++;
        }
        
        if (startPos >= _content.length) {
            return "";
        }
        
        auto endPos = startPos + 1;
        while (endPos < _content.length && _content[endPos] != '>') {
            endPos++;
        }
        
        if (endPos >= _content.length) {
            return "";
        }
        
        return _content[startPos .. endPos + 1];
    }

    private void consumeTag(string tag) {
        skipWhitespace();
        
        if (!_content[_position .. $].startsWith(tag)) {
            throw new PlistParseException("Expected: " ~ tag);
        }
        
        _position += tag.length;
    }

    private string readUntil(string endTag) {
        auto startPos = _position;
        auto endPos = _content.indexOf(endTag, _position);
        
        if (endPos < 0) {
            throw new PlistParseException("Expected: " ~ endTag);
        }
        
        _position = endPos;
        return _content[startPos .. endPos];
    }

    private string unescapeXML(string str) const {
        return str
            .replace("&lt;", "<")
            .replace("&gt;", ">")
            .replace("&quot;", "\"")
            .replace("&apos;", "'")
            .replace("&amp;", "&");
    }
}

// Unit tests
unittest {
    auto plist = new PropertyList();
    plist.set("name", "Test");
    plist.set("count", 42);
    plist.set("active", true);
    
    auto writer = new XMLPlistWriter();
    auto xml = writer.write(plist);
    
    assert(xml.indexOf("<key>name</key>") > 0);
    assert(xml.indexOf("<string>Test</string>") > 0);
    assert(xml.indexOf("<integer>42</integer>") > 0);
}

unittest {
    auto xml = `<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>name</key>
    <string>Test</string>
    <key>count</key>
    <integer>42</integer>
</dict>
</plist>`;
    
    auto parser = new XMLPlistParser();
    auto plist = parser.parse(xml);
    
    assert(plist.getString("name") == "Test");
    assert(plist.getInt("count") == 42);
}
