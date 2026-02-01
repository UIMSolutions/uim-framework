/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region path
// #region getDoubles(json, paths)
/**
  * Retrieves all doubles at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the doubles to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An string[] containing all doubles found at the specified paths.
**/
double[] getDoubles(Json json, string[][] paths, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getDoubles(paths, defaultValue) : null;
}
// #endregion getDoubles(json, paths)

// #region getDouble(json, path)
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
double getDouble(Json json, string[] path, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isDouble(path) ? json.getValue(path).getDouble : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble with path");

  Json json = parseJsonString(`{"data": { "test": [ 1, {"a": 1}, [3, 4] ]}}`);
  // assert(json.getDouble(["data", "test"])[0] == 1.1.toJson, "Expected double at path ['data', 'test'][0]");
  // assert(json.getDouble(["data", "test"]).filterArrays()[0] == 1.1.toJson, "Expected filtered double at path ['data', 'test'][0]");
}
// #endregion getDouble(json, path)
// #endregion path

// #region key
// #region getDoubles(json, keys)
/**
  * Retrieves all doubles at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the doubles to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An string[] containing all doubles found at the specified keys.
**/
double[] getDoubles(Json json, string[] keys, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getDoubles(keys, defaultValue) : null;
}
// #endregion getDoubles(json, keys)

// #region getDouble(json, key)
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
double getDouble(Json json, string key, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isDouble(key) ? json[key].getDouble : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json with key");

  Json jsonMap = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ].toJson;
  assert(jsonMap.getDouble("first") == 1.1, "Expected double at key 'first'");
}
// #endregion getDouble(Json, key)
// #endregion key

// #region index
// #region getDoubles(json, indices)
/**
  * Retrieves all doubles at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   indices = The indices of the doubles to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An double[] containing all doubles found at the specified indices.
**/
double[] getDoubles(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getDoubles(indices) : null;
}
// #endregion getDoubles(json, indices)

// #region getDouble(json, index)
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
double getDouble(Json json, size_t index, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isDouble(index) ? json[index].getDouble : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json with index");

  Json jsonArray = [
    1.1.toJson, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getDouble(0) == 1.1, "Expected double at index 0");
}
// #endregion getDouble(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
double[] getDoubles(Json[string] map, string[][] paths, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getDouble(path, defaultValue)).array;
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
double getDouble(Json[string] map, string[] path, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return map.getValue(path).isDouble ? map.getValue(path).getDouble : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json[string] with path");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getDouble("first") == 1.1, "Expected double at path 'first'");
}
// #endregion path

// #region key
// #region getDoubles(Json[string] map, keys)
/**
  * Retrieves all doubles at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the doubles to retrieve.
  * Returns:
  *   An double[] containing all doubles found at the specified keys.
**/ 
double[] getDoubles(Json[string] map, string[] keys, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getDouble(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDoubles for Json[string] with keys");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": 2.2.toJson, "fourth": [3, 4].toJson
  ];
  auto doubles = map.getDoubles(["first", "third", "fourth"]);
  assert(doubles.length == 3, "Expected 3 doubles");
  assert(doubles[0] == 1.1, "Expected double at key 'first'");
  assert(doubles[1] == 2.2, "Expected double at key 'third'");
}
// #endregion getDoubles(Json[string] map, keys)

// #region getDouble(Json[string] map, key)
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
double getDouble(Json[string] map, string key, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return map.getValue(key).isDouble ? map.getValue(key).getDouble : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[string] with key");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getDouble("first") == 1.1.toJson, "Expected string at key 'first'");
}
// #endregion getDouble(Json[string] map, key)
// #endregion key

// #region getDoubles(Json[string] map)
/** 
  * Retrieves all arrays from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all arrays found in the Json map.
**/
double[string] getDoubles(Json[string] map) {
  mixin(ShowFunction!());

  double[string] result;
  foreach (key, value; map) {
    if (value.isDouble) {
      result[key] = value.getDouble;
    }
  }
  return result;
}
// #endregion getDoubles(Json[string] map)
// #endregion Json[string]

// #region Json[]
// #region getDoubles(Json[], indices) 
/** 
  * Retrieves all doubles at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the doubles to retrieve.
  * Returns:
  *   An double[] of doubles found at the specified indices.
**/
double[] getDoubles(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isDouble).map!(json => json.getDouble).array;
}
///
unittest {
  mixin(ShowTest!"Testing getDoubles for Json[] with indices");

  Json[] jsons = [1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson];
  auto doubles = jsons.getDoubles([0, 2]);
  assert(doubles.length == 2, "Expected 2 doubles");
  assert(doubles[0] == 1.1, "Expected double at index 0");
  assert(doubles[1] == 2.2, "Expected double at index 2");
}
// #endregion getDoubles(Json[], indices) 

// #region getDouble(Json[], index)
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
double getDouble(Json[] jsons, size_t index, double defaultValue = 0.0) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isDouble ? jsons[index].getDouble : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json[] with index");

  Json[] jsons = [1.1.toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getDouble(0) == 1.1, "Expected double at index 0");
}
// #endregion getDouble(Json[], index)

// #region getDouble(Json[])
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *
  * Returns:
  *  An double[] of Json arrays found in the input array.
**/
double[] getDoubles(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isDouble).map!(json => json.getDouble).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDoubles for Json[]");

  Json[] jsons = [
    1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson
  ];
  auto doubles = jsons.getDoubles;
  assert(doubles.length == 2, "Expected 2 doubles");
  assert(doubles[0] == 1.1.toJson, "Expected string at index 0");
  assert(doubles[1] == 2.2.toJson, "Expected double at index 1");
}
// #endregion getDouble(Json[])
// #endregion Json[]

// #region Json
// #region getDoubles(Json)
/** 
  * Retrieves all arrays from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all arrays found in the Json object.
**/
double[] getDoubles(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getDoubles : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDoubles for Json");

  Json jsonArray = [
    1.1.toJson, ["a": 1].toJson, [3, 4].toJson, 42.2.toJson
  ].toJson;
  auto arraysFromArray = jsonArray.getDoubles;
  // TODO
}
// #endregion getDoubles(Json)

// #region getDouble(Json)
/** 
  * Retrieves the double from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  * Returns:
  *   The double contained in the Json object, or null if not a double.
**/
double getDouble(Json json) {
  mixin(ShowFunction!());

  return json.isDouble ? json.get!double : 0.0;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json");

  Json json = 1.1.toJson;
  assert(json.getDouble == 1.1, "Expected double from Json");
}
// #endregion getDouble(Json)