/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.arrays.count;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region Json with indices and delegate
/**
  * Counts the number of array elements in a Json array at the specified indices
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of array elements at the specified indices that satisfy the delegate.
  */
size_t countArrays(Json json, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  mixin(ShowFunction!());

  return json.countIndices(indices, (size_t index) => json[index].isArray && countFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with indices and delegate");

  auto j1 = [1, 2].toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = [3, 4, 5].toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];
  size_t count = json.countArrays([0, 1, 2, 3, 4], (size_t index) => json[index].length == 2);
  assert(count == 1, "Expected 1 array in the provided indices matching the delegate");
}
// #endregion Json with indices and delegate

// #region Json with indices
/**
  * Counts the number of array elements in a Json array at the specified indices.
  *
  * Params:
  *   json = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *
  * Returns:
  *   The count of array elements at the specified indices.
  */
size_t countArrays(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.countIndices(indices, (size_t index) => json[index].isArray);
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with indices");

  auto j1 = [1, 2].toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = [3, 4].toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];
  size_t count = json.countArrays([0, 1, 2, 3, 4]);
  assert(count == 2, "Expected 2 arrays in the provided indices");
}
// #endregion Json with indices

// #region Json with delegate
/**
  * Counts the number of array elements in a Json array that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json array to count from.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json json, bool delegate(size_t) @safe countFunc) {
  mixin(ShowFunction!());

  return json.countIndices((size_t index) => json[index].isArray && countFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with indices and delegate");

  auto j1 = [1, 2].toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = [3, 4, 5].toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];
  size_t count = json.countArrays((size_t index) => json[index].length == 2);
  assert(count == 1, "Expected 1 array matching the delegate");
}
// #endregion Json with delegate
// #endregion indices

// #region paths
// #region Json with paths and delegate
/**
  * Counts the number of array elements in a Json object at the specified paths
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   paths = The paths to check within the Json object.
  *   countFunc = A delegate function that takes a path and returns true if the element at that path should be counted.
  *
  * Returns:
  *   The count of array elements at the specified paths that satisfy the delegate.
  */
size_t countArrays(Json json, string[][] paths, bool delegate(string[]) @safe countFunc) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.countArrays(paths, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with paths and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays([
      ["first"], ["second"], ["third"], ["fourth"]
    ], (string[] path) => path.length == 1 && path[0] == "first");
  assert(count == 1, "Expected 1 array in the provided paths matching the delegate");

  assert(json.countArrays([
        ["first"], ["second"], ["third"], ["fourth"]
      ], (string[] path) => path.length == 1) == 2, "Expected 2 arrays in the provided paths matching the delegate");
  assert(json.countArrays([
        ["first"], ["second"], ["third"], ["fourth"]
      ], (string[] path) => path.length >= 1) == 2, "Expected 2 arrays in the provided paths matching the delegate");
}
// #endregion Json with paths and delegate

// #region Json with paths
/**
  * Counts the number of array elements in a Json object at the specified paths.
  *
  * Params:
  *   json = The Json object to count from.
  *   paths = The paths to check within the Json object.
  *
  * Returns:
  *   The count of array elements at the specified paths.
  */
size_t countArrays(Json json, string[][] paths) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.countArrays(paths) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with paths");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays([
      ["first"], ["second"], ["third"], ["fourth"]
    ]);
  assert(count == 2, "Expected 2 arrays in the provided paths");
}
// #endregion Json with paths
// #endregion paths

// #region keys
// #region Json with keys and delegate
/**
  * Counts the number of array elements in a Json object at the specified keys
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   keys = The keys to check within the Json object.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of array elements at the specified keys that satisfy the delegate.
  */
size_t countArrays(Json json, string[] keys, bool delegate(string) @safe countFunc) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.countArrays(keys, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with keys and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1);
}
// #endregion Json with keys and delegate

// #region Json with keys
/**
  * Counts the number of array elements in a Json object at the specified keys.
  *
  * Params:
  *   json = The Json object to count from.
  *   keys = The keys to check within the Json object.
  *
  * Returns:
  *   The count of array elements at the specified keys.
  */
size_t countArrays(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.countArrays(keys) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with keys");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays(["first", "second", "third", "fourth"]);
  assert(count == 2, "Expected 2 arrays in the provided keys");
}
// #endregion Json with keys

// #region Json with delegate(keys)
/**
  * Counts the number of array elements in a Json object that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json json, bool delegate(string) @safe countFunc) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.countArrays(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with keys and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 array matching the delegate");
}
// #endregion Json with delegate(keys)
// #endregion keys

// #region values
/**
  * Counts the number of array elements in a Json structure (array or object)
  * at the specified values that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json structure to count from.
  *   values = The values to check within the Json structure.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of array elements at the specified values that satisfy the delegate.
  */
size_t countArrays(Json json, Json[] values, bool delegate(Json) @safe countFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.countArrays(values, countFunc);
  }
  if (json.isObject) {
    return json.toMap.countArrays(values, countFunc);
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with values and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;

  size_t count = json.countArrays(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson],
    (Json value) => value.isArray);
  assert(count == 2, "Expected 2 arrays in the provided values matching the delegate");
}

// #region Json with delegate(value)
/** 
  * Counts the number of array elements in a Json structure (array or object)
  * at the specified values.
  *
  * Params:
  *   json = The Json structure to count from.
  *   values = The values to check within the Json structure.
  *
  * Returns:
  *   The count of array elements at the specified values.
  */
size_t countArrays(Json json, bool delegate(Json) @safe countFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.countArrays(countFunc);
  }
  if (json.isObject) {
    return json.toMap.countArrays(countFunc);
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with values and delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays((Json value) => value.isArray);
  assert(count == 2, "");
}
// #endregion Json with delegate(value)
// #endregion values

// #region map
/** 
  * Counts the number of array elements in a Json object at the specified key-value pairs
  * that satisfy the provided delegate function.
  *
  * Params:
  *   json = The Json object to count from.
  *   countFunc = A delegate function that takes a key and value and returns true if the element should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json json, bool delegate(string, Json) @safe countFunc) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.countArrays(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json with delegate");

  Json json = [
    "first": [1, 2].toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countArrays((string key, Json value) => key.startsWith("t"));
  assert(count == 1, "Expected 1 array in the Json map matching the delegate");
}
// #endregion map
// #endregion Json

// #region Json[]
// #region indices
// #region Json[] with indices and delegate
/** 
  * Counts the number of array elements in a Json array at the specified indices
  * that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of array elements at the specified indices that satisfy the delegate.
  */
size_t countArrays(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  mixin(ShowFunction!());

  return jsons.countIndices(indices, (size_t index) => jsons[index].isArray && countFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with indices and delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4, 5].toJson, "string".toJson, 42.toJson
  ];

  size_t count = countArrays(jsons, [0, 1, 2, 3, 4],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 array in the provided indices matching the delegate");
  assert(countArrays(jsons, [0, 1, 2, 3, 4],
      (size_t index) => index < 3) == 2, "Expected 2 arrays in the provided indices matching the delegate");
  assert(countArrays(jsons, [0, 1, 2, 3, 4],
      (size_t index) => index >= 0) == 2, "Expected 2 arrays in the provided indices matching the delegate");
}
// #endregion Json[] with indices and delegate

// #region Json[] with indices
/** 
  * Counts the number of array elements in a Json array at the specified indices.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   indices = The indices to check within the Json array.
  *
  * Returns:
  *   The count of array elements at the specified indices.
  */
size_t countArrays(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.countIndices(indices, (size_t index) => jsons[index].isArray);
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with indices");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  assert(countArrays(jsons, [0, 1, 2, 3, 4]) == 2, "Expected 2 arrays in the provided indices");
  assert(countArrays(jsons, [0, 1]) == 1, "Expected 1 array in the provided indices");
  assert(countArrays(jsons, [3, 4]) == 0, "Expected 0 arrays in the provided indices");
}
// #endregion Json[] with indices

// #region Json[] with delegate
/** 
  * Counts the number of array elements in a Json array that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   countFunc = A delegate function that takes an index and returns true if the element at that index should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json[] jsons, bool delegate(size_t) @safe countFunc) {
  return jsons.countIndices(index => jsons[index].isArray && countFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countArrays((size_t index) => index == 2);
  assert(count == 1, "Expected 1 array matching the delegate");
  assert(jsons.countArrays((size_t index) => index < 3) == 2, "Expected 2 arrays matching the delegate");
  assert(jsons.countArrays((size_t index) => index >= 0) == 2, "Expected 2 arrays matching the delegate");
}
// #endregion Json[] with delegate
// #endregion indices

// #region values
// #region Json[] with values and delegate
/** 
  * Counts the number of array elements in a Json array at the specified values
  * that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   values = The values to check within the Json array.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of array elements at the specified values that satisfy the delegate.
  */
size_t countArrays(Json[] jsons, Json[] values, bool delegate(Json) @safe countFunc) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isArray && values.hasValue(json) && countFunc(json))
    .array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with values and delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countArrays(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson],
    (Json value) => value.isArray);
  assert(count == 2, "Expected 2 arrays in the Json[] with the provided values matching the delegate");
}
// #endregion Json[] with values and delegate

// #region Json[] with values
/** 
  * Counts the number of array elements in a Json array at the specified values.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   values = The values to check within the Json array.
  *
  * Returns:
  *   The count of array elements at the specified values.
  */
size_t countArrays(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.countValues(values, (Json json) => json.isArray);
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with values");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countArrays(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson]);
  assert(count == 2, "Expected 2 arrays in the Json[] with the provided values");
}
// #endregion Json[] with values

// #region Json[] with delegate
/** 
  * Counts the number of array elements in a Json array that satisfy the provided delegate function.
  *
  * Params:
  *   jsons = The Json array to count from.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json[] jsons, bool delegate(Json) @safe countFunc) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isArray && countFunc(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] with delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countArrays((Json value) => value.isArray);
  assert(count == 2, "Expected 2 arrays in the Json[] matching the delegate");
}
// #endregion Json[] with delegate
// #endregion values

// #region Json[] without delegate
/** 
  * Counts the number of array elements in a Json array.
  *
  * Params:
  *   jsons = The Json array to count from.
  *
  * Returns:
  *   The count of array elements.
  */
size_t countArrays(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isArray).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[] without delegate");

  Json[] jsons = [
    [1, 2].toJson, ["a": 1].toJson, [3, 4].toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countArrays();
  assert(count == 2, "Expected 2 arrays in the Json[]");
}
// #endregion Json[] without delegate
// #endregion Json[]

// #region Json[string]
// #region paths
// #region Json[string] with paths and delegate
/** 
  * Counts the number of array elements in a Json object at the specified paths
  * that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json object to count from.
  *   paths = The paths to check within the Json object.
  *   countFunc = A delegate function that takes a path and returns true if the element at that path should be counted.
  *
  * Returns:
  *   The count of array elements at the specified paths that satisfy the delegate.
  */
size_t countArrays(Json[string] map, string[][] paths, bool delegate(string[]) @safe countFunc) {
  mixin(ShowFunction!());

  return paths.filter!(path => map.getValue(path).isArray && countFunc(path)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[string] with paths and delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson, "sixth": ["a": ["b": [3, 4].toJson].toJson].toJson
  ];
  size_t count = map.countArrays([["first"], ["second"], ["third"], ["fourth"]],
    (string[] path) => path.length == 1 && path[0] == "first");
  assert(count == 1, "Expected 1 array in the provided paths matching the delegate");
  assert(map.countArrays([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length == 1) == 2, "Expected 2 arrays in the provided paths matching the delegate");
  assert(map.countArrays([["first"], ["second"], ["third"], ["sixth", "a", "b"]],
      (string[] path) => path.length >= 1) == 3, "Expected 3 arrays in the provided paths matching the delegate");
}
// #endregion Json[string] with paths and delegate

// #region Json[string] with paths
/** 
  * Counts the number of array elements in a Json object at the specified paths.
  *
  * Params:
  *   map = The Json object to count from.
  *   paths = The paths to check within the Json object.
  *
  * Returns:
  *   The count of array elements at the specified paths.
  */
size_t countArrays(Json[string] map, string[][] paths) {
  mixin(ShowFunction!());

  return paths.filter!(path => map.getValue(path).isArray).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[string] with paths");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays([["first"], ["second"], ["third"], ["fourth"]]);
  assert(count == 2, "Expected 2 arrays in the provided paths");
}
// #endregion Json[string] with paths
// #endregion paths

// #region keys
// #region Json[string] with keys and delegate
/** 
  * Counts the number of array elements in a Json object at the specified keys
  * that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json object to count from.
  *   keys = The keys to check within the Json object.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of array elements at the specified keys that satisfy the delegate.
  */
size_t countArrays(Json[string] map, string[] keys, bool delegate(string) @safe countFunc) {
  mixin(ShowFunction!());

  return keys.filter!(key => map.getValue([key]).isArray && countFunc(key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with keys and delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 array in the provided keys matching the delegate");
}
// #endregion Json[string] with keys and delegate

// #region Json[string] with keys
/** 
  * Counts the number of array elements in a Json object at the specified keys.
  *
  * Params:
  *   map = The Json object to count from.
  *   keys = The keys to check within the Json object.
  *
  * Returns:
  *   The count of array elements at the specified keys.
  */
size_t countArrays(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return keys.filter!(key => map[key].isArray).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with keys");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays(["first", "second", "third", "fourth"]);
  assert(count == 2, "Expected 2 arrays in the provided keys");
}
// #endregion Json[string] with keys

// #region Json[string] with delegate (keys)
/** 
  * Counts the number of array elements in a Json object that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json object to count from.
  *   countFunc = A delegate function that takes a key and returns true if the element at that key should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json[string] map, bool delegate(string) @safe countFunc) {
  mixin(ShowFunction!());

  return map.byKeyValue.filter!(kv => kv.value.isArray && countFunc(kv.key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with keys and delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 array matching the delegate");
}
// #endregion Json[string] with delegate keys
// #endregion keys

// #region values
// #region Json[string] with values and delegate
/** 
  * Counts the number of array elements in a Json object at the specified values
  * that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json object to count from.
  *   values = The values to check within the Json object.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of array elements at the specified values that satisfy the delegate.
  */
size_t countArrays(Json[string] map, Json[] values, bool delegate(Json) @safe countFunc) {
  mixin(ShowFunction!());

  return map.countArrays((string key, Json value) => values.canFind(value) && countFunc(value));
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with values and delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson],
    (Json value) => value.isArray);
  assert(count == 2, "Expected 2 arrays in the provided values matching the delegate");
}
// #endregion Json[string] with values and delegate

// #region Json[string] with values
/** 
  * Counts the number of array elements in a Json object at the specified values.
  *
  * Params:
  *   map = The Json object to count from.
  *   values = The values to check within the Json object.
  *
  * Returns:
  *   The count of array elements at the specified values.
  */
size_t countArrays(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.countArrays((string key, Json value) => values.canFind(value));
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with values");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays(
    [[1, 2].toJson, [3, 4].toJson, "string".toJson]);
  assert(count == 2, "Expected 2 arrays in the provided values");
}
// #endregion Json[string] with values

// #region Json[string] with delegate (value)
/** 
  * Counts the number of array elements in a Json object that satisfy the provided delegate function.
  *
  * Params:
  *   map = The Json object to count from.
  *   countFunc = A delegate function that takes a Json value and returns true if it should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json[string] map, bool delegate(Json) @safe countFunc) {
  mixin(ShowFunction!());

  return map.byKeyValue.filter!(kv => kv.value.isArray && countFunc(kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays with values and delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays((Json value) => value.isArray);
  assert(count == 2, "Expected 2 arrays in the provided values matching the delegate");
}
// #endregion Json[string] with delegate (value)
// #endregion values

// #region map
// #region key-value delegate
/** 
  * Counts the number of array elements in a Json object that satisfy the provided key-value delegate function.
  *
  * Params:
  *   map = The Json object to count from.
  *   countFunc = A delegate function that takes a key and value and returns true if the element should be counted.
  *
  * Returns:
  *   The count of array elements that satisfy the delegate.
  */
size_t countArrays(Json[string] map, bool delegate(string, Json) @safe countFunc) {
  mixin(ShowFunction!());

  return map.byKeyValue.filter!(kv => kv.value.isArray && countFunc(kv.key, kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countArrays for Json[string] with key-value delegate");

  Json[string] map = [
    "first": [1, 2].toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countArrays((string key, Json value) => key.startsWith("t") && value.isArray);
  assert(count == 1, "Expected 1 array in the provided paths matching the delegate");
}
// #endregion map
// #endregion key-value delegate
// #endregion Json[string]
