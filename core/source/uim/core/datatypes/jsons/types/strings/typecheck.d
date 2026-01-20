/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.strings.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region all
bool isAllString(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isString) : indices.all!(
      index => jsons.isString(index));
}
// #endregion all

// #region any
bool isAnyString(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isString) : indices.any!(
      index => jsons.isString(index));
}
// #endregion any

// #region is
bool isString(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isString;
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
bool isAllString(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isString(path)) : false;
}
// #endregion all

// #region any
bool isAnyString(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isString(path)) : false;
}
// #endregion any

// #region is
bool isString(Json[string] map, string[] path) {
  return map.getValue(path).isString;
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllString(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.all!(key => map.getValue(key)
        .isString) : map.getValues.all!(value => value.isString);
}
// #endregion all

// #region any
bool isAnyString(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.any!(key => map.getValue(key)
        .isString) : map.getValues.any!(value => value.isString);
}
// #endregion any

// #region is
bool isString(Json[string] map, string key) {
  return map.getValue(key).isString;
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
bool isAllString(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isString(index)) : false;
}

bool isAnyString(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isString(index)) : false;
}

bool isString(Json json, size_t index) {
  return json.getValue(index).isString;
}
// #endregion index

// #region paths
// #region all
bool isAllString(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isString(path)) : false;
}
// #endregion all

// #region any
bool isAnyString(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isString(path)) : false;
}
// #endregion any

// #region is
bool isString(Json json, string[] path) {
  return json.getValue(path).isString;
}
// #endregion is
// #endregion paths

// #region key
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

bool isString(Json json, string key) {
  return json.getValue(key).isString;
}
// #region key

// #region base
bool isString(Json json) {
  return (json.type == Json.Type.string);
}
// #endregion base
// #endregion Json
