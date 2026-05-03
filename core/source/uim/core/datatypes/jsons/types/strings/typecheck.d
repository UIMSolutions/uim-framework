/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.strings.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:


// #region base
bool isString(Json json) {
  return (json.type == Json.Type.string);
}
///
unittest {
  assert( Json("Hello, World!").isString);
  assert(!Json(42).isString);
  assert(!Json(true).isString);
  assert(!Json(null).isString);
}

bool isString(Json[] list) {
  return false;
}
///
unittest {
  assert(!["Hello", "World"].toJson.isString);
  assert(![1, 2, 3].toJson.isString);
}

bool isString(Json[string] map) {
  return false;
}
///
unittest {
  assert(!["key": "value"].toJson.isString);
  assert(!["key": 42].toJson.isString);
}
// #endregion base

// #region Json[]
// #region indices
// #region all
/** 
  * Checks if all of the specified indices in the Json array are strings.
  * 
  * Params:
  *   jsons = An array of Json elements.
  *   indices = An array of indices to check within the Json array. If null or empty, checks all indices.
  * 
  * Returns:
  *   true if all of the specified indices are strings, false otherwise.
  */
bool isAllString(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isString) : indices.all!(
      index => jsons.isString(index));
}
///
unittest {
  assert(["Hello", "World"].toJson.isAllString);
  assert(![Json("Hello"), Json(42)].toJson.isAllString);
} 
// #endregion all

// #region any
/** 
  * Checks if any of the specified indices in the Json array is a string.
  * 
  * Params:
  *   jsons = An array of Json elements.
  *   indices = An array of indices to check within the Json array.
  * 
  * Returns:
  *   true if any of the specified indices is a string, false otherwise.
  */
bool isAnyString(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isString) : indices.any!(
      index => jsons.isString(index));
}
///
unittest {
  assert([Json("Hello"), Json("World")].toJson.isAllString);
  assert(![Json("Hello"), Json(42)].toJson.isAllString);
  assert([Json("Hello"), Json("World")].toJson.isAnyString);
  assert([Json("Hello"), Json(42)].toJson.isAnyString);
  assert(![Json(1), Json(2), Json(3)].toJson.isAnyString);
}
// #endregion any

// #region is
/** 
  * Checks if the value at the specified index in the Json array is a string.
  * 
  * Params:
  *   jsons = An array of Json elements.
  *   index = The index whose value is to be checked.
  * 
  * Returns:
  *   true if the value at the specified index is a string, false otherwise.
  */
bool isString(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isString;
}
///
unittest {
  assert([Json("Hello"), Json("World")].toJson.isString(0));
  assert([Json("Hello"), Json("World")].toJson.isString(1));
  assert(![Json("Hello"), Json(42)].toJson.isString(1));
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
/** 
  * Checks if all specified paths in the Json[string] map lead to string values.
  * 
  * Params:
  *   map = The Json[string] map to check.
  *   paths = An array of paths (each path is an array of keys) to check within the Json[string] map.
  * 
  * Returns:
  *   true if all specified paths lead to string values, false otherwise.
  */
bool isAllString(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isString(path)) : false;
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAllString([["key1"], ["key2"]]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isAllString([["key1"], ["key2"]]));
}
// #endregion all

// #region any
/** 
  * Checks if any of the specified paths in the Json[string] map leads to a string value.
  * 
  * Params:
  *   map = The Json[string] map to check.
  *   paths = An array of paths (each path is an array of keys) to check within the Json[string] map.
  * 
  * Returns:
  *   true if any of the specified paths leads to a string value, false otherwise.
  */
bool isAnyString(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isString(path)) : false;
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAllString([["key1"], ["key2"]]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isAllString([["key1"], ["key2"]]));
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAnyString([["key1"], ["key2"]]));
  assert(["key1": Json("value1"), "key2": Json(42)].toJson.isAnyString([["key1"], ["key2"]]));
  assert(!["key1": Json(42), "key2": Json(42)].toJson.isAnyString([["key1"], ["key2"]]));
}
// #endregion any

// #region is
/** 
  * Checks if the value at the specified path in the Json[string] map is a string.
  * 
  * Params:
  *   map = The Json[string] map to check.
  *   path = The path (array of keys) whose value is to be checked.
  * 
  * Returns:
  *   true if the value at the specified path is a string, false otherwise.
  */
bool isString(Json[string] map, string[] path) {
  return map.getValue(path).isString;
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isString(["key1"]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isString(["key2"]));
}
// #endregion is
// #endregion paths

// #region keys
// #region all
/** 
  * Checks if all specified keys in the Json[string] map have string values.
  * 
  * Params:
  *   map = The Json[string] map to check.
  *   keys = An array of keys to check within the Json[string] map. If null or empty, checks all keys.
  * 
  * Returns:
  *   true if all specified keys have string values, false otherwise.
  */
bool isAllString(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.all!(key => map.getValue(key)
        .isString) : map.getValues.all!(value => value.isString);
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAllString(["key1", "key2"]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isAllString(["key1", "key2"]));
}
// #endregion all

// #region any
/** 
  * Checks if any of the values at the specified keys in the Json[string] map is a string.
  * 
  * Params:
  *   map = The Json[string] map to check.
  *   keys = An array of keys whose values are to be checked. If null or empty, checks all keys.
  * 
  * Returns:
  *   true if any of the values at the specified keys is a string, false otherwise.
  */
bool isAnyString(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.any!(key => map.getValue(key)
        .isString) : map.getValues.any!(value => value.isString);
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAnyString(["key1", "key2"]));
  assert(["key1": Json("value1"), "key2": Json(42)].toJson.isAnyString(["key1", "key2"]));
  assert(!["key1": Json(42), "key2": Json(42)].toJson.isAnyString(["key1", "key2  "]));
}
// #endregion any

// #region is
/** 
  * Checks if the value at the specified key in the Json[string] map is a string.
  * 
  * Params:
  *   map = The Json[string] map to check.
  *   key = The key whose value is to be checked.
  * 
  * Returns:
  *   true if the value at the specified key is a string, false otherwise.
  */
bool isString(Json[string] map, string key) {
  return map.getValue(key).isString;
}
///
unittest {
  assert(["key": "value"].toJson.isString("key"));
  assert(!["key": 42].toJson.isString("key"));
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
/** 
  * Checks if all specified indices in the Json array are strings.
  * 
  * Params:
  *   json = The Json object to check.
  *   indices = An array of indices to check within the Json array.
  * 
  * Returns:
  *   true if all specified indices are strings, false otherwise.
  */
bool isAllString(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isString(index)) : false;
}
///
unittest {
  assert([Json("Hello"), Json("World")].toJson.isAllString([0, 1]));
  assert(![Json("Hello"), Json(42)].toJson.isAllString([0, 1]));
}

/** 
  * Checks if any of the specified indices in the Json array is a string.
  * 
  * Params:
  *   json = The Json object to check.
  *   indices = An array of indices to check within the Json array.
  * 
  * Returns:
  *   true if any of the specified indices is a string, false otherwise.
  */
bool isAnyString(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isString(index)) : false;
}
///
unittest {
  assert([Json("Hello"), Json("World")].toJson.isAllString([0, 1]));
  assert(![Json("Hello"), Json(42)].toJson.isAllString([0, 1]));
  assert([Json("Hello"), Json("World")].toJson.isAnyString([0, 1]));
  assert([Json("Hello"), Json(42)].toJson.isAnyString([0, 1]));
  assert(![Json(42), Json(42)].toJson.isAnyString([0, 1]));
}

/** 
  * Checks if the value at the specified index in the Json array is a string.
  * 
  * Params:
  *   json = The Json object to check.
  *   index = The index whose value is to be checked.
  * 
  * Returns:
  *   true if the value at the specified index is a string, false otherwise.
  */
bool isString(Json json, size_t index) {
  return json.getValue(index).isString;
}
///
unittest {
  assert([Json("Hello"), Json("World")].toJson.isAllString([0, 1]));
  assert(![Json("Hello"), Json(42)].toJson.isAllString([0, 1]));
  assert([Json("Hello"), Json("World")].toJson.isAnyString([0, 1]));
  assert([Json("Hello"), Json(42)].toJson.isAnyString([0, 1]));
  assert(![Json(42), Json(42)].toJson.isAnyString([0, 1]));
}
// #endregion index

// #region paths
// #region all
/** 
  * Checks if all specified paths in the Json object lead to string values.
  * 
  * Params:
  *   json = The Json object to check.
  *   paths = An array of paths (each path is an array of keys) to check within the Json object.
  * 
  * Returns:
  *   true if all specified paths lead to string values, false otherwise.
  */
bool isAllString(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isString(path)) : false;
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAllString([["key1"], ["key2"]]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isAllString([["key1"], ["key2"]]));
}
// #endregion all

// #region any
/** 
  * Checks if any of the specified paths in the Json object leads to a string value.
  * 
  * Params:
  *   json = The Json object to check.
  *   paths = An array of paths (each path is an array of keys) to check within the Json object.
  * 
  * Returns:
  *   true if any of the specified paths leads to a string value, false otherwise.
  */
bool isAnyString(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isString(path)) : false;
}
/// 
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAnyString([["key1"], ["key2"]]));
  assert(["key1": Json("value1"), "key2": Json(42)].toJson.isAnyString([["key1"], ["key2"]]));
  assert(!["key1": Json(42), "key2": Json(42)].toJson.isAnyString([["key1"], ["key2"]]));
}
// #endregion any

// #region is
bool isString(Json json, string[] path) {
  return json.getValue(path).isString;
}
// #endregion is
// #endregion paths

// #region key
// #region json, string
/** 
  * Checks if the value at the specified key in the Json object is a string.
  * 
  * Params:
  *   json = The Json object to check.
  *   key = The key whose value is to be checked.
  * 
  * Returns:
  *   true if the value at the specified key is a string, false otherwise.
  */
bool isString(Json json, string key) {
  return json.getValue(key).isString;
}
///
unittest {
  assert(["key": "value"].toJson.isString("key"));
  assert(!["key": 42].toJson.isString("key"));
}
// #endregion json, string

// #region all(json, string[])
/** 
  * Checks if all specified keys in the Json object have string values.
  * 
  * Params:
  *   json = The Json object to check.
  *   keys = An array of keys to check within the Json object. If null or empty, checks all keys.
  * 
  * Returns:
  *   true if all specified keys have string values, false otherwise.
  */
bool isAllString(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAllString : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAllString : json.toMap.isAllString(keys);
  }
  return false;
}
///
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAllString(["key1", "key2"]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isAllString(["key1", "key2"]));
  assert(!["key1": Json("value1"), "key2": Json(42)].toJson.isAllString(["key1", "key2"]));
}
// #endregion all(json, string[])

// #region any(json, string[])
/** 
  * Checks if any of the values at the specified keys in the Json object is a string.
  * 
  * Params:
  *   json = The Json object to check.
  *   keys = An array of keys whose values are to be checked.
  * 
  * Returns:
  *   true if any of the values at the specified keys is a string, false otherwise.
  */
bool isAnyString(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAnyString : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAnyString : json.toMap.isAnyString(keys);
  }
  return false;
}
/// 
unittest {
  assert(["key1": Json("value1"), "key2": Json("value2")].toJson.isAnyString(["key1", "key2"]));
  assert(["key1": Json("value1"), "key2": Json(42)].toJson.isAnyString(["key1", "key2"]));
  assert(!["key1": Json(42), "key2": Json(42)].toJson.isAnyString(["key1", "key2"]));
}
// #endregion any(json, string[])
// #region key

// #endregion Json
