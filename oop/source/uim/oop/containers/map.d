/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.containers.map;

import uim.oop;

@safe:

/**
 * OOP wrapper for associative arrays providing map functionality
 */
class DMap(K, V) : UIMObject {
    private V[K] _data;

    this() {
        super();
        this.objName("Map");
    }

    this(V[K] initialData) {
        this();
        _data = initialData.dup;
    }

    this(string name, V[K] initialData = null) {
        this(initialData);
        this.objName(name);
    }

    // #region data
    /// Get all data
    V[K] data() {
        return _data;
    }

    /// Set all data
    DMap!(K, V) data(V[K] newData) {
        _data = newData.dup;
        return this;
    }
    // #endregion data

    // #region length
    /// Get the number of key-value pairs in the map
    size_t length() {
        return _data.length;
    }
    // #endregion length

    // #region isEmpty
    /// Check if the map is empty
    bool isEmpty() {
        return _data.length == 0;
    }
    // #endregion isEmpty

    /**
     * Set a key-value pair in the map
     */
    DMap!(K, V) set(K key, V value) {
        _data[key] = value;
        return this;
    }

    /**
     * Get the value associated with the specified key
     * Throws: RangeError if key doesn't exist
     */
    V get(K key) {
        return _data[key];
    }

    /**
     * Get the value associated with the specified key, or return default value
     */
    V get(K key, V defaultValue) {
        if (auto value = key in _data) {
            return *value;
        }
        return defaultValue;
    }

    /**
     * Check if the map contains the specified key
     */
    bool containsKey(K key) {
        return (key in _data) !is null;
    }

    /**
     * Check if the map contains the specified value
     */
    bool containsValue(V value) {
        foreach (v; _data.byValue) {
            if (v == value) return true;
        }
        return false;
    }

    /**
     * Remove the specified key and its value from the map
     * Returns: true if key was removed, false if key didn't exist
     */
    bool remove(K key) {
        if (containsKey(key)) {
            _data.remove(key);
            return true;
        }
        return false;
    }

    /**
     * Remove all key-value pairs from the map
     */
    DMap!(K, V) clear() {
        _data = null;
        return this;
    }

    /**
     * Get all keys in the map
     */
    K[] keys() {
        return _data.keys;
    }

    /**
     * Get all values in the map
     */
    V[] values() {
        return _data.values;
    }

    /**
     * Get or set the value at the specified key
     */
    V opIndex(K key) {
        return _data[key];
    }

    /// ditto
    void opIndexAssign(V value, K key) {
        _data[key] = value;
    }

    /**
     * Check if key exists using 'in' operator
     */
    inout(V)* opBinaryRight(string op : "in")(K key) inout {
        return key in _data;
    }

    /**
     * Support foreach iteration over key-value pairs
     */
    int opApply(scope int delegate(ref K, ref V) @safe dg) {
        int result = 0;
        foreach (key, ref value; _data) {
            K k = key; // Make a mutable copy
            result = dg(k, value);
            if (result) break;
        }
        return result;
    }

    /**
     * Support foreach iteration over keys
     */
    int opApply(scope int delegate(ref K) @safe dg) {
        int result = 0;
        foreach (key; _data.byKey) {
            K k = key; // Make a mutable copy
            result = dg(k);
            if (result) break;
        }
        return result;
    }

    /**
     * Convert to string representation
     */
    override string toString() {
        import std.conv : to;
        return "Map[" ~ this.objName ~ "]: " ~ _data.to!string;
    }
}

/// Factory function for creating maps
auto Map(K, V)(V[K] initialData = null) {
    return new DMap!(K, V)(initialData);
}

/// ditto
auto Map(K, V)(string name, V[K] initialData = null) {
    return new DMap!(K, V)(name, initialData);
}

unittest {
    import std.stdio : writeln;
    
    writeln("Testing DMap class...");
    
    // Test basic creation
    auto map = Map!(string, int)();
    assert(map.isEmpty());
    assert(map.length == 0);
    
    // Test set and get
    map.set("one", 1).set("two", 2).set("three", 3);
    assert(map.length == 3);
    assert(map.get("one") == 1);
    assert(map.get("three") == 3);
    
    // Test get with default
    assert(map.get("four", 0) == 0);
    
    // Test containsKey
    assert(map.containsKey("two"));
    assert(!map.containsKey("four"));
    
    // Test containsValue
    assert(map.containsValue(2));
    assert(!map.containsValue(10));
    
    // Test opIndex
    map["four"] = 4;
    assert(map["four"] == 4);
    assert(map.length == 4);
    
    // Test in operator
    assert("one" in map);
    assert("ten" !in map);
    
    // Test keys and values
    auto k = map.keys();
    auto v = map.values();
    assert(k.length == 4);
    assert(v.length == 4);
    
    // Test remove
    assert(map.remove("two"));
    assert(!map.containsKey("two"));
    assert(map.length == 3);
    assert(!map.remove("nonexistent"));
    
    // Test foreach
    int sum = 0;
    foreach (key, value; map) {
        sum += value;
    }
    assert(sum == 8); // 1 + 3 + 4
    
    // Test clear
    map.clear();
    assert(map.isEmpty());
    assert(map.length == 0);
    
    writeln("✓ DMap tests passed!");
}
