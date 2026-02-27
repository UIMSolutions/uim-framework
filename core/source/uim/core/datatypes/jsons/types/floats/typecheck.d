/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region all
bool isAllFloat(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isFloat) : indices.all!(
      index => jsons.isFloat(index));
}
// #endregion all

// #region any
bool isAnyFloat(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isFloat) : indices.any!(
      index => jsons.isFloat(index));
}
// #endregion any

// #region is
bool isFloat(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isFloat;
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
bool isAllFloat(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isFloat(path)) : false;
}
// #endregion all

// #region any
bool isAnyFloat(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isFloat(path)) : false;
}
// #endregion any

// #region is
bool isFloat(Json[string] map, string[] path) {
  return map.getValue(path).isFloat;
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllFloat(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.all!(key => map.getValue(key)
        .isFloat) : map.getValues.all!(value => value.isFloat);
}
// #endregion all

// #region any
bool isAnyFloat(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.any!(key => map.getValue(key)
        .isFloat) : map.getValues.any!(value => value.isFloat);
}
// #endregion any

// #region is
bool isFloat(Json[string] map, string key) {
  return map.getValue(key).isFloat;
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
bool isAllFloat(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isFloat(index)) : false;
}

bool isAnyFloat(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isFloat(index)) : false;
}

bool isFloat(Json json, size_t index) {
  return json.getValue(index).isFloat;
}
// #endregion index

// #region paths
// #region all
bool isAllFloat(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isFloat(path)) : false;
}
// #endregion all

// #region any
bool isAnyFloat(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isFloat(path)) : false;
}
// #endregion any

// #region is
bool isFloat(Json json, string[] path) {
  return json.getValue(path).isFloat;
}
// #endregion is
// #endregion paths

// #region key
bool isAllFloat(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAllFloat : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAllFloat : json.toMap.isAllFloat(keys);
  }
  return false;
}

bool isAnyFloat(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAnyFloat : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAnyFloat : json.toMap.isAnyFloat(keys);
  }
  return false;
}

bool isFloat(Json json, string key) {
  return json.getValue(key).isFloat;
}
// #region key

// #region base
bool isFloat(Json json) {
  return (json.type == Json.Type.float_);
}
// #endregion base
// #endregion Json
