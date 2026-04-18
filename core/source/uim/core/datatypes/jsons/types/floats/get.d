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
// #region getFloat(Json)
/** 
  * Retrieves the float from the Json object.
    * Params:
    *   json = The Json object to retrieve from.
    * Returns:
    *   The float contained in the Json object, or null if not a float.
  **/
float getFloat(Json json) {
  mixin(ShowFunction!());

  return json.isFloat ? json.get!float : 0.0;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json");

  Json json = 1.1.toJson;
  assert(json.getFloat == 1.1f, "Expected float from Json");
}
// #endregion getFloat(Json)

// #region getFloat(Json[])
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *
  * Returns:
  *  A float[] of floats found in the input array.
**/
float[] getFloats(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isFloat)
    .map!(json => json.getFloat)
    .array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json[]");

  Json[] jsons = [
    1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson
  ];
  auto floats = jsons.getFloats;
  assert(floats.length == 2, "Expected 2 floats");
  assert(floats[0] == 1.1f, "Expected float at index 0");
  assert(floats[1] == 2.2f, "Expected float at index 1");
}
// #endregion getFloat(Json[])

// #region getFloats(Json)
/** 
  * Retrieves all floats from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A float[] containing all floats found in the Json object.
**/
float[] getFloats(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getFloats : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json");

  Json json = [1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson].toJson;
  auto floats = json.getFloats;
  assert(floats.length == 2, "Expected 2 floats");
  assert(floats[0] == 1.1f, "Expected float at index 0");
  assert(floats[1] == 2.2f, "Expected float at index 1");
}
// #endregion getFloats(Jsonf)
// #endregion Json

// #region Json
// #region path
// #region getFloats(json, paths)
/**
  * Retrieves all floats at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the floats to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An float[] containing all floats found at the specified paths.
**/
float[] getFloats(Json json, string[][] paths, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getFloats(paths, defaultValue) : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json with paths");

  Json json = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": 2.2.toJson,
    "fourth": [3, 4].toJson
  ].toJson;
  auto floats = json.getFloats([["first"], ["third"], ["fourth"]]);
  assert(floats.length == 3, "Expected 3 floats");
  assert(floats[0] == 1.1f, "Expected float at path ['first']");
  assert(floats[1] == 2.2f, "Expected float at path ['third']");
}

// #endregion getFloats(json, paths)

// #region getFloat(json, path)
/**
  * Retrieves the float at the specified path from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the float to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The float at the specified path, or the default value if not found.
**/
float getFloat(Json json, string[] path, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isFloat(path) ? json.getValue(path).getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat with path");

  Json json = parseJsonString(`{"data": { "test": 1.1 } }`);
  assert(json.getFloat(["data", "test"]) == 1.1f, "Expected float at path ['data', 'test'][0]");
}
// #endregion getFloat(json, path)
// #endregion path

// #region key
// #region getFloats(json, keys)
/**
  * Retrieves all floats at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the floats to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An float[] containing all floats found at the specified keys.
**/
float[] getFloats(Json json, string[] keys, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getFloats(keys, defaultValue) : null;
}
// #endregion getFloats(json, keys)

// #region getFloat(json, key)
/**
  * Retrieves the float at the specified key from the Json object.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the float to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *   The float at the specified key, or the default value if not found.
**/
float getFloat(Json json, string key, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isFloat(key) ? json[key].getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json with key");

  Json jsonMap = [
    "first": 1.1.toJson,
    "second": ["a": 1].toJson,
    "third": [3, 4].toJson
  ].toJson;
  assert(jsonMap.getFloat("first") == 1.1f, "Expected float at key 'first'");
}
// #endregion getFloat(Json, key)
// #endregion key

// #region index
// #region getFloats(json, indices)
/**
  * Retrieves all floats at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   indices = The indices of the floats to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An float[] containing all floats found at the specified indices.
**/
float[] getFloats(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getFloats(indices) : null;
}
// #endregion getFloats(json, indices)

// #region getFloat(json, index)
/**
  * Retrieves the float at the specified index from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the float to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The float at the specified index, or the default value if not found.
**/
float getFloat(Json json, size_t index, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return json.isFloat(index) ? json[index].getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json with index");

  Json jsonArray = [
    1.1.toJson, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getFloat(0) == 1.1f, "Expected float at index 0");
}
// #endregion getFloat(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
float[] getFloats(Json[string] map, string[][] paths, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getFloat(path, defaultValue)).array;
}
/**
  * Retrieves the float at the specified path from the Json map.
  *
  * Params:
  *   map = The Json map to retrieve from.
  *   path = The path of the float to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *   The float at the specified path, or the default value if not found.
**/
float getFloat(Json[string] map, string[] path, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return map.getValue(path).isFloat ? map.getValue(path).getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json[string] with path");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getFloat("first") == 1.1f, "Expected float at path 'first'");
}
// #endregion path

// #region key
// #region getFloats(Json[string] map, keys)
/**
  * Retrieves all floats at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the floats to retrieve.
  * Returns:
  *   An float[] containing all floats found at the specified keys.
**/
float[] getFloats(Json[string] map, string[] keys, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getFloat(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloats for Json[string] with keys");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": 2.2.toJson,
    "fourth": [3, 4].toJson
  ];
  auto floats = map.getFloats(["first", "third", "fourth"]);
  assert(floats.length == 3, "Expected 3 floats");
  assert(floats[0] == 1.1f, "Expected float at key 'first'");
  assert(floats[1] == 2.2f, "Expected float at key 'third'");
}
// #endregion getFloats(Json[string] map, keys)

// #region getFloat(Json[string] map, key)
/**
  * Retrieves the float at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the float to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The float at the specified key, or the default value if not found.
**/
float getFloat(Json[string] map, string key, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return map.getValue(key).isFloat ? map.getValue(key).getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json[string] with key");

  Json[string] map = [
    "first": 1.1.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getFloat("first") == 1.1f, "Expected float at key 'first'");
}
// #endregion getFloat(Json[string] map, key)
// #endregion key

// #region getFloats(Json[string] map)
/** 
  * Retrieves all floats from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A float[string] containing all floats found in the Json map.
**/
float[string] getFloats(Json[string] map) {
  mixin(ShowFunction!());

  float[string] result;
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
  * Retrieves all floats at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the floats to retrieve.
  * Returns:
  *   An float[] of floats found at the specified indices.
**/
float[] getFloats(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isFloat)
    .map!(json => json.getFloat).array;
}
///
unittest {
  mixin(ShowTest!"Testing getFloats for Json[] with indices");

  Json[] jsons = [1.1.toJson, ["a": 1].toJson, 2.2.toJson, [3, 4].toJson];
  auto floats = jsons.getFloats([0, 2]);
  assert(floats.length == 2, "Expected 2 floats");
  assert(floats[0] == 1.1f, "Expected float at index 0");
  assert(floats[1] == 2.2f, "Expected float at index 2");
}
// #endregion getFloats(Json[], indices) 

// #region getFloat(Json[], index)
/** 
  * Retrieves the float at the specified index from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *  index = The index of the float to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The float at the specified index, or the default value if not found.
**/
float getFloat(Json[] jsons, size_t index, float defaultValue = 0.0) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isFloat ? jsons[index].getFloat : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getFloat for Json[] with index");

  Json[] jsons = [1.1.toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getFloat(0) == 1.1f, "Expected float at index 0");
}
// #endregion getFloat(Json[], index)
