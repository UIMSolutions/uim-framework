/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.strings.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region index
Json[] getStrings(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isString);
}
/**
  * Retrieves the string at the specified index from the Json array.
  *
  * Params:
  *  jsons = The string of Json objects to retrieve from.
  *  index = The index of the string to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The string at the specified index, or the default value if not found.
*/
Json getString(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isString() ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[] with index");

  Json[] jsons = ["abc".toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getString(0) == "abc".toJson, "Expected string at index 0");
}
// #endregion index

// #region base
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The string of Json objects to retrieve from.
  *
  * Returns:
  *  An string of Json arrays found in the input array.
**/
Json[] getStrings(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isString).array;
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region path
/**
  * Retrieves the string at the specified path from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  path = The path of the string to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The string at the specified path, or the default value if not found.
**/
Json getString(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  mixin(ShowFunction!());

  return map.getValue(path).isString ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[string] with path");

  Json[string] map = [
    "first": "abc".toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getString("first") == "abc".toJson, "Expected string at path 'first'");
}
// #endregion path

// #region key
Json[] getStrings(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  Json[] result;
  foreach (key, value; map) {
    if (keys.canFind(key) && value.isString) {
      result ~= value;
    }
  }
  return result; 
}
/**
  * Retrieves the string at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the string to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The string at the specified key, or the default value if not found.
**/
Json getString(Json[string] map, string key, Json defaultValue = Json(null)) {
  mixin(ShowFunction!());

  return map.getValue(key).isString ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[string] with key");

  Json[string] map = [
    "first": "abc".toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getString("first") == "abc".toJson, "Expected string at key 'first'");
}
// #endregion key

// #region base
/** 
  * Retrieves all arrays from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all arrays found in the Json map.
**/
Json[string] getStrings(Json[string] map) {
  mixin(ShowFunction!());

  Json[string] result;
  foreach (key, value; map) {
    if (value.isString) {
      result[key] = value;
    }
  }
  return result;
}
// #endregion Json[string]

// #region Json
// #region index
/**
  * Retrieves the string at the specified index from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the string to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The string at the specified index, or the default value if not found.
*/
Json getString(Json json, size_t index, Json defaultValue = Json(null)) {
  mixin(ShowFunction!());

  return json.isString(index) ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString with index");

  Json json = ["abc".toJson, ["a": 1].toJson, [3, 4].toJson].toJson;
  assert(json.getString(0) == "abc".toJson, "Expected string at index 0");
  assert(json.getString(1, Json("default")) == Json("default"), "Expected default value for non-array at index 1");
}
// #endregion index

// #region path
/**
  * Retrieves the string at the specified path from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the string to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The string at the specified path, or the default value if not found.
**/
Json getString(Json json, string[] path, Json defaultValue = Json(null)) {
  mixin(ShowFunction!());

  return json.isString(path) ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString with path");

  Json json = parseJsonString(`{"data": { "test": [ "abc", {"a": 1}, [3, 4] ]}}`);
  // assert(json.getString(["data", "test"])[0] == "abc".toJson, "Expected string at path ['data', 'test'][0]");
  // assert(json.getString(["data", "test"]).filterArrays()[0] == "abc".toJson, "Expected filtered string at path ['data', 'test'][0]");
}
// #endregion path

// #region key
/**
  * Retrieves the string at the specified key from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  key = The key of the string to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The string at the specified key, or the default value if not found.
**/
Json getString(Json json, string key, Json defaultValue = Json(null)) {
  mixin(ShowFunction!());

  return json.isString(key) ? json.getValue(key) : defaultValue;
}
// #endregion key

// #region base
/** 
  * Retrieves all arrays from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all arrays found in the Json object.
**/
Json[] getStrings(Json json) {
  mixin(ShowFunction!());

  return json.getValues((Json value) => value.isString);
}
/// 
unittest {
  mixin(ShowTest!"Testing getStrings for Json");

  Json jsonArray = [
    "abc".toJson, ["a": 1].toJson, [3, 4].toJson, 42.toJson
  ].toJson;
  auto arraysFromArray = jsonArray.getStrings;
  // TODO
}
// #endregion Json
