/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.containers.plist.json;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * JSONPlistConverter - Converts property lists to/from JSON format
 */
class JSONPlistConverter {
    /**
     * Converts a PropertyList to JSON format
     */
    string toJSON(const PropertyList plist) {
        Json root = Json.emptyObject;
        
        auto data = plist.getData();
        foreach (key, value; data) {
            root[key] = valueToJSON(value);
        }
        
        return root.toPrettyString();
    }

    /**
     * Parses a PropertyList from JSON format
     */
    PropertyList fromJSON(string jsonContent) @trusted {
        auto json = parseJsonString(jsonContent);
        
        if (!json.isObject) {
            throw new PlistParseException("JSON root must be an object");
        }
        
        PlistValue[string] data;
        foreach (string key, value; json) {
            data[key] = jsonToValue(value);
        }
        
        return new PropertyList(data);
    }

    private Json valueToJSON(PlistValue value) const {
        switch (value.type) {
            case PlistType.String:
                return Json(value.asString());
                
            case PlistType.Integer:
                return Json(value.asInt());
                
            case PlistType.Float:
                return Json(value.asFloat());
                
            case PlistType.Boolean:
                return Json(value.asBool());
                
            case PlistType.Date:
                return Json(value.asString());
                
            case PlistType.Data:
                // Store data as base64 string in JSON
                return Json(value.asString());
                
            case PlistType.Array:
                Json[] arr;
                foreach (item; value.asArray()) {
                    arr ~= valueToJSON(item);
                }
                return Json(arr);
                
            case PlistType.Dict:
                Json dict = Json.emptyObject;
                auto dictData = value.asDict();
                foreach (key, val; dictData) {
                    dict[key] = valueToJSON(val);
                }
                return dict;
                
            default:
                throw new PlistFormatException("Unknown value type");
        }
    }

    private PlistValue jsonToValue(Json json) const @trusted {
        switch (json.type) {
            case Json.Type.string:
                return PlistValue(json.get!string);
                
            case Json.Type.int_:
                return PlistValue(json.get!long);
                
            case Json.Type.float_:
                return PlistValue(json.get!double);
                
            case Json.Type.bool_:
                return PlistValue(json.get!bool);
                
            case Json.Type.array:
                PlistValue[] arr;
                foreach (item; json) {
                    arr ~= jsonToValue(item);
                }
                return PlistValue(arr);
                
            case Json.Type.object:
                PlistValue[string] dict;
                foreach (string key, value; json) {
                    dict[key] = jsonToValue(value);
                }
                return PlistValue(dict);
                
            case Json.Type.null_:
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
    
    assert(json.canFind("\"name\""));
    assert(json.canFind("\"Test\""));
    assert(json.canFind("42"));
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
