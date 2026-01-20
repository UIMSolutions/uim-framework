/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.integers.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region all
bool isAllInteger(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isInteger) : indices.all!(
      index => jsons.isInteger(index));
}
// #endregion all

// #region any
bool isAnyInteger(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isInteger) : indices.any!(
      index => jsons.isInteger(index));
}
// #endregion any

// #region is
bool isInteger(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isInteger;
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
bool isAllInteger(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isInteger(path)) : false;
}
// #endregion all

// #region any
bool isAnyInteger(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isInteger(path)) : false;
}
// #endregion any

// #region is
bool isInteger(Json[string] map, string[] path) {
  return map.getValue(path).isInteger;
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllInteger(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.all!(key => map.getValue(key)
        .isInteger) : map.getValues.all!(value => value.isInteger);
}
// #endregion all

// #region any
bool isAnyInteger(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.any!(key => map.getValue(key)
        .isInteger) : map.getValues.any!(value => value.isInteger);
}
// #endregion any

// #region is
bool isInteger(Json[string] map, string key) {
  return map.getValue(key).isInteger;
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
bool isAllInteger(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isInteger(index)) : false;
}

bool isAnyInteger(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isInteger(index)) : false;
}

bool isInteger(Json json, size_t index) {
  return json.getValue(index).isInteger;
}
// #endregion index

// #region paths
// #region all
bool isAllInteger(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isInteger(path)) : false;
}
// #endregion all

// #region any
bool isAnyInteger(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isInteger(path)) : false;
}
// #endregion any

// #region is
bool isInteger(Json json, string[] path) {
  return json.getValue(path).isInteger;
}
// #endregion is
// #endregion paths

// #region key
bool isAllInteger(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAllInteger : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAllInteger : json.toMap.isAllInteger(keys);
  }
  return false;
}

bool isAnyInteger(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAnyInteger : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAnyInteger : json.toMap.isAnyInteger(keys);
  }
  return false;
}

bool isInteger(Json json, string key) {
  return json.getValue(key).isInteger;
}
// #region key

// #region base
bool isInteger(Json json) {
  return (json.type == Json.Type.int_);
}
// #endregion base
// #endregion Json
