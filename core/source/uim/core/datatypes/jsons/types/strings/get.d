/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.strings.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region path
// #region getStrings(json, paths)
/**
  * Retrieves all strings at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the strings to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An string[] containing all strings found at the specified paths.
**/
string[] getStrings(Json json, string[][] paths, string defaultValue = null) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getStrings(paths, defaultValue) : null;
}
// #endregion getStrings(json, paths)

// #region getString(json, path)
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
string getString(Json json, string[] path, string defaultValue = null) {
  mixin(ShowFunction!());

  return json.isString(path) ? json.getValue(path).getString : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString with path");

  Json json = parseJsonString(`{"data": { "test": [ "abc", {"a": 1}, [3, 4] ]}}`);
  // assert(json.getString(["data", "test"])[0] == "abc".toJson, "Expected string at path ['data', 'test'][0]");
  // assert(json.getString(["data", "test"]).filterArrays()[0] == "abc".toJson, "Expected filtered string at path ['data', 'test'][0]");
}
// #endregion getString(json, path)
// #endregion path

// #region key
// #region getStrings(json, keys)
/**
  * Retrieves all strings at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the strings to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An string[] containing all strings found at the specified keys.
**/
string[] getStrings(Json json, string[] keys, string defaultValue = null) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getStrings(keys, defaultValue) : null;
}
// #endregion getStrings(json, keys)

// #region getString(json, key)
/**
  * Retrieves the string at the specified key from the Json object.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the string to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *   The string at the specified key, or the default value if not found.
**/
string getString(Json json, string key, string defaultValue = null) {
  mixin(ShowFunction!());

  return json.isString(key) ? json[key].getString : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json with key");

  Json jsonMap = [
    "first": "abc".toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ].toJson;
  assert(jsonMap.getString("first") == "abc", "Expected string at key 'first'");
}
// #endregion getString(Json, key)
// #endregion key

// #region index
// #region getStrings(json, indices)
/**
  * Retrieves all strings at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the strings to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An string[] containing all strings found at the specified keys.
**/
string[] getStrings(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getStrings(indices) : null;
}
// #endregion getStrings(json, indices)

// #region getString(json, index)
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
**/
string getString(Json json, size_t index, string defaultValue = null) {
  mixin(ShowFunction!());

  return json.isString(index) ? json[index].getString : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json with index");

  Json jsonArray = [
    "abc".toJson, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getString(0) == "abc", "Expected string at index 0");
}
// #endregion getString(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
string[] getStrings(Json[string] map, string[][] paths, string defaultValue = null) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getString(path, defaultValue)).array;
}
/**
  * Retrieves the string at the specified path from the Json map.
  *
  * Params:
  *   map = The Json map to retrieve from.
  *   path = The path of the string to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *   The string at the specified path, or the default value if not found.
**/
string getString(Json[string] map, string[] path, string defaultValue = null) {
  mixin(ShowFunction!());

  return map.getValue(path).isString ? map.getValue(path).getString : defaultValue;
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
// #region getStrings(Json[string] map, keys)
/**
  * Retrieves all strings at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the strings to retrieve.
  * Returns:
  *   An string[] containing all strings found at the specified keys.
**/ 
string[] getStrings(Json[string] map, string[] keys, string defaultValue = null) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getString(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getStrings for Json[string] with keys");

  Json[string] map = [
    "first": "abc".toJson, "second": ["a": 1].toJson, "third": "def".toJson, "fourth": [3, 4].toJson
  ];
  auto strings = map.getStrings(["first", "third", "fourth"]);
  assert(strings.length == 2, "Expected 2 strings");
  assert(strings[0] == "abc", "Expected string at key 'first'");
  assert(strings[1] == "def", "Expected string at key 'third'");
}
// #endregion getStrings(Json[string] map, keys)

// #region getString(Json[string] map, key)
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
string getString(Json[string] map, string key, string defaultValue = null) {
  mixin(ShowFunction!());

  return map.getValue(key).isString ? map.getValue(key).getString : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[string] with key");

  Json[string] map = [
    "first": "abc".toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getString("first") == "abc".toJson, "Expected string at key 'first'");
}
// #endregion getString(Json[string] map, key)
// #endregion key

// #region getStrings(Json[string] map)
/** 
  * Retrieves all arrays from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all arrays found in the Json map.
**/
string[string] getStrings(Json[string] map) {
  mixin(ShowFunction!());

  string[string] result;
  foreach (key, value; map) {
    if (value.isString) {
      result[key] = value.getString;
    }
  }
  return result;
}
// #endregion getStrings(Json[string] map)
// #endregion Json[string]

// #region Json[]
// #region getStrings(Json[], indices) 
/** 
  * Retrieves all strings at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the strings to retrieve.
  * Returns:
  *   An string of strings found at the specified indices.
**/
string[] getStrings(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isString).map!(json => json.getString).array;
}
///
unittest {
  mixin(ShowTest!"Testing getStrings for Json[] with indices");

  Json[] jsons = ["abc".toJson, ["a": 1].toJson, "def".toJson, [3, 4].toJson];
  auto strings = jsons.getStrings([0, 2]);
  assert(strings.length == 2, "Expected 2 strings");
  assert(strings[0] == "abc", "Expected string at index 0");
  assert(strings[1] == "def", "Expected string at index 2");
}
// #endregion getStrings(Json[], indices) 

// #region getString(Json[], index)
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
**/
string getString(Json[] jsons, size_t index, string defaultValue = null) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isString() ? jsons[index].getString : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[] with index");

  Json[] jsons = ["abc".toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getString(0) == "abc" , "Expected string at index 0");
}
// #endregion getString(Json[], index)

// #region getString(Json[])
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The string of Json objects to retrieve from.
  *
  * Returns:
  *  An string of Json arrays found in the input array.
**/
string[] getStrings(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isString).map!(json => json.getString).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getStrings for Json[]");

  Json[] jsons = [
    "abc".toJson, ["a": 1].toJson, "def".toJson, [3, 4].toJson
  ];
  auto strings = jsons.getStrings;
  assert(strings.length == 2, "Expected 2 strings");
  assert(strings[0] == "abc".toJson, "Expected string at index 0");
  assert(strings[1] == "def".toJson, "Expected string at index 1");
}
// #endregion getString(Json[])
// #endregion Json[]

// #region Json
// #region getStrings(Json)
/** 
  * Retrieves all arrays from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all arrays found in the Json object.
**/
string[] getStrings(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getStrings : null;
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
// #endregion getStrings(Json)





// #region getString(Json)
/** 
  * Retrieves the string from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  * Returns:
  *   The string contained in the Json object, or null if not a string.
**/
string getString(Json json) {
  mixin(ShowFunction!());

  return json.isString ? json.get!string : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json");

  Json json = "abc".toJson;
  assert(json.getString == "abc", "Expected string from Json");
}
// #endregion getString(Json)
