/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.count;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region Json with indices and delegate
/**
  * Counts the number of elements in a Json array at the specified indices
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of elements at the specified indices that satisfy the delegate.
  */
size_t countIndices(Json json, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  return json.isArray ? json.toArray.countIndices(indices, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countIndices with indices and delegate");

  auto j1 = 42.toJson;
  auto j2 = "string".toJson;
  auto j3 = [1, 2].toJson;

  Json json = [
    j1, j2, j3
  ];
  size_t count = json.countIndices([0, 1, 2],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 element in the provided indices matching the delegate");
  assert(json.countIndices([0, 1, 2],
      (size_t index) => index < 2) == 2, "Expected 2 elements in the provided indices matching the delegate");
}
// #endregion Json with indices and delegate

// #region Json with indices
/**
  * Counts the number of elements in a Json array at the specified indices.
  *
  * Params:
  *   json = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *
  * Returns:
  *   The count of elements at the specified indices.
  */
size_t countIndices(Json json, size_t[] indices) {
  return json.isArray ? json.toArray.countIndices(indices) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countIndices with indices");

  auto j1 = 42.toJson;
  auto j2 = "string".toJson;
  auto j3 = [1, 2].toJson;

  Json json = [
    j1, j2, j3
  ];
  assert(json.countIndices([0, 1, 2]) == 3, "Expected 3 elements in the provided indices");
  assert(json.countIndices([0, 1]) == 2, "Expected 2 elements in the provided indices");
  assert(json.countIndices([2]) == 1, "Expected 1 element in the provided indices");
}
// #endregion Json with indices

// #region Json with delegate
/**
  * Counts the number of elements in a Json array that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json array to count from.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countIndices(Json json, bool delegate(size_t) @safe countFunc) {
  return json.isArray ? json.toArray.countIndices(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countIndices with delegate");

  auto j1 = 42.toJson;
  auto j2 = "string".toJson;
  auto j3 = [1, 2].toJson;

  Json json = [
    j1, j2, j3
  ];
  size_t count = json.countIndices((size_t index) => index == 2);
  assert(count == 1, "Expected 1 element matching the delegate");
  assert(json.countIndices((size_t index) => index < 2) == 2, "Expected 2 elements matching the delegate");
}
// #endregion Json with delegate
// #endregion indices

// #region paths
// #region Json with paths and delegate
/**
  * Counts the number of elements in a Json object at the specified paths
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   paths = The paths to check within the Json object.
  *   countFunc = A delegate function that takes a path and returns true if the element at that path should be counted.
  *
  * Returns:
  *   The count of elements at the specified paths that satisfy the delegate.
  */
size_t countPaths(Json json, string[][] paths, bool delegate(string[]) @safe countFunc) {
  return json.isObject ? json.toMap.countPaths(paths, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countPaths with paths and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countPaths([
      ["first"], ["second"], ["third"], ["fourth"]
    ],
    (string[] path) => path[0].startsWith("t"));
  assert(count == 1);
}
// #endregion Json with paths and delegate

// #region Json with paths
/**
  * Counts the number of elements in a Json object at the specified paths.
  *
  * Params:
  *   json = The Json object to count from.
  *   paths = The paths to check within the Json object.
  *
  * Returns:
  *   The count of elements at the specified paths.
  */
size_t countPaths(Json json, string[][] paths) {
  return json.isObject ? json.toMap.countPaths(paths) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countPaths with paths");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countPaths([
      ["first"], ["second"], ["third"], ["fourth"]
    ]);
  assert(count == 4, "Expected 4 elements in the provided paths");
}
// #endregion Json with paths
// #endregion paths

// #region keys
// #region Json with keys and delegate
/**
  * Counts the number of elements in a Json object at the specified keys
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   keys = The keys to check within the Json object.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of elements at the specified keys that satisfy the delegate.
  */
size_t countKeys(Json json, string[] keys, bool delegate(string) @safe countFunc) {
  return json.isObject ? json.toMap.countKeys(keys, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countKeys with keys and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countKeys(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 element in the provided keys matching the delegate");
}
// #endregion Json with keys and delegate

// #region Json with keys
/**
  * Counts the number of elements in a Json object at the specified keys.
  *
  * Params:
  *   json = The Json object to count from.
  *   keys = The keys to check within the Json object.
  *
  * Returns:
  *   The count of elements at the specified keys.
  */
size_t countKeys(Json json, string[] keys) {
  return json.isObject ? json.toMap.countKeys(keys) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countKeys with keys");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countKeys(["first", "second", "third", "fourth"]);
  assert(count == 4, "Expected 4 elements in the provided keys");
}
// #endregion Json with keys

// #region Json with delegate(keys)
/**
  * Counts the number of elements in a Json object that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countKeys(Json json, bool delegate(string) @safe countFunc) {
  return json.isObject ? json.toMap.countKeys(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countKeys with delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countKeys(
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 element matching the delegate");
}
// #endregion Json with delegate(keys)
// #endregion keys

// #region values
// #region Json with values and delegate
/**
  * Counts the number of elements in a Json structure (array or object)
  * at the specified values that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json structure to count from.
  *   values = The values to check within the Json structure.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of elements at the specified values that satisfy the delegate.
  */
size_t countValues(Json json, Json[] values, bool delegate(Json) @safe countFunc) {
  if (json.isArray) {
    return json.toArray.countValues(values, countFunc);
  }
  if (json.isObject) {
    return json.toMap.countValues(values, countFunc);
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countValues with values and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countValues(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson],
    (Json value) => value.isArray);
  assert(count == 2, "Expected 2 elements in the Json with the provided values matching the delegate");
}
// #endregion Json with values and delegate

// #region Json with values
/** 
  * Counts the number of elements in a Json structure (array or object)
  * at the specified values.
  *
  * Params:
  *   json = The Json structure to count from.
  *   values = The values to check within the Json structure.
  *
  * Returns:
  *   The count of elements at the specified values.
  */
size_t countValues(Json json, Json[] values) {
  if (json.isArray) {
    return json.toArray.countValues(values);
  }
  if (json.isObject) {
    return json.toMap.countValues(values);
  }
  return 0;
}
///
unittest {
  mixin(ShowTest!"Testing countValues with values");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countValues(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson]);
  assert(count == 3, "Expected 3 elements in the provided values");
}
// #endregion Json with values

// #region Json with delegate(value)
/** 
  * Counts the number of elements in a Json structure (array or object)
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json structure to count from.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countValues(Json json, bool delegate(Json) @safe countFunc) {
  if (json.isArray) {
    return json.toArray.countValues(countFunc);
  }
  if (json.isObject) {
    return json.toMap.countValues(countFunc);
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countValues with delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countValues((Json value) => value.isArray);
  assert(count == 2, "Expected 2 elements in the Json matching the delegate");
}
// #endregion Json with delegate(value)
// #endregion values

// #region map
/** 
  * Counts the number of elements in a Json object that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   countFunc = A delegate function that takes a key and value and returns true if the element should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countMap(Json json, bool delegate(string, Json) @safe countFunc) {
  return json.isObject ? json.toMap.countMap(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countMap with delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countMap((string key, Json value) => key.startsWith("t"));
  assert(count == 1, "Expected 1 element in the Json map matching the delegate");
}
// #endregion map
// #endregion Json

// #region Json[]
// #region indices
// #region Json[] with indices and delegate
/** 
  * Counts the number of elements in a Json array at the specified indices
  * that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of elements at the specified indices that satisfy the delegate.
  */
size_t countIndices(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  auto count = 0;
  foreach (index, value; jsons) {
    if (indices.canFind(index) && countFunc(index)) {
      count++;
    }
  }
  return count;
}
/// 
unittest {
  mixin(ShowTest!"Testing countIndices for Json[] with indices and delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countIndices([0, 1, 2, 3, 4],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 element in the provided indices matching the delegate");
  assert(jsons.countIndices([0, 1, 2, 3, 4],
      (size_t index) => index < 3) == 3, "Expected 3 elements in the provided indices matching the delegate");
}
// #endregion Json[] with indices and delegate

// #region Json[] with indices
/** 
  * Counts the number of elements in a Json array at the specified indices.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *
  * Returns:
  *   The count of elements at the specified indices.
  */
size_t countIndices(Json[] jsons, size_t[] indices) {
  auto count = 0;
  foreach (index, value; jsons) {
    if (indices.canFind(index)) {
      count++;
    }
  }
  return count;
}
/// 
unittest {
  mixin(ShowTest!"Testing countIndices for Json[] with indices");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countIndices([0, 1, 2, 3, 4]);
  assert(count == 5, "Expected 5 elements in the provided indices");
}
// #endregion Json[] with indices

// #region Json[] with delegate
/**
  * Counts the number of elements in a Json array that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countIndices(Json[] jsons, bool delegate(size_t) @safe countFunc) {
  auto count = 0;
  foreach (index, value; jsons) {
    if (countFunc(index)) {
      count++;
    }
  }
  return count;
}
/// 
unittest {
  mixin(ShowTest!"Testing countIndices for Json[] with delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countIndices((size_t index) => index == 2);
  assert(count == 1, "Expected 1 element matching the delegate");
  assert(jsons.countIndices((size_t index) => index < 3) == 3, "Expected 3 elements matching the delegate");
}
// #endregion Json[] with delegate
// #endregion indices

// #region values
// #region Json[] with values and delegate
/** 
  * Counts the number of elements in a Json array at the specified values
  * that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   values = The values to check within the Json array.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of elements at the specified values that satisfy the delegate.
  */
size_t countValues(Json[] jsons, Json[] values, bool delegate(Json) @safe countFunc) {
  return jsons.filter!(json => values.hasValue(json) && countFunc(json))
    .array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with values and delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countValues(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson],
    (Json value) => value.isArray);
  assert(count == 2, "Expected 2 elements in the Json[] with the provided values matching the delegate");
}
// #endregion Json[] with values and delegate

// #region Json[] with values
/** 
  * Counts the number of elements in a Json array at the specified values.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   values = The values to check within the Json array.
  *
  * Returns:
  *   The count of elements at the specified values.
  */
size_t countValues(Json[] jsons, Json[] values) {
  return jsons.filter!(json => values.hasValue(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with values");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countValues(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson]);
  assert(count == 3, "Expected 3 elements in the provided values");
}
// #endregion Json[] with values

// #region Json[] with delegate
/** 
  * Counts the number of elements in a Json array that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countValues(Json[] jsons, bool delegate(Json) @safe countFunc) {
  return jsons.filter!(json => countFunc(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countValues((Json value) => value.isArray);
  assert(count == 2, "Expected 2 elements in the Json[] matching the delegate");
}
// #endregion Json[] with delegate
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region Json[string] with paths and delegate
/** 
  * Counts the number of elements in a Json[string] map at the specified paths
  * that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   paths = The paths to check within the Json[string] map.
  *   countFunc = A delegate function that takes a path and returns true if the element at that path should be counted.
  *
  * Returns:
  *   The count of elements at the specified paths that satisfy the delegate.
  */
size_t countPaths(Json[string] map, string[][] paths, bool delegate(string[]) @safe countFunc) {
  return paths.filter!(path => map.getValue(path) != Json(null) && countFunc(path)).array.length;
}
// #endregion Json[string] with paths and delegate

// #region Json[string] with paths
/** 
  * Counts the number of elements in a Json[string] map at the specified paths.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   paths = The paths to check within the Json[string] map.
  *
  * Returns:
  *   The count of elements at the specified paths.
  */
size_t countPaths(Json[string] map, string[][] paths) {
  return paths.filter!(path => map.getValue(path) != Json(null)).array.length;
}
// #endregion Json[string] with paths
// #endregion paths

// #region keys
// #region Json[string] with keys and delegate
/** 
  * Counts the number of elements in a Json[string] map at the specified keys
  * that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   keys = The keys to check within the Json[string] map.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of elements at the specified keys that satisfy the delegate.
  */
size_t countKeys(Json[string] map, string[] keys, bool delegate(string) @safe countFunc) {
  return keys.filter!(key => map.hasKey(key) && countFunc(key)).array.length;
}
// #endregion Json[string] with keys and delegate

// #region Json[string] with keys
/** 
  * Counts the number of elements in a Json[string] map at the specified keys.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   keys = The keys to check within the Json[string] map.
  *
  * Returns:
  *   The count of elements at the specified keys.
  */
size_t countKeys(Json[string] map, string[] keys) {
  return keys.filter!(key => map.hasKey(key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[string] with keys");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countKeys(
    ["first", "second", "third", "fourth"]);
  assert(count == 4, "Expected 4 elements in the provided keys");
}
// #endregion Json[string] with keys

// #region Json[string] with delegate (keys)
/**
  * Counts the number of elements in a Json[string] map that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countKeys(Json[string] map, bool delegate(string) @safe countFunc) {
  return map.byKeyValue.filter!(kv => countFunc(kv.key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countKeys with keys and delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countKeys((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 element matching the delegate");
}
// #endregion Json[string] with delegate keys
// #endregion keys

// #region values
// #region Json[string] with values and delegate
/** 
  * Counts the number of elements in a Json[string] map at the specified values
  * that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   values = The values to check within the Json[string] map.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of elements at the specified values that satisfy the delegate.
  */
size_t countValues(Json[string] map, Json[] values, bool delegate(Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => values.hasValue(kv.value) && countFunc(
      kv.value))
    .array.length;
}
// #endregion Json[string] with values and delegate

// #region Json[string] with values
/** 
  * Counts the number of elements in a Json[string] map at the specified values.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   values = The values to check within the Json[string] map.
  *
  * Returns:
  *   The count of elements at the specified values.
  */
size_t countValues(Json[string] map, Json[] values) {
  return map.byKeyValue.filter!(kv => values.hasValue(kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countValues for Json[string] with values");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countValues(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson]);
  assert(count == 3, "Expected 3 elements in the provided values");
}
// #endregion Json[string] with values

// #region Json[string] with delegate (value)
/** 
  * Counts the number of elements in a Json[string] map that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countValues(Json[string] map, bool delegate(Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => countFunc(kv.value)).array.length;
}
// #endregion Json[string] with delegate (value)
// #endregion values

// #region map
// #region key-value delegate
/** 
  * Counts the number of elements in a Json[string] map that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json[string] map to count from.
  *   countFunc = A delegate function that takes a key and value and returns true if the element should be counted.
  *
  * Returns:
  *   The count of elements that satisfy the delegate.
  */
size_t countMap(Json[string] map, bool delegate(string, Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => countFunc(kv.key, kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countMap for Json[string] with key-value delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countMap((string key, Json value) => key.startsWith("t") && value.isArray);
  assert(count == 1, "Expected 1 element in the provided paths matching the delegate");
}
// #endregion map
// #endregion key-value delegate
// #endregion Json[string]
