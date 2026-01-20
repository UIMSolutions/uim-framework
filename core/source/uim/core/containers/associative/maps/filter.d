/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.filter;

import uim.core;

mixin(ShowModule!());

@safe:

/* 
// #region filterKeys
/**
  * Filters the map by the specified keys and an optional filter function.
  *
  * Params:
  *   items = The map to filter.
  *   keys = The keys to consider for filtering.
  *   filterFunc = An optional delegate that takes a key and returns true if the key should be included.
  *
  * Returns:
  *   A new map containing only the entries with the specified keys that pass the filter function.
  * /
V[K] filterKeys(K, V)(V[K] map, K[] keys, bool delegate(K) @safe filterFunc) {
  V[K] results;
  foreach (key; keys) {
    if (filterFunc(key)) {
      results[key] = map[key];
    }
  }
  return results;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterKeys with keys and filterFunc");

  int[string] map = ["one": 1, "two": 2, "three": 3, "four": 4];
  auto filtered = map.filterKeys(["two", "three", "five"],
    (string key) @safe => key.length == 3);
  assert(filtered.length == 1 && hasKey(filtered, "two") && filtered["two"] == 2);
  assert(!filtered.hasAnyKey(["one", "three", "four"]));
}

/**
  * Filters the map by the specified keys.
  *
  * Params:
  *   items = The map to filter.
  *   keys = The keys to consider for filtering.
  *
  * Returns:
  *   A new map containing only the entries with the specified keys.
  * /  
V[K] filterKeys(K, V)(V[K] map, K[] keys) {
  V[K] results;
  foreach (key; keys) {
    if (map.hasKey(key)) {
      results[key] = map[key];
    }
  }
  return results;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterKeys with keys");

  int[string] map = ["one": 1, "two": 2, "three": 3, "four": 4];
  auto filtered = map.filterKeys(["two", "three", "five"]);
  assert(filtered.length == 2 && filtered.hasAllKey(["two", "three"]) && !filtered.hasKey("five"));
  assert(filtered["two"] == 2 && filtered["three"] == 3);
}

/**
  * Filters the map by an optional filter function applied to keys.
  *
  * Params:
  *   items = The map to filter.
  *   filterFunc = A delegate that takes a key and returns true if the key should be included.
  *
  * Returns:
  *   A new map containing only the entries whose keys pass the filter function.
  * /
V[K] filterKeys(K, V)(V[K] map, bool delegate(K) @safe filterFunc) {
  return map.filterMap((K key, V value) => filterFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterKeys with filterFunc");

  int[string] map = ["one": 1, "two": 2, "three": 3, "four": 4];
  auto filtered = map.filterKeys((string key) @safe => key.length == 3);
  assert(filtered.length == 2 && filtered.hasAllKey(["one", "two"]) && !filtered.hasAnyKey(["three", "four"]));
  assert(filtered["one"] == 1 && filtered["two"] == 2);
}
// #endregion filterKeys

// #region filterValues
/** 
  * Filters the map by the specified values and an optional filter function.
  *
  * Params:
  *   items = The map to filter.
  *   values = The values to consider for filtering.
  *   filterFunc = An optional delegate that takes a value and returns true if the value should be included.
  *
  * Returns:
  *   A new map containing only the entries with the specified values that pass the filter function.
  * /
V[K] filterValues(K, V)(V[K] map, V[] values, bool delegate(V) @safe filterFunc) {
  return map.filterValues(values).filterValues(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterValues with values and filterFunc");

  string[string] map = ["a": "apple", "b": "banana", "c": "cherry", "d": "date"];
  auto filtered = map.filterValues(["banana", "cherry", "fig"],
    (string value) @safe => value.length > 5);
  assert(filtered.length == 2 && filtered.hasAllValue(["banana", "cherry"]) && !filtered.hasValue("fig"));
}

/** 
  * Filters the map by the specified values.
  *
  * Params:
  *   items = The map to filter.
  *   values = The values to consider for filtering.
  *
  * Returns:
  *   A new map containing only the entries with the specified values.
  * /
V[K] filterValues(K, V)(V[K] map, V[] values) {
  return map.filterMap((K key, V value) => values.canFind(value));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterValues with values");

  string[string] map = ["a": "apple", "b": "banana", "c": "cherry", "d": "date"];
  auto filtered = map.filterValues(["banana", "cherry", "fig"]);
  assert(filtered.length == 2 && filtered.hasAllValue(["banana", "cherry"]) && !filtered.hasValue("fig"));
  assert(filtered["b"] == "banana" && filtered["c"] == "cherry");
}

/** 
  * Filters the map by an optional filter function applied to values.
  *
  * Params:
  *   items = The map to filter.
  *   filterFunc = A delegate that takes a value and returns true if the value should be included.
  *
  * Returns:
  *   A new map containing only the entries whose values pass the filter function.
  * /
V[K] filterValues(K, V)(V[K] map, bool delegate(V) @safe filterFunc) {
  return map.filterMap((K key, V value) => filterFunc(value));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterValues with filterFunc");

  string[string] map = ["a": "apple", "b": "banana", "c": "cherry", "d": "date"];
  auto filtered = map.filterValues((string value) @safe => value.length == 5);
  assert(filtered.length == 1 && filtered.hasAllValue(["apple"]) && !filtered.hasAnyValue(["cherry", "banana", "date"]));
}
// #endregion filterValues

// #region filterMap
/** 
  * Filters the map by the specified filtering map and an optional filter function.
  *
  * Params:
  *   items = The map to filter.
  *   filteringMap = The map containing key-value pairs to consider for filtering.
  *   filterFunc = An optional delegate that takes a key and value and returns true if the entry should be included.
  *
  * Returns:
  *   A new map containing only the entries present in the filtering map that pass the filter function.
  * /
V[K] filterMap(K, V)(V[K] map, V[K] filteringMap, bool delegate(K, V) @safe filterFunc) {
  return map.filterMap(filteringMap).filterMap(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterMap with filteringMap and filterFunc");

  string[string] map = ["a": "apple", "b": "banana", "c": "cherry", "d": "date"];
  auto filtered = map.filterMap(["b": "banana", "c": "cherry", "e": "elderberry"],
    (string key, string value) @safe => value.length > 5);
  assert(filtered.length == 2 && filtered.hasAllKey(["b", "c"]) && !filtered.hasKey("e"));
}

/** 
  * Filters the map by the specified filtering map.
  *
  * Params:
  *   items = The map to filter.
  *   filteringMap = The map containing key-value pairs to consider for filtering.
  *
  * Returns:
  *   A new map containing only the entries present in the filtering map.
  * /
V[K] filterMap(K, V)(V[K] map, V[K] filteringMap) {
  V[K] results;
  foreach (key, value; filteringMap) {
    if (map.hasKey(key) && map[key] == value) {
      results[key] = value;
    }
  }
  return results;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterMap with filterFunc");

  string[string] map = ["a": "apple", "b": "banana", "c": "cherry", "d": "date"];
  auto filtered = map.filterMap((string key, string value) @safe => value.length > 5);
  assert(filtered.length == 2 && filtered.hasAllValue(["banana", "cherry"]) && !filtered.hasAnyValue(["apple", "date"]));
  assert(filtered["b"] == "banana" && filtered["c"] == "cherry");
}

/** 
  * Filters the map by an optional filter function applied to keys and values.
  *
  * Params:
  *   items = The map to filter.
  *   filterFunc = A delegate that takes a key and value and returns true if the entry should be included.
  *
  * Returns:
  *   A new map containing only the entries whose keys and values pass the filter function.
  * /
V[K] filterMap(K, V)(V[K] map, bool delegate(K, V) @safe filterFunc) {
  V[K] results;
  foreach (key, value; map) {
    if (filterFunc(key, value)) {
      results[key] = value;
    }
  }
  return results;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterMap with filterFunc");

  string[string] map = ["a": "apple", "b": "banana", "c": "cherry", "d": "date"];
  auto filtered = map.filterMap((string key, string value) @safe => value.length == 5);
  assert(filtered.length == 1 && filtered.hasAllValue(["apple"]) && !filtered.hasAnyValue(["banana", "cherry", "date"]));
  assert(filtered["a"] == "apple");
}
// #endregion filterMap
*/