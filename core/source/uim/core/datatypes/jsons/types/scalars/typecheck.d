/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.scalars.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
bool isAllScalar(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isScalar)
    : indices.all!(index => jsons.isScalar(index));
}

bool isAnyScalar(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isScalar)
    : indices.any!(index => jsons.isScalar(index));
}

bool isScalar(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isScalar;
}
// #endregion Json[]

// #region Json[string]
bool isAllScalar(Json[string] map, string[] keys = null) {
  return keys.length == 0 
    ? map.getValues.isAllScalar
    : map.getValues(keys).isAllScalar;
}

bool isAnyScalar(Json[string] map, string[] keys = null) {
 return keys.length == 0 
    ? map.getValues.isAnyScalar
    : map.getValues(keys).isAnyScalar;
}

bool isScalar(Json[string] map, string key) {
  return map.getValue(key).isScalar;
}
// #endregion Json[string]

// #region Json
// #region path
bool isAllScalar(Json json, string[][] paths) {
  return json.isScalar && paths.length > 0
    ? paths.all!(path => json.isScalar(path)) : false;
}

bool isAnyScalar(Json json, string[][] paths) {
  return json.isScalar && paths.length > 0
    ? paths.any!(path => json.isScalar(path)) : false;
}

bool isScalar(Json json, string[] path) {
  return json.getValue(path).isScalar;
}
// #endregion path

// #region key
bool isAllScalar(Json json, string[] keys) {
  return json.isScalar && keys.length > 0
    ? keys.all!(key => json.isScalar(key)) : false;
}

bool isAnyScalar(Json json, string[] keys) {
  return json.isScalar && keys.length > 0
    ? keys.any!(key => json.isScalar(key)) : false;
}

bool isScalar(Json json, string key) {
  return json.getValue(key).isScalar;
}
// #region key

// #region index
bool isAllScalar(Json json, size_t[] indices) {
  return json.isScalar && indices.length > 0
    ? indices.all!(index => json.isScalar(index)) : false;
}

bool isAnyScalar(Json json, size_t[] indices) {
  return json.isScalar && indices.length > 0
    ? indices.any!(index => json.isScalar(index)) : false;
}

bool isScalar(Json json, size_t index) {
  return json.getValue(index).isScalar;
}
// #endregion index

bool isScalar(Json json) {
  return !json.isArray && !json.isObject;
}
// #endregion Json