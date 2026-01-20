/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.plist.propertylist;

import uim.plist.value;
import uim.plist.exceptions;
import std.conv;
import std.algorithm;
import std.array;
import std.string;

@safe:

/**
 * PropertyList - Main class for working with property lists
 * 
 * A property list is a dictionary-based data structure that stores
 * key-value pairs. This implementation supports various data types
 * and provides convenient methods for accessing and manipulating data.
 */
class PropertyList {
    private PlistValue[string] _data;
    private string _description;
    private string _version;

    /**
     * Constructor
     */
    this() {
        _version = "1.0";
    }

    /**
     * Constructor with initial data
     */
    this(PlistValue[string] initialData) {
        _data = initialData.dup;
        _version = "1.0";
    }

    /**
     * Sets the description of this property list
     */
    void setDescription(string desc) {
        _description = desc;
    }

    /**
     * Gets the description of this property list
     */
    string getDescription() const {
        return _description;
    }

    /**
     * Sets the version of this property list
     */
    void setVersion(string ver) {
        _version = ver;
    }

    /**
     * Gets the version of this property list
     */
    string getVersion() const {
        return _version;
    }

    /**
     * Sets a value for the specified key
     */
    void set(T)(string key, T value) {
        static if (is(T == string)) {
            _data[key] = PlistValue(value);
        } else static if (is(T == int) || is(T == long)) {
            _data[key] = PlistValue(cast(long)value);
        } else static if (is(T == double) || is(T == float)) {
            _data[key] = PlistValue(cast(double)value);
        } else static if (is(T == bool)) {
            _data[key] = PlistValue(value);
        } else static if (is(T == PlistValue)) {
            _data[key] = value;
        } else static if (is(T == PlistValue[])) {
            _data[key] = PlistValue(value);
        } else static if (is(T == PlistValue[string])) {
            _data[key] = PlistValue(value);
        } else static if (is(T == string[])) {
            PlistValue[] arr;
            foreach (str; value) {
                arr ~= PlistValue(str);
            }
            _data[key] = PlistValue(arr);
        } else {
            static assert(false, "Unsupported type for PropertyList.set: " ~ T.stringof);
        }
    }

    /**
     * Gets a value for the specified key
     */
    PlistValue get(string key) const {
        if (key !in _data) {
            throw new PlistKeyException(key);
        }
        return _data[key];
    }

    /**
     * Gets a value with a default if key doesn't exist
     */
    PlistValue get(string key, PlistValue defaultValue) const {
        if (key in _data) {
            return _data[key];
        }
        return defaultValue;
    }

    /**
     * Gets a string value
     */
    string getString(string key) const {
        return get(key).asString();
    }

    /**
     * Gets a string value with default
     */
    string getString(string key, string defaultValue) const {
        if (key in _data) {
            return _data[key].asString();
        }
        return defaultValue;
    }

    /**
     * Gets an integer value
     */
    long getInt(string key) const {
        return get(key).asInt();
    }

    /**
     * Gets an integer value with default
     */
    long getInt(string key, long defaultValue) const {
        if (key in _data) {
            return _data[key].asInt();
        }
        return defaultValue;
    }

    /**
     * Gets a float value
     */
    double getFloat(string key) const {
        return get(key).asFloat();
    }

    /**
     * Gets a float value with default
     */
    double getFloat(string key, double defaultValue) const {
        if (key in _data) {
            return _data[key].asFloat();
        }
        return defaultValue;
    }

    /**
     * Gets a boolean value
     */
    bool getBool(string key) const {
        return get(key).asBool();
    }

    /**
     * Gets a boolean value with default
     */
    bool getBool(string key, bool defaultValue) const {
        if (key in _data) {
            return _data[key].asBool();
        }
        return defaultValue;
    }

    /**
     * Gets an array value
     */
    PlistValue[] getArray(string key) const {
        return get(key).asArray();
    }

    /**
     * Gets a dictionary value
     */
    PlistValue[string] getDict(string key) const {
        return get(key).asDict();
    }

    /**
     * Checks if a key exists
     */
    bool has(string key) const {
        return (key in _data) !is null;
    }

    /**
     * Removes a key
     */
    void remove(string key) {
        _data.remove(key);
    }

    /**
     * Gets all keys
     */
    string[] keys() const {
        return _data.keys;
    }

    /**
     * Gets the number of items
     */
    size_t length() const {
        return _data.length;
    }

    /**
     * Clears all data
     */
    void clear() {
        _data.clear();
    }

    /**
     * Merges another property list into this one
     */
    void merge(PropertyList other) {
        foreach (key, value; other._data) {
            _data[key] = value;
        }
    }

    /**
     * Gets the underlying data
     */
    PlistValue[string] getData() const {
        return _data.dup;
    }

    /**
     * Converts to a simple string representation
     */
    override string toString() const {
        auto result = appender!string();
        result.put("PropertyList(");
        result.put(_data.length.to!string);
        result.put(" items)");
        return result.data;
    }
}

// Unit tests
unittest {
    auto plist = new PropertyList();
    
    // Test basic set/get
    plist.set("name", "Test");
    assert(plist.has("name"));
    assert(plist.getString("name") == "Test");
    
    // Test integer
    plist.set("count", 42);
    assert(plist.getInt("count") == 42);
    
    // Test boolean
    plist.set("active", true);
    assert(plist.getBool("active") == true);
    
    // Test array
    plist.set("colors", ["red", "green", "blue"]);
    auto colors = plist.getArray("colors");
    assert(colors.length == 3);
    assert(colors[0].asString() == "red");
    
    // Test remove
    plist.remove("active");
    assert(!plist.has("active"));
    
    // Test keys
    auto keys = plist.keys();
    assert(keys.length == 3); // name, count, colors
}

unittest {
    // Test default values
    auto plist = new PropertyList();
    
    assert(plist.getString("missing", "default") == "default");
    assert(plist.getInt("missing", 99) == 99);
    assert(plist.getBool("missing", true) == true);
}

unittest {
    // Test merge
    auto plist1 = new PropertyList();
    plist1.set("key1", "value1");
    
    auto plist2 = new PropertyList();
    plist2.set("key2", "value2");
    
    plist1.merge(plist2);
    
    assert(plist1.has("key1"));
    assert(plist1.has("key2"));
}
