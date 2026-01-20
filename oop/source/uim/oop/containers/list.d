/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.containers.list;

import uim.oop;

@safe:

/**
 * OOP wrapper for dynamic arrays providing list functionality
 */
class DList(T) : UIMObject {
    private T[] _items;

    this() {
        super();
        this.objName("List");
    }

    this(T[] initialItems) {
        this();
        _items = initialItems.dup;
    }

    this(string name, T[] initialItems = null) {
        this(initialItems);
        this.objName(name);
    }

    // #region items
    /// Get all items
    T[] items() {
        return _items;
    }

    /// Set all items
    DList!T items(T[] newItems) {
        _items = newItems.dup;
        return this;
    }
    // #endregion items

    // #region length
    /// Get the number of items in the list
    size_t length() {
        return _items.length;
    }
    // #endregion length

    // #region isEmpty
    /// Check if the list is empty
    bool isEmpty() {
        return _items.length == 0;
    }
    // #endregion isEmpty

    /**
     * Add an item to the end of the list
     */
    DList!T add(T item) {
        _items ~= item;
        return this;
    }

    /**
     * Add multiple items to the end of the list
     */
    DList!T addRange(T[] items) {
        _items ~= items;
        return this;
    }

    /**
     * Insert an item at the specified index
     */
    DList!T insert(size_t index, T item) {
        if (index >= _items.length) {
            _items ~= item;
        } else {
            _items = _items[0..index] ~ item ~ _items[index..$];
        }
        return this;
    }

    /**
     * Remove the first occurrence of the specified item
     * Returns: true if item was removed, false otherwise
     */
    bool remove(T item) {
        import std.algorithm : countUntil, remove;
        auto index = _items.countUntil(item);
        if (index >= 0) {
            _items = _items.remove(index);
            return true;
        }
        return false;
    }

    /**
     * Remove the item at the specified index
     */
    DList!T removeAt(size_t index) {
        import std.algorithm : remove;
        if (index < _items.length) {
            _items = _items.remove(index);
        }
        return this;
    }

    /**
     * Remove all items from the list
     */
    DList!T clear() {
        _items = [];
        return this;
    }

    /**
     * Check if the list contains the specified item
     */
    bool contains(T item) {
        import std.algorithm : canFind;
        return _items.canFind(item);
    }

    /**
     * Get the index of the first occurrence of the specified item
     * Returns: -1 if not found
     */
    ptrdiff_t indexOf(T item) {
        import std.algorithm : countUntil;
        return _items.countUntil(item);
    }

    /**
     * Get or set the item at the specified index
     */
    T opIndex(size_t index) {
        return _items[index];
    }

    /// ditto
    void opIndexAssign(T value, size_t index) {
        _items[index] = value;
    }

    /**
     * Support foreach iteration
     */
    int opApply(scope int delegate(ref T) @safe dg) {
        int result = 0;
        foreach (ref item; _items) {
            result = dg(item);
            if (result) break;
        }
        return result;
    }

    /**
     * Support foreach with index
     */
    int opApply(scope int delegate(size_t, ref T) @safe dg) {
        int result = 0;
        foreach (index, ref item; _items) {
            result = dg(index, item);
            if (result) break;
        }
        return result;
    }

    /**
     * Convert to string representation
     */
    override string toString() {
        import std.conv : to;
        return "List[" ~ this.objName ~ "]: " ~ _items.to!string;
    }
}

/// Factory function for creating lists
auto List(T)(T[] initialItems = null) {
    return new DList!T(initialItems);
}

/// ditto
auto List(T)(string name, T[] initialItems = null) {
    return new DList!T(name, initialItems);
}

unittest {
    import std.stdio : writeln;
    
    writeln("Testing DList class...");
    
    // Test basic creation
    auto list = List!int();
    assert(list.isEmpty());
    assert(list.length == 0);
    
    // Test add
    list.add(1).add(2).add(3);
    assert(list.length == 3);
    assert(list[0] == 1);
    assert(list[2] == 3);
    
    // Test contains
    assert(list.contains(2));
    assert(!list.contains(10));
    
    // Test indexOf
    assert(list.indexOf(2) == 1);
    assert(list.indexOf(10) == -1);
    
    // Test insert
    list.insert(1, 5);
    assert(list[1] == 5);
    assert(list.length == 4);
    
    // Test remove
    assert(list.remove(5));
    assert(list.length == 3);
    assert(!list.remove(100));
    
    // Test removeAt
    list.removeAt(0);
    assert(list[0] == 2);
    assert(list.length == 2);
    
    // Test clear
    list.clear();
    assert(list.isEmpty());
    
    // Test addRange
    list.addRange([10, 20, 30]);
    assert(list.length == 3);
    assert(list[1] == 20);
    
    // Test foreach
    int sum = 0;
    foreach (item; list) {
        sum += item;
    }
    assert(sum == 60);
    
    writeln("✓ DList tests passed!");
}
