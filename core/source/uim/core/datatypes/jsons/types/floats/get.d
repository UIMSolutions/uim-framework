/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.floats.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region path
// #region getFloats(json, paths)
/**
  * Retrieves all doubles at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the doubles to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An string[] containing all doubles found at the specified paths.
**/
double[] getFloats(Json json, string[][] paths, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getFloats(paths, defaultValue) : null;
}
// #endregion getFloats(json, paths)

// #region getFloat(json, path)
/**
  * Retrieves the double at the specified path from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the double to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The double at the specified path, or the default value if not found.
**/
double getFloat(Json json, string[] path, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isFloat(path) ? json.getValue(path).getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat with path");

  Json json = parseJsonString(`{"data": { "test": [ 1, {"a": 1}, [3, 4] ]}}`);
  // assert(json.getFloat(["data", "test"])[0] == 1.1.toJson, "Expected double at path ['data', 'test'][0]");
  // assert(json.getFloat(["data", "test"]).filterArrays()[0] == 1.1.toJson, "Expected filtered double at path ['data', 'test'][0]");
}
// #endregion getFloat(json, path)
// #endregion path

// #region key
// #region getFloats(json, keys)
/**
  * Retrieves all doubles at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the doubles to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An string[] containing all doubles found at the specified keys.
**/
double[] getFloats(Json json, string[] keys, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getFloats(keys, defaultValue) : null;
}
// #endregion getFloats(json, keys)

// #region getFloat(json, key)
/**
  * Retrieves the double at the specified key from the Json object.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the double to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *   The double at the specified key, or the default value if not found.
**/
double getFloat(Json json, string key, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isFloat(key) ? json[key].getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json with key");

  Json jsonMap = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ].toJson;
  assert(jsonMap.getFloat("first") == 1.1, "Expected double at key 'first'");
}
// #endregion getFloat(Json, key)
// #endregion key

// #region index
// #region getFloats(json, indices)
/**
  * Retrieves all doubles at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   indices = The indices of the doubles to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An double[] containing all doubles found at the specified indices.
**/
double[] getFloats(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getFloats(indices) : null;
}
// #endregion getFloats(json, indices)

// #region getFloat(json, index)
/**
  * Retrieves the double at the specified index from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the double to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The double at the specified index, or the default value if not found.
**/
double getFloat(Json json, size_t index, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isFloat(index) ? json[index].getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json with index");

  Json jsonArray = [
    1.1.toJson, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getFloat(0) == 1.1, "Expected double at index 0");
}
// #endregion getFloat(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
double[] getFloats(Json[string] map, string[][] paths, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getFloat(path, defaultValue)).array;
}
/**
  * Retrieves the double at the specified path from the Json map.
  *
  * Params:
  *   map = The Json map to retrieve from.
  *   path = The path of the double to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *   The double at the specified path, or the default value if not found.
**/
double getFloat(Json[string] map, string[] path, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return map.getValue(path).isFloat ? map.getValue(path).getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json[string] with path");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getFloat("first") == 1.1, "Expected double at path 'first'");
}
// #endregion path

// #region key
// #region getFloats(Json[string] map, keys)
/**
  * Retrieves all doubles at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the doubles to retrieve.
  * Returns:
  *   An double[] containing all doubles found at the specified keys.
**/ 
double[] getFloats(Json[string] map, string[] keys, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getFloat(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json[string] with keys");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": 2.2.toJson, "fourth": [3, 4].toJson
  ];
  auto doubles = map.getFloats(["first", "third", "fourth"]);
  assert(doubles.length == 3, "Expected 3 doubles");
  assert(doubles[0] == 1.1, "Expected double at key 'first'");
  assert(doubles[1] == 2.2, "Expected double at key 'third'");
}
// #endregion getFloats(Json[string] map, keys)

// #region getFloat(Json[string] map, key)
/**
  * Retrieves the double at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the double to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The double at the specified key, or the default value if not found.
**/
double getFloat(Json[string] map, string key, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return map.getValue(key).isFloat ? map.getValue(key).getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[string] with key");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getFloat("first") == 1.1.toJson, "Expected string at key 'first'");
}
// #endregion getFloat(Json[string] map, key)
// #endregion key

// #region getFloats(Json[string] map)
/** 
  * Retrieves all arrays from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all arrays found in the Json map.
**/
double[string] getFloats(Json[string] map) {
  mixin(ShowFunction!());

  double[string] result;
  foreach (key, value; map) {
    if (value.isFloat) {
      result[key] = value.getFloat;
    }
  }
  return result;
}
// #endregion getFloats(Json[string] map)
// #endregion Json[string]

// #region Json[]
// #region getFloats(Json[], indices) 
/** 
  * Retrieves all doubles at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the doubles to retrieve.
  * Returns:
  *   An double[] of doubles found at the specified indices.
**/
double[] getFloats(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isFloat).map!(json => json.getFloat).array;
}
///
unittest {
  mixin(ShowTest!"Testing getFloats for Json[] with indices");

  Json[] jsons = [1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson];
  auto doubles = jsons.getFloats([0, 2]);
  assert(doubles.length == 2, "Expected 2 doubles");
  assert(doubles[0] == 1.1, "Expected double at index 0");
  assert(doubles[1] == 2.2, "Expected double at index 2");
}
// #endregion getFloats(Json[], indices) 

// #region getFloat(Json[], index)
/** 
  * Retrieves the double at the specified index from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *  index = The index of the double to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The double at the specified index, or the default value if not found.
**/
double getFloat(Json[] jsons, size_t index, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isFloat ? jsons[index].getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json[] with index");

  Json[] jsons = [1.1.toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getFloat(0) == 1.1, "Expected double at index 0");
}
// #endregion getFloat(Json[], index)

// #region getFloat(Json[])
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *
  * Returns:
  *  An double[] of Json arrays found in the input array.
**/
double[] getFloats(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isFloat).map!(json => json.getFloat).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json[]");

  Json[] jsons = [
    1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson
  ];
  auto doubles = jsons.getFloats;
  assert(doubles.length == 2, "Expected 2 doubles");
  assert(doubles[0] == 1.1.toJson, "Expected string at index 0");
  assert(doubles[1] == 2.2.toJson, "Expected double at index 1");
}
// #endregion getFloat(Json[])
// #endregion Json[]

// #region Json
// #region getFloats(Json)
/** 
  * Retrieves all arrays from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all arrays found in the Json object.
**/
double[] getFloats(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getFloats : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json");

  Json jsonArray = [
    1.1.toJson, ["a": 1].toJson, [3, 4].toJson, 42.2.toJson
  ].toJson;
  auto arraysFromArray = jsonArray.getFloats;
  // TODO
}
// #endregion getFloats(Json)

// #region getFloat(Json)
/** 
  * Retrieves the double from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  * Returns:
  *   The double contained in the Json object, or null if not a double.
**/
double getFloat(Json json) {
  mixin(ShowFunction!());

  return json.isFloat ? json.get!double : 0.0;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json");

  Json json = 1.1.toJson;
  assert(json.getFloat == 1.1, "Expected double from Json");
}
// #endregion getFloat(Json)