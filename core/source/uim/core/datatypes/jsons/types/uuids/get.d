/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.integers.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region path
// #region getIntegers(json, paths)
/**
  * Retrieves all integers at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the integers to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An int[] containing all integers found at the specified paths.
**/
int[] getIntegers(Json json, string[][] paths, int defaultValue = 0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getIntegers(paths, defaultValue) : null;
}
// #endregion getIntegers(json, paths)

// #region getInteger(json, path)
/**
  * Retrieves the integer at the specified path from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the integer to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The integer at the specified path, or the default value if not found.
**/
int getInteger(Json json, string[] path, int defaultValue = 0) {
  mixin(ShowFunction!());

  return json.isInteger(path) ? json.getValue(path).getInteger : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger with path");

  Json json = parseJsonString(`{"data": { "test": [ 1, {"a": 1}, [3, 4] ]}}`);
  // assert(json.getInteger(["data", "test"])[0] == 1.toJson, "Expected integer at path ['data', 'test'][0]");
  // assert(json.getInteger(["data", "test"]).filterArrays()[0] == 1.toJson, "Expected filtered integer at path ['data', 'test'][0]");
}
// #endregion getInteger(json, path)
// #endregion path

// #region key
// #region getIntegers(json, keys)
/**
  * Retrieves all integers at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the integers to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An int[] containing all integers found at the specified keys.
**/
int[] getIntegers(Json json, string[] keys, int defaultValue = 0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getIntegers(keys, defaultValue) : null;
}
// #endregion getIntegers(json, keys)

// #region getInteger(json, key)
/**
  * Retrieves the integer at the specified key from the Json object.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the integer to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *   The integer at the specified key, or the default value if not found.
**/
int getInteger(Json json, string key, int defaultValue = 0) {
  mixin(ShowFunction!());

  return json.isInteger(key) ? json[key].getInteger : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json with key");

  Json jsonMap = [
    "first": 1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ].toJson;
  assert(jsonMap.getInteger("first") == 1, "Expected integer at key 'first'");
}
// #endregion getInteger(Json, key)
// #endregion key

// #region index
// #region getIntegers(json, indices)
/**
  * Retrieves all integers at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   indices = The indices of the integers to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An int[] containing all integers found at the specified keys.
**/
int[] getIntegers(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getIntegers(indices) : null;
}
// #endregion getIntegers(json, indices)

// #region getInteger(json, index)
/**
  * Retrieves the integer at the specified index from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the integer to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The integer at the specified index, or the default value if not found.
**/
int getInteger(Json json, size_t index, int defaultValue = 0) {
  mixin(ShowFunction!());

  return json.isInteger(index) ? json[index].getInteger : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json with index");

  Json jsonArray = [
    1.toJson, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getInteger(0) == 1, "Expected integer at index 0");
}
// #endregion getInteger(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
int[] getIntegers(Json[string] map, string[][] paths, int defaultValue = 0) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getInteger(path, defaultValue)).array;
}
/**
  * Retrieves the integer at the specified path from the Json map.
  *
  * Params:
  *   map = The Json map to retrieve from.
  *   path = The path of the integer to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *   The integer at the specified path, or the default value if not found.
**/
int getInteger(Json[string] map, string[] path, int defaultValue = 0) {
  mixin(ShowFunction!());

  return map.getValue(path).isInteger ? map.getValue(path).getInteger : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json[string] with path");

  Json[string] map = [
    "first": 1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getInteger("first") == 1.toJson, "Expected integer at path 'first'");
}
// #endregion path

// #region key
// #region getIntegers(Json[string] map, keys)
/**
  * Retrieves all integers at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the integers to retrieve.
  * Returns:
  *   An int[] containing all integers found at the specified keys.
**/ 
int[] getIntegers(Json[string] map, string[] keys, int defaultValue = 0) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getInteger(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getIntegers for Json[string] with keys");

  Json[string] map = [
    "first": 1.toJson, "second": ["a": 1].toJson, "third": 2.toJson, "fourth": [3, 4].toJson
  ];
  auto integers = map.getIntegers(["first", "third", "fourth"]);
  assert(integers.length == 3, "Expected 3 integers");
  assert(integers[0] == 1, "Expected integer at key 'first'");
  assert(integers[1] == 2, "Expected integer at key 'third'");
}
// #endregion getIntegers(Json[string] map, keys)

// #region getInteger(Json[string] map, key)
/**
  * Retrieves the integer at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the integer to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The integer at the specified key, or the default value if not found.
**/
int getInteger(Json[string] map, string key, int defaultValue = 0) {
  mixin(ShowFunction!());

  return map.getValue(key).isInteger ? map.getValue(key).getInteger : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json[string] with key");

  Json[string] map = [
    "first": 1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getInteger("first") == 1.toJson, "Expected integer at key 'first'");
}
// #endregion getInteger(Json[string] map, key)
// #endregion key

// #region getIntegers(Json[string] map)
/** 
  * Retrieves all arrays from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all arrays found in the Json map.
**/
int[string] getIntegers(Json[string] map) {
  mixin(ShowFunction!());

  int[string] result;
  foreach (key, value; map) {
    if (value.isInteger) {
      result[key] = value.getInteger;
    }
  }
  return result;
}
// #endregion getIntegers(Json[string] map)
// #endregion Json[string]

// #region Json[]
// #region getIntegers(Json[], indices) 
/** 
  * Retrieves all integers at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the integers to retrieve.
  * Returns:
  *   An array of integers found at the specified indices.
**/
int[] getIntegers(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isInteger).map!(json => json.getInteger).array;
}
///
unittest {
  mixin(ShowTest!"Testing getIntegers for Json[] with indices");

  Json[] jsons = [1.toJson, ["a": 1].toJson, 2.toJson, [3, 4].toJson];
  auto integers = jsons.getIntegers([0, 2]);
  assert(integers.length == 2, "Expected 2 integers");
  assert(integers[0] == 1, "Expected integer at index 0");
  assert(integers[1] == 2, "Expected integer at index 2");
}
// #endregion getIntegers(Json[], indices) 

// #region getInteger(Json[], index)
/** 
  * Retrieves the integer at the specified index from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *  index = The index of the integer to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The integer at the specified index, or the default value if not found.
**/
int getInteger(Json[] jsons, size_t index, int defaultValue = 0) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isInteger ? jsons[index].getInteger : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json[] with index");

  Json[] jsons = [1.toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getInteger(0) == 1, "Expected integer at index 0");
}
// #endregion getInteger(Json[], index)

// #region getInteger(Json[])
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *
  * Returns:
  *  An array of integers found in the input array.
**/
int[] getIntegers(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isInteger).map!(json => json.getInteger).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getIntegers for Json[]");

  Json[] jsons = [
    1.toJson, ["a": 1].toJson, 2.toJson, [3, 4].toJson
  ];
  auto integers = jsons.getIntegers;
  assert(integers.length == 2, "Expected 2 integers");
  assert(integers[0] == 1.toJson, "Expected integer at index 0");
  assert(integers[1] == 2.toJson, "Expected integer at index 1");
}
// #endregion getInteger(Json[])
// #endregion Json[]

// #region Json
// #region getIntegers(Json)
/** 
  * Retrieves all arrays from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all arrays found in the Json object.
**/
int[] getIntegers(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getIntegers : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getIntegers for Json");

  Json jsonArray = [
    1.toJson, ["a": 1].toJson, [3, 4].toJson, 42.toJson
  ].toJson;
  auto arraysFromArray = jsonArray.getIntegers;
  // TODO
}
// #endregion getIntegers(Json)

// #region getInteger(Json)
/** 
  * Retrieves the integer from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  * Returns:
  *   The integer contained in the Json object, or null if not an integer.
**/
int getInteger(Json json) {
  mixin(ShowFunction!());

  return json.isInteger ? json.get!int : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json");

  Json json = 1.toJson;
  assert(json.getInteger == 1, "Expected integer from Json");
}
// #endregion getInteger(Json)