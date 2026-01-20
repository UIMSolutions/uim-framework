/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region all
bool isAllDouble(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isDouble) : indices.all!(
      index => jsons.isDouble(index));
}
// #endregion all

// #region any
bool isAnyDouble(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isDouble) : indices.any!(
      index => jsons.isDouble(index));
}
// #endregion any

// #region is
bool isDouble(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isDouble;
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
bool isAllDouble(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isDouble(path)) : false;
}
// #endregion all

// #region any
bool isAnyDouble(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isDouble(path)) : false;
}
// #endregion any

// #region is
bool isDouble(Json[string] map, string[] path) {
  return map.getValue(path).isDouble;
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllDouble(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.all!(key => map.getValue(key)
        .isDouble) : map.getValues.all!(value => value.isDouble);
}
// #endregion all

// #region any
bool isAnyDouble(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.any!(key => map.getValue(key)
        .isDouble) : map.getValues.any!(value => value.isDouble);
}
// #endregion any

// #region is
bool isDouble(Json[string] map, string key) {
  return map.getValue(key).isDouble;
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
bool isAllDouble(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isDouble(index)) : false;
}

bool isAnyDouble(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isDouble(index)) : false;
}

bool isDouble(Json json, size_t index) {
  return json.getValue(index).isDouble;
}
// #endregion index

// #region paths
// #region all
bool isAllDouble(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isDouble(path)) : false;
}
// #endregion all

// #region any
bool isAnyDouble(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isDouble(path)) : false;
}
// #endregion any

// #region is
bool isDouble(Json json, string[] path) {
  return json.getValue(path).isDouble;
}
// #endregion is
// #endregion paths

// #region key
bool isAllDouble(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAllDouble : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAllDouble : json.toMap.isAllDouble(keys);
  }
  return false;
}

bool isAnyDouble(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAnyDouble : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAnyDouble : json.toMap.isAnyDouble(keys);
  }
  return false;
}

bool isDouble(Json json, string key) {
  return json.getValue(key).isDouble;
}
// #region key

// #region base
bool isDouble(Json json) {
  return (json.type == Json.Type.float_);
}
// #endregion base
// #endregion Json
