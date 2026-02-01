/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region path
// #region getBooleans(json, paths)
/**
  * Retrieves all booleans at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the booleans to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An string[] containing all booleans found at the specified paths.
**/
bool[] getBooleans(Json json, string[][] paths, bool defaultValue = false) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getBooleans(paths, defaultValue) : null;
}
// #endregion getBooleans(json, paths)

// #region getBoolean(json, path)
/**
  * Retrieves the boolean at the specified path from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the boolean to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The boolean at the specified path, or the default value if not found.
**/
bool getBoolean(Json json, string[] path, bool defaultValue = false) {
  mixin(ShowFunction!());

  return json.isBoolean(path) ? json.getValue(path).getBoolean : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean with path");

  Json json = parseJsonString(`{"data": { "test": [ 1, {"a": 1}, [3, 4] ]}}`);
  // assert(json.getBoolean(["data", "test"])[0] == true.toJson, "Expected boolean at path ['data', 'test'][0]");
  // assert(json.getBoolean(["data", "test"]).filterArrays()[0] == true.toJson, "Expected filtered boolean at path ['data', 'test'][0]");
}
// #endregion getBoolean(json, path)
// #endregion path

// #region key
// #region getBooleans(json, keys)
/**
  * Retrieves all booleans at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the booleans to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An string[] containing all booleans found at the specified keys.
**/
bool[] getBooleans(Json json, string[] keys, bool defaultValue = false) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getBooleans(keys, defaultValue) : null;
}
// #endregion getBooleans(json, keys)

// #region getBoolean(json, key)
/**
  * Retrieves the boolean at the specified key from the Json object.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the boolean to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *   The boolean at the specified key, or the default value if not found.
**/
bool getBoolean(Json json, string key, bool defaultValue = false) {
  mixin(ShowFunction!());

  return json.isBoolean(key) ? json[key].getBoolean : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json with key");

  Json jsonMap = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ].toJson;
  assert(jsonMap.getBoolean("first") == true, "Expected boolean at key 'first'");
}
// #endregion getBoolean(Json, key)
// #endregion key

// #region index
// #region getBooleans(json, indices)
/**
  * Retrieves all booleans at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   indices = The indices of the booleans to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An string[] containing all booleans found at the specified keys.
**/
bool[] getBooleans(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getBooleans(indices) : null;
}
// #endregion getBooleans(json, indices)

// #region getBoolean(json, index)
/**
  * Retrieves the boolean at the specified index from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the boolean to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The boolean at the specified index, or the default value if not found.
**/
bool getBoolean(Json json, size_t index, bool defaultValue = false) {
  mixin(ShowFunction!());

  return json.isBoolean(index) ? json[index].getBoolean : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json with index");

  Json jsonArray = [
    true.toJson, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getBoolean(0) == true, "Expected boolean at index 0");
}
// #endregion getBoolean(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
bool[] getBooleans(Json[string] map, string[][] paths, bool defaultValue = false) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getBoolean(path, defaultValue)).array;
}
/**
  * Retrieves the boolean at the specified path from the Json map.
  *
  * Params:
  *   map = The Json map to retrieve from.
  *   path = The path of the boolean to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *   The boolean at the specified path, or the default value if not found.
**/
bool getBoolean(Json[string] map, string[] path, bool defaultValue = false) {
  mixin(ShowFunction!());

  return map.getValue(path).isBoolean ? map.getValue(path).getBoolean : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json[string] with path");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getBoolean("first") == true, "Expected boolean at path 'first'");
}
// #endregion path

// #region key
// #region getBooleans(Json[string] map, keys)
/**
  * Retrieves all booleans at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the booleans to retrieve.
  * Returns:
  *   An bool[] containing all booleans found at the specified keys.
**/ 
bool[] getBooleans(Json[string] map, string[] keys, bool defaultValue = false) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getBoolean(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBooleans for Json[string] with keys");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson, "fourth": [3, 4].toJson
  ];
  auto booleans = map.getBooleans(["first", "third", "fourth"]);
  assert(booleans.length == 3, "Expected 3 booleans");
  assert(booleans[0] == true, "Expected boolean at key 'first'");
  assert(booleans[1] == false, "Expected boolean at key 'third'");
}
// #endregion getBooleans(Json[string] map, keys)

// #region getBoolean(Json[string] map, key)
/**
  * Retrieves the boolean at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the boolean to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The boolean at the specified key, or the default value if not found.
**/
bool getBoolean(Json[string] map, string key, bool defaultValue = false) {
  mixin(ShowFunction!());

  return map.getValue(key).isBoolean ? map.getValue(key).getBoolean : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getString for Json[string] with key");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getBoolean("first") == true, "Expected boolean at key 'first'");
}
// #endregion getBoolean(Json[string] map, key)
// #endregion key

// #region getBooleans(Json[string] map)
/** 
  * Retrieves all arrays from the Json map.
  *
  * Params:
  *  jsons = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all arrays found in the Json map.
**/
bool[string] getBooleans(Json[string] map) {
  mixin(ShowFunction!());

  bool[string] result;
  foreach (key, value; map) {
    if (value.isBoolean) {
      result[key] = value.getBoolean;
    }
  }
  return result;
}
// #endregion getBooleans(Json[string] map)
// #endregion Json[string]

// #region Json[]
// #region getBooleans(Json[], indices) 
/** 
  * Retrieves all booleans at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the booleans to retrieve.
  * Returns:
  *   An string of booleans found at the specified indices.
**/
bool[] getBooleans(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isBoolean).map!(json => json.getBoolean).array;
}
///
unittest {
  mixin(ShowTest!"Testing getBooleans for Json[] with indices");

  Json[] jsons = [true.toJson, ["a": 1].toJson, false.toJson, [3, 4].toJson];
  auto booleans = jsons.getBooleans([0, 2]);
  assert(booleans.length == 2, "Expected 2 booleans");
  assert(booleans[0] == true, "Expected boolean at index 0");
  assert(booleans[1] == false, "Expected boolean at index 2");
}
// #endregion getBooleans(Json[], indices) 

// #region getBoolean(Json[], index)
/** 
  * Retrieves the boolean at the specified index from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *  index = The index of the boolean to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The boolean at the specified index, or the default value if not found.
**/
bool getBoolean(Json[] jsons, size_t index, bool defaultValue = false) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isBoolean ? jsons[index].getBoolean : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json[] with index");

  Json[] jsons = [true.toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.getBoolean(0) == true, "Expected boolean at index 0");
}
// #endregion getBoolean(Json[], index)

// #region getBooleans(Json[])
/** 
  * Retrieves all arrays from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *
  * Returns:
  *  An array of booleans found in the input array.
**/
bool[] getBooleans(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isBoolean).map!(json => json.getBoolean).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBooleans for Json[]");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, [3, 4].toJson
  ];
  auto booleans = jsons.getBooleans;
  assert(booleans.length == 2, "Expected 2 booleans");
  assert(booleans[0] == true, "Expected boolean at index 0");
  assert(booleans[1] == false, "Expected boolean at index 1");
}
// #endregion getBooleans(Json[])
// #endregion Json[]

// #region Json
// #region getBooleans(Json)
/** 
  * Retrieves all booleans from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all booleans found in the Json object.
**/
bool[] getBooleans(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getBooleans : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBooleans for Json");

  Json jsonArray = [
    true.toJson, ["a": 1].toJson, [3, 4].toJson, false.toJson
  ].toJson;
  auto arraysFromArray = jsonArray.getBooleans;
  // TODO
}
// #endregion getBooleans(Json)

// #region getBoolean(Json)
/** 
  * Retrieves the boolean from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  * Returns:
  *   The boolean contained in the Json object, or null if not a boolean.
**/
bool getBoolean(Json json) {
  mixin(ShowFunction!());

  return json.isBoolean ? json.get!bool : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json");

  Json json = true.toJson;
  assert(json.getBoolean == true, "Expected boolean from Json");
}
// #endregion getBoolean(Json)
