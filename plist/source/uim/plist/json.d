/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.plist.json;

import uim.plist.propertylist;
import uim.plist.value;
import uim.plist.exceptions;
import std.json;
import std.conv;
import std.datetime;

@safe:

/**
 * JSONPlistConverter - Converts property lists to/from JSON format
 */
class JSONPlistConverter {
    /**
     * Converts a PropertyList to JSON format
     */
    string toJSON(const PropertyList plist) {
        JSONValue root = JSONValue.emptyObject;
        
        auto data = plist.getData();
        foreach (key, value; data) {
            root[key] = valueToJSON(value);
        }
        
        return root.toPrettyString();
    }

    /**
     * Parses a PropertyList from JSON format
     */
    PropertyList fromJSON(string jsonContent) {
        auto json = parseJSON(jsonContent);
        
        if (json.type != JSONType.object) {
            throw new PlistParseException("JSON root must be an object");
        }
        
        PlistValue[string] data;
        foreach (key, value; json.object) {
            data[key] = jsonToValue(value);
        }
        
        return new PropertyList(data);
    }

    private JSONValue valueToJSON(PlistValue value) const {
        switch (value.type) {
            case PlistType.String:
                return JSONValue(value.asString());
                
            case PlistType.Integer:
                return JSONValue(value.asInt());
                
            case PlistType.Float:
                return JSONValue(value.asFloat());
                
            case PlistType.Boolean:
                return JSONValue(value.asBool());
                
            case PlistType.Date:
                return JSONValue(value.asString());
                
            case PlistType.Data:
                // Store data as base64 string in JSON
                return JSONValue(value.asString());
                
            case PlistType.Array:
                JSONValue[] arr;
                foreach (item; value.asArray()) {
                    arr ~= valueToJSON(item);
                }
                return JSONValue(arr);
                
            case PlistType.Dict:
                JSONValue dict = JSONValue.emptyObject;
                auto dictData = value.asDict();
                foreach (key, val; dictData) {
                    dict[key] = valueToJSON(val);
                }
                return dict;
                
            default:
                throw new PlistFormatException("Unknown value type");
        }
    }

    private PlistValue jsonToValue(JSONValue json) const {
        switch (json.type) {
            case JSONType.string:
                return PlistValue(json.str);
                
            case JSONType.integer:
                return PlistValue(json.integer);
                
            case JSONType.float_:
                return PlistValue(json.floating);
                
            case JSONType.true_:
                return PlistValue(true);
                
            case JSONType.false_:
                return PlistValue(false);
                
            case JSONType.array:
                PlistValue[] arr;
                foreach (item; json.array) {
                    arr ~= jsonToValue(item);
                }
                return PlistValue(arr);
                
            case JSONType.object:
                PlistValue[string] dict;
                foreach (key, value; json.object) {
                    dict[key] = jsonToValue(value);
                }
                return PlistValue(dict);
                
            case JSONType.null_:
                return PlistValue("");
                
            default:
                throw new PlistParseException("Unsupported JSON type");
        }
    }
}

// Unit tests
unittest {
    auto plist = new PropertyList();
    plist.set("name", "Test");
    plist.set("count", 42);
    plist.set("active", true);
    plist.set("ratio", 3.14);
    
    auto converter = new JSONPlistConverter();
    auto json = converter.toJSON(plist);
    
    assert(json.indexOf("\"name\"") > 0);
    assert(json.indexOf("\"Test\"") > 0);
    assert(json.indexOf("42") > 0);
}

unittest {
    auto jsonStr = `{
        "name": "Test",
        "count": 42,
        "active": true,
        "ratio": 3.14
    }`;
    
    auto converter = new JSONPlistConverter();
    auto plist = converter.fromJSON(jsonStr);
    
    assert(plist.getString("name") == "Test");
    assert(plist.getInt("count") == 42);
    assert(plist.getBool("active") == true);
    assert(plist.getFloat("ratio") > 3.13 && plist.getFloat("ratio") < 3.15);
}

unittest {
    // Test array conversion
    auto plist = new PropertyList();
    plist.set("colors", ["red", "green", "blue"]);
    
    auto converter = new JSONPlistConverter();
    auto json = converter.toJSON(plist);
    auto loaded = converter.fromJSON(json);
    
    auto colors = loaded.getArray("colors");
    assert(colors.length == 3);
    assert(colors[0].asString() == "red");
}
