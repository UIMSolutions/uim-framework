/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.has;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Keys
/**
  * Checks whether all specified keys exist in the map.
  *
  * Params:
  *   items = The map to check.
  *   keys = The keys to look for.
  *
  * Returns:
  *   true if all keys exist in the map, false otherwise.
  * /
bool hasAllKey(K, V)(V[K] items, K[] keys) {
  return keys.all!(key => hasKey(items, key));
}
///
unittest {
  mixin(ShowTest!"Testing hasAllKey function");

  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasAllKey(["a", "b"]));
  assert(map.hasAllKey(["a", "b", "c"]));
  assert(!map.hasAllKey(["a", "d"]));
  assert(!map.hasAllKey(["x", "y"]));
  assert(map.hasAllKey([]));

  int[string] emptyMap;
  assert(emptyMap.hasAllKey([]));
  assert(!emptyMap.hasAllKey(["a"]));
}
/**
  * Checks whether any of the specified keys exist in the map.
  *
  * Params:
  *   items = The map to check.
  *   keys = The keys to look for.
  *
  * Returns:
  *   true if any key exists in the map, false otherwise.
  * /
bool hasAnyKey(K, V)(V[K] items, K[] keys) {
  return keys.any!(key => hasKey(items, key));
}
///
unittest {
  mixin(ShowTest!"Testing hasAnyKey function");
    
  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasAnyKey(["a", "d"]));
  assert(map.hasAnyKey(["x", "b"]));
  assert(!map.hasAnyKey(["x", "y"]));
  assert(!map.hasAnyKey([]));

  int[string] emptyMap;
  assert(!emptyMap.hasAnyKey(["a", "b"]));
}
/**
  * Checks whether a specific key exists in the map.
  *
  * Params:
  *   items = The map to check.
  *   key = The key to look for.
  *
  * Returns:
  *   true if the key exists in the map, false otherwise.
  * /
bool hasKey(K, V)(V[K] items, K key) {
  return (key in items) ? true : false;
}
///
unittest {
  mixin(ShowTest!"Testing hasKey function");

  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasKey("a"));
  assert(map.hasKey("b"));
  assert(map.hasKey("c"));
  assert(!map.hasKey("d"));
  assert(!map.hasKey(""));

  int[string] emptyMap;
  assert(!emptyMap.hasKey("a"));
}
// #endregion Keys

// #region Values
/**
  * Checks whether all specified values exist in the map.
  *
  * Params:
  *   items = The map to check.
  *   values = The values to look for.
  *
  * Returns:
  *   true if all values exist in the map, false otherwise.
  * /
bool hasAllValue(K, V)(V[K] items, V[] values) {
  return values.all!(value => hasValue(items, value));
}
///
unittest {
  mixin(ShowTest!"Testing hasAllValue function");

  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasAllValue([1, 2]));
  assert(map.hasAllValue([1, 2, 3]));
  assert(!map.hasAllValue([1, 4]));
  assert(!map.hasAllValue([5, 6]));
  assert(map.hasAllValue([]));

  int[string] emptyMap;
  assert(emptyMap.hasAllValue([]));
  assert(!emptyMap.hasAllValue([1]));
}

/**
  * Checks whether any of the specified values exist in the map.
  *
  * Params:
  *   items = The map to check.
  *   values = The values to look for.
  *
  * Returns:
  *   true if any value exists in the map, false otherwise.
  * /
bool hasAnyValue(K, V)(V[K] items, V[] values) {
  return values.any!(value => hasValue(items, value));
}
///
unittest {
  mixin(ShowTest!"Testing hasAnyValue function");

  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasAnyValue([1, 4]));
  assert(map.hasAnyValue([5, 2]));
  assert(!map.hasAnyValue([5, 6]));
  assert(!map.hasAnyValue([]));

  int[string] emptyMap;
  assert(!emptyMap.hasAnyValue([1, 2]));
}

/**
  * Checks whether a specific value exists in the map.
  *
  * Params:
  *   items = The map to check.
  *   value = The value to look for.
  *
  * Returns:
  *   true if the value exists in the map, false otherwise.
  * /
bool hasValue(K, V)(V[K] map, V value) {
  return map.hasItem((K k, V v) => v == value);
}
///
unittest {
  mixin(ShowTest!"Testing hasValue function");

  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasValue(1));
  assert(map.hasValue(2));
  assert(map.hasValue(3));
  assert(!map.hasValue(4));
  assert(!map.hasValue(0));

  int[string] emptyMap;
  assert(!emptyMap.hasValue(1));
}
// #endregion Values

// #region Items
/** 
  * Checks whether any item in the map satisfies the provided condition.
  *
  * Params:
  *   map = The map to check.
  *   hasFunc = A delegate function that takes a key and value, returning true if the condition is met.
  *
  * Returns:
  *   true if any item satisfies the condition, false otherwise.
  * /
bool hasItem(K, V)(V[K] map, bool delegate(K key, V value) @safe hasFunc) {
  foreach (k, v; map) {
    if (hasFunc(k, v)) {
      return true;
    }
  }
  return false;
}
///
unittest {
  mixin(ShowTest!"Testing hasItem function");

  // Test hasItem - basic functionality
  auto map = ["a": 1, "b": 2, "c": 3];

  // Should find item matching predicate
  assert(map.hasItem((string k, int v) => v == 2));
  assert(map.hasItem((string k, int v) => k == "c"));

  // Should not find item when predicate doesn't match
  assert(!map.hasItem((string k, int v) => v == 5));
  assert(!map.hasItem((string k, int v) => k == "z"));

  // Test with complex predicate
  assert(map.hasItem((string k, int v) => v > 1 && k == "b"));
  assert(!map.hasItem((string k, int v) => v > 1 && k == "a"));

  // Test with empty map
  int[string] emptyMap;
  assert(!emptyMap.hasItem((string k, int v) => true));

  // Test that returns true on first match (doesn't iterate all)
  int callCount = 0;
  auto testMap = ["x": 10, "y": 20, "z": 30];
  testMap.hasItem((string k, int v) {
    callCount++;
    return v == 10; // Matches first item
  });
  assert(callCount >= 1); // Should stop after finding match
}
// #endregion Items

bool hasKeyValue(K, V)(V[K] map, K key, V value) {
  return map.hasKey(key) ? map[key] == value : false;
}
///
unittest {
  mixin(ShowTest!"Testing hasKeyValue function");

  auto map = ["a": 1, "b": 2, "c": 3];

  assert(map.hasKeyValue("a", 1));
  assert(map.hasKeyValue("b", 2));
  assert(!map.hasKeyValue("c", 2));
  assert(!map.hasKeyValue("d", 4));

  int[string] emptyMap;
  assert(!emptyMap.hasKeyValue("a", 1));
}
*/
/* 
bool hasValue(V)(V[] values, V value) {
  return values.any!(v => v == value);
} */
bool hasValue(K, V)(V[K] map, V value) {
  return map.byKeyValue.any!(v => v == value);
}