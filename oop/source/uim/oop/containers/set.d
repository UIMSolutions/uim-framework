/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.containers.set;

import uim.oop;

@safe:

/**
 * OOP wrapper for sets providing unique element collection functionality
 * Uses associative array internally for O(1) lookup
 */
class DSet(T) : UIMObject {
    private bool[T] _items;

    this() {
        super();
        this.objName("Set");
    }

    this(T[] initialItems) {
        this();
        foreach (item; initialItems) {
            _items[item] = true;
        }
    }

    this(string name, T[] initialItems = null) {
        this(initialItems);
        this.objName(name);
    }

    // #region items
    /// Get all items as an array
    T[] items() {
        return _items.keys;
    }

    /// Set items from array (duplicates will be removed)
    DSet!T items(T[] newItems) {
        _items = null;
        foreach (item; newItems) {
            _items[item] = true;
        }
        return this;
    }
    // #endregion items

    // #region length
    /// Get the number of items in the set
    size_t length() {
        return _items.length;
    }
    // #endregion length

    // #region isEmpty
    /// Check if the set is empty
    bool isEmpty() {
        return _items.length == 0;
    }
    // #endregion isEmpty

    /**
     * Add an item to the set
     * Returns: true if item was added, false if it already existed
     */
    bool add(T item) {
        if (item in _items) {
            return false;
        }
        _items[item] = true;
        return true;
    }

    /**
     * Add multiple items to the set
     * Returns: number of items actually added (excluding duplicates)
     */
    size_t addRange(T[] items) {
        size_t added = 0;
        foreach (item; items) {
            if (add(item)) {
                added++;
            }
        }
        return added;
    }

    /**
     * Remove an item from the set
     * Returns: true if item was removed, false if it didn't exist
     */
    bool remove(T item) {
        if (item in _items) {
            _items.remove(item);
            return true;
        }
        return false;
    }

    /**
     * Remove all items from the set
     */
    DSet!T clear() {
        _items = null;
        return this;
    }

    /**
     * Check if the set contains the specified item
     */
    bool contains(T item) {
        return (item in _items) !is null;
    }

    /**
     * Check if this set is a subset of another set
     */
    bool isSubsetOf(DSet!T other) {
        foreach (item; _items.byKey) {
            if (!other.contains(item)) {
                return false;
            }
        }
        return true;
    }

    /**
     * Check if this set is a superset of another set
     */
    bool isSupersetOf(DSet!T other) {
        return other.isSubsetOf(this);
    }

    /**
     * Create a new set containing the union of this set and another
     */
    DSet!T union_(DSet!T other) {
        auto result = new DSet!T(this.items());
        result.addRange(other.items());
        return result;
    }

    /**
     * Create a new set containing the intersection of this set and another
     */
    DSet!T intersection(DSet!T other) {
        auto result = new DSet!T();
        foreach (item; _items.byKey) {
            if (other.contains(item)) {
                result.add(item);
            }
        }
        return result;
    }

    /**
     * Create a new set containing items in this set but not in another
     */
    DSet!T difference(DSet!T other) {
        auto result = new DSet!T();
        foreach (item; _items.byKey) {
            if (!other.contains(item)) {
                result.add(item);
            }
        }
        return result;
    }

    /**
     * Create a new set containing items in either set but not both
     */
    DSet!T symmetricDifference(DSet!T other) {
        auto result = new DSet!T();
        
        // Add items from this set not in other
        foreach (item; _items.byKey) {
            if (!other.contains(item)) {
                result.add(item);
            }
        }
        
        // Add items from other set not in this
        foreach (item; other.items()) {
            if (!this.contains(item)) {
                result.add(item);
            }
        }
        
        return result;
    }

    /**
     * Support 'in' operator
     */
    bool opBinaryRight(string op : "in")(T item) {
        return contains(item);
    }

    /**
     * Support foreach iteration
     */
    int opApply(scope int delegate(ref T) @safe dg) {
        int result = 0;
        foreach (item; _items.byKey) {
            T t = item; // Make a mutable copy
            result = dg(t);
            if (result) break;
        }
        return result;
    }

    /**
     * Convert to string representation
     */
    override string toString() {
        import std.conv : to;
        import std.algorithm : sort;
        auto sorted = items().sort;
        return "Set[" ~ this.objName ~ "]: {" ~ sorted.to!string ~ "}";
    }
}

/// Factory function for creating sets
auto Set(T)(T[] initialItems = null) {
    return new DSet!T(initialItems);
}

/// ditto
auto Set(T)(string name, T[] initialItems = null) {
    return new DSet!T(name, initialItems);
}

unittest {
    import std.stdio : writeln;
    
    writeln("Testing DSet class...");
    
    // Test basic creation
    auto set = Set!int();
    assert(set.isEmpty());
    assert(set.length == 0);
    
    // Test add (unique items only)
    assert(set.add(1));
    assert(set.add(2));
    assert(set.add(3));
    assert(!set.add(2)); // Duplicate
    assert(set.length == 3);
    
    // Test contains
    assert(set.contains(2));
    assert(!set.contains(10));
    
    // Test in operator
    assert(1 in set);
    assert(10 !in set);
    
    // Test remove
    assert(set.remove(2));
    assert(!set.contains(2));
    assert(set.length == 2);
    assert(!set.remove(100));
    
    // Test addRange
    set.clear();
    size_t added = set.addRange([1, 2, 3, 2, 1]);
    assert(added == 3); // Only 3 unique items
    assert(set.length == 3);
    
    // Test union
    auto set2 = Set!int([3, 4, 5]);
    auto unionSet = set.union_(set2);
    assert(unionSet.length == 5);
    assert(unionSet.contains(1));
    assert(unionSet.contains(5));
    
    // Test intersection
    auto intersect = set.intersection(set2);
    assert(intersect.length == 1);
    assert(intersect.contains(3));
    
    // Test difference
    auto diff = set.difference(set2);
    assert(diff.length == 2);
    assert(diff.contains(1));
    assert(diff.contains(2));
    assert(!diff.contains(3));
    
    // Test symmetric difference
    auto symDiff = set.symmetricDifference(set2);
    assert(symDiff.length == 4);
    assert(symDiff.contains(1));
    assert(symDiff.contains(2));
    assert(symDiff.contains(4));
    assert(symDiff.contains(5));
    assert(!symDiff.contains(3));
    
    // Test subset/superset
    auto subset = Set!int([1, 2]);
    assert(subset.isSubsetOf(set));
    assert(set.isSupersetOf(subset));
    assert(!set.isSubsetOf(subset));
    
    // Test foreach
    int sum = 0;
    foreach (item; set) {
        sum += item;
    }
    assert(sum == 6); // 1 + 2 + 3
    
    // Test clear
    set.clear();
    assert(set.isEmpty());
    
    writeln("✓ DSet tests passed!");
}
