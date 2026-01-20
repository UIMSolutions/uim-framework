/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.pairs;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  * Converts a map into an array of key-value pairs.
  * Each pair is represented as a two-element array where the first element is the key and the second is the value.
  * If the input map is empty, an empty array is returned.
  *
  * Params:
  *   K = Type of the keys in the map.
  *   V = Type of the values in the map.
  *   map = The input map to be converted into pairs.
  *
  * Returns:
  *   An array of key-value pairs. Each pair is a two-element array [key, value].
  *   If the input map is empty, returns an empty array.
  */
auto pairs(K, V)(V[K] map) {
  V[K][] results;
  foreach (k, v; map) {
    results = results ~ [k: v];
  }
  return results;
}
/// 
unittest {
  // Test with int keys and string values
  int[string] map1 = ["a": 1, "b": 2, "c": 3];
  auto result1 = pairs(map1);
  assert(result1.length == 3);

  // Test with empty map
  int[string] map2;
  auto result2 = pairs(map2);
  assert(result2.length == 0);

  // Test with int keys and double values
  double[int] map3 = [1: 1.1, 2: 2.2];
  auto result3 = pairs(map3);
  assert(result3.length == 2);

  // Test with string keys and string values
  string[string] map4 = ["x": "y", "z": "w"];
  auto result4 = pairs(map4);
  assert(result4.length == 2);
}

/**
  * Converts an array of maps into a single array of key-value pairs.
  * Each pair is represented as a two-element array where the first element is the key and the second is the value.
  * If the input array is empty, null is returned.
  *
  * Params:
  *   K = Type of the keys in the maps.
  *   V = Type of the values in the maps.
  *   maps = The input array of maps to be converted into pairs.
  *
  * Returns:
  *   An array of key-value pairs. Each pair is a two-element array [key, value].
  *   If the input array is empty, returns null.
  */
auto pairsMany(K, V)(V[K][] maps) {
  V[K][] results;
  maps.each!(map => results ~= pairs(map));
  return results;
}
/// 
unittest {
  // Test pairsMany with multiple maps
  int[string][] maps1 = [
    ["a": 1, "b": 2],
    ["c": 3]
  ];
  auto result1 = pairsMany(maps1);
  assert(result1.length == 3);

  // Test pairsMany with empty array of maps
  int[string][] maps2;
  auto result2 = pairsMany(maps2);
  assert(result2 is null);

  // Test pairsMany with array containing empty maps
  int[string][] maps3 = [
    ["x": 10],
    ["y": 20]
  ];
  auto result3 = pairsMany(maps3);
  assert(result3.length == 2);

  // Test pairsMany with different value types
  double[int][] maps4 = [
    [1: 1.1],
    [2: 2.2, 3: 3.3]
  ];
  auto result4 = pairsMany(maps4);
  assert(result4.length == 3);
}

/** 
  * Extracts all keys from an array of maps and returns them as a single array.
  * If the input array is empty, an empty array is returned.
  *
  * Params:
  *   K = Type of the keys in the maps.
  *   V = Type of the values in the maps.
  *   maps = The input array of maps from which to extract keys.
  *
  * Returns:
  *   An array containing all keys from the input maps.
  *   If the input array is empty, returns an empty array.
  */
auto pairKeys(K, V)(V[K][] maps) {
  K[] results;
  maps.each!(map => results ~= map.keys.array);
  return results;
}
///
unittest {
  // Test pairKeys with pairs from int[string] maps
  int[string] map1 = ["a": 1, "b": 2, "c": 3];
  auto pairs1 = pairs(map1);
  auto keys1 = pairKeys(pairs1);
  assert(keys1.length == 3);
  assert(keys1.hasAll(["a", "b", "c"]));

  // Test pairKeys with empty pairs array
  int[string] map2;
  auto pairs2 = pairs(map2);
  auto keys2 = pairKeys(pairs2);
  assert(keys2.length == 0);

  // Test pairKeys with double[int] maps
  double[int] map3 = [1: 1.1, 2: 2.2];
  auto pairs3 = pairs(map3);
  auto keys3 = pairKeys(pairs3);
  assert(keys3.length == 2);
  assert(keys3.hasAll([1, 2]));

  // Test pairKeys with string[string] maps
  string[string] map4 = ["x": "y", "z": "w"];
  auto pairs4 = pairs(map4);
  auto keys4 = pairKeys(pairs4);
  assert(keys4.length == 2);
  assert(keys4.hasAll(["x", "z"]));
}

/** 
  * Extracts all values from an array of maps and returns them as a single array.
  * If the input array is empty, an empty array is returned.
  *
  * Params:
  *   K = Type of the keys in the maps.
  *   V = Type of the values in the maps.
  *   maps = The input array of maps from which to extract values.
  *
  * Returns:
  *   An array containing all values from the input maps.
  *   If the input array is empty, returns an empty array.
  */
auto pairValues(K, V)(V[K][] maps) {
  V[] results;
  maps.each!(map => results ~= map.values.array);
  return results;
}
///
unittest {
  // Test pairValues with pairs from int[string] maps
  int[string] map1 = ["a": 1, "b": 2, "c": 3];
  auto pairs1 = pairs(map1);
  auto values1 = pairValues(pairs1);
  assert(values1.length == 3);
  assert(values1.hasAll([1, 2, 3]));

  // Test pairValues with empty pairs array
  int[string] map2;
  auto pairs2 = pairs(map2);
  auto values2 = pairValues(pairs2);
  assert(values2.length == 0);

  // Test pairValues with double[int] maps
  double[int] map3 = [1: 1.1, 2: 2.2];
  auto pairs3 = pairs(map3);
  auto values3 = pairValues(pairs3);
  assert(values3.length == 2);
  assert(values3.hasAll([1.1, 2.2]));

  // Test pairValues with string[string] maps
  string[string] map4 = ["x": "y", "z": "w"];
  auto pairs4 = pairs(map4);
  auto values4 = pairValues(pairs4);
  assert(values4.length == 2);
  assert(values4.hasAll(["y", "w"]));
}
