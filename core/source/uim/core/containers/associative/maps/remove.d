/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.remove;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Keys
/* 
V[K] removeKeys(K, V)(V[K] map, K[] keys, bool delegate(K) @safe removeFunc) {
  return map.removeKeys(keys).removeMap(removeFunc);
}

/** Removes entries from the map based on specified keys.

  * Params:
  *   map = The original map.
  *   keys = The keys of the entries to remove.
  *
  * Returns:
  *   A new map with the specified keys removed.
  * /
V[K] removeKeys(K, V)(V[K] map, K[] keys) {
  return removeMap(map, (K key, V value) @safe => keys.canFind(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeKey with keys");

  int[string] testMap = [ "a": 1, "b": 2, "c": 3, "d": 4 ];
  int[string] result = removeKeys(testMap, ["b", "d"]);
  int[string] expected = [ "a": 1, "c": 3 ];
  assertEquals(expected, result);
}

V[K] removeKeys(K, V)(V[K] map, bool delegate(K) @safe removeFunc) {
  V[K] results;
  foreach (key, value; map) {
    if (!removeFunc(key)) {
      results[key] = value; 
    }
  }
  return results;
}
// #endregion Keys

// #region Values
/** Removes entries from the map based on specified values.

  * Params:
  *   map = The original map.
  *   values = The values of the entries to remove.
  *
  * Returns:
  *   A new map with the specified values removed.
  * /
V[K] removeValue(K, V)(V[K] map, V[] values) {
  return removeMap(map, (K key, V value) @safe => values.canFind(value));
}
///
unittest {
  mixin(ShowTest!"Testing removeValue with values");

  int[string] testMap = [ "a": 1, "b": 2, "c": 3, "d": 4 ];
  int[string] result = removeValue(testMap, [1, 3]);
  int[string] expected = [ "b": 2, "d": 4 ];
  assertEquals(expected, result);
}
// #endregion Values

// #region Map
/** Removes entries from the map based on a custom removal function.

  * Params:
  *   map = The original map.
  *   removeFunc = A delegate function that determines whether to remove an entry.
  *                It takes a key and a value as parameters and returns true to remove the entry, false to keep it.
  *
  * Returns:
  *   A new map with the entries removed based on the custom function.
  * /
V[K] removeMap(K, V)(V[K] map, bool delegate(K key, V value) @safe removeFunc) {
  V[K] results;
  foreach (key, value; map) {
    if (!removeFunc(key, value)) {
      results[key] = value;
    }
  }
  return results;
}
///
unittest {
  mixin(ShowTest!"Testing removeMap with key-value delegate");

  int[string] testMap = [ "a": 1, "b": 2, "c": 3, "d": 4 ];

  int[string] result = removeMap(testMap, (string key, int value) @safe => key == "a" || value == 3);
  int[string] expected = [ "b": 2, "d": 4 ];
  assertEquals(expected, result);
}
// #endregion Map


V[K] removeMap(K, V)(V[K] map, bool delegate(K) @safe removeFunc) {
  V[K] results;
  foreach (key, value; map) {
    if (!removeFunc(key)) {
      results[key] = value;
    }
  }
  return results;
}
///
unittest {
  mixin(ShowTest!"Testing removeMap with key delegate");
    
  int[string] testMap = [ "a": 1, "b": 2, "c": 3, "d": 4 ];

  int[string] result = removeMap(testMap, (string key) @safe => key == "b" || key == "d");
  int[string] expected = [ "a": 1, "c": 3 ];
  assertEquals(expected, result);
}

V[K] removeMap(K, V)(V[K] map, bool delegate(V) @safe removeFunc) {
  V[K] results;
  foreach (key, value; map) {
    if (!removeFunc(value)) {
      results[key] = value;
    }
  }
  return results;
}
///
unittest {
  mixin(ShowTest!"Testing removeMap with value delegate");

  int[string] testMap = [ "a": 1, "b": 2, "c": 3, "d": 4 ];

  int[string] result = removeMap(testMap, (int value) @safe => value == 1 || value == 3);
  int[string] expected = [ "b": 2, "d": 4 ];
  assertEquals(expected, result);
}
*/