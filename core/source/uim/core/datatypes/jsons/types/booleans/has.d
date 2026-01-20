/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.has;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region has all indices
bool hasAllBooleans(Json[] jsons, size_t[] indices) {
  return indices.all!(index => jsons.isBoolean(index));
}
// #endregion has all indices

// #region has any indices
bool hasAnyBooleans(Json[] jsons, size_t[] indices) {
  return indices.any!(index => jsons.isBoolean(index));
}
// #endregion has any indices
// #endregion Json[]

// #region Json[string]
// #region paths
bool hasAllBooleans(Json[string] map, string[][] paths) {
  return paths.all!(path => map.isBoolean(path));
}

bool hasAnyBooleans(Json[string] map, string[][] paths) {
  return paths.any!(path => map.isBoolean(path));
}
// #endregion paths

// #region keys
bool hasAllBooleans(Json[string] map, string[] keys) {
  return keys.all!(key => map.isBoolean(key));
}

bool hasAnyBooleans(Json[string] map, string[] keys) {
  return keys.any!(key => map.isBoolean(key));
}
// #endregion keys
// #endregion Json[string]

// #region Json
bool hasAllBooleans(Json json, size_t[] indices) {
  return json.isBoolean ? indices.all!(index => json.isBoolean(index)) : false;
}

bool hasAnyBooleans(Json json, size_t[] indices) {
  return json.isBoolean ? indices.any!(index => json.isBoolean(index)) : false;
}

bool hasAllBooleans(Json json, string[][] paths) {
  return json.isObject ? paths.all!(path => json.isBoolean(path)) : false;
}

bool hasAnyBooleans(Json json, string[][] paths) {
  return json.isObject ? paths.any!(path => json.isBoolean(path)) : false;
}

bool hasAllBooleans(Json json, string[] keys) {
  return json.isObject ? keys.all!(key => json.isBoolean(key)) : false;
}

bool hasAnyBooleans(Json json, string[] keys) {
  return json.isObject ? keys.any!(key => json.isBoolean(key)) : false;
}
// #endregion Json