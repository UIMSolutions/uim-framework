/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region all
bool isAllBoolean(Json[] jsons, size_t[] indices = null) {
  return (indices.length == 0 ? jsons.getValues : jsons.getValues(indices))
    .all!(value => value.isBoolean);
}
// #endregion all

// #region any
bool isAnyBoolean(Json[] jsons, size_t[] indices = null) {
  return (indices.length == 0 ? jsons.getValues : jsons.getValues(indices))
    .any!(value => value.isBoolean);
}
// #endregion any

// #region is
bool isBoolean(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isBoolean;
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
bool isAllBoolean(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isBoolean(path)) : false;
}
// #endregion all

// #region any
bool isAnyBoolean(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isBoolean(path)) : false;
}
// #endregion any

// #region is
bool isBoolean(Json[string] map, string[] path) {
  return map.getValue(path).isBoolean;
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllBoolean(Json[string] map, string[] keys = null) {
  return keys.length == 0
    ? map.getValues.all!(value => value.isBoolean)
    : map.getValues(keys).all!(value => value.isBoolean); 
}
// #endregion all

// #region any
bool isAnyBoolean(Json[string] map, string[] keys = null) {
  return keys.length == 0
    ? map.getValues.any!(value => value.isBoolean)
    : map.getValues(keys).any!(value => value.isBoolean); 
}
// #endregion any

// #region is
bool isBoolean(Json[string] map, string key) {
  return map.getValue(key).isBoolean;
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
bool isAllBoolean(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isBoolean(index)) : false;
}

bool isAnyBoolean(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isBoolean(index)) : false;
}

bool isBoolean(Json json, size_t index) {
  return json.getValue(index).isBoolean;
}
// #endregion index

// #region paths
// #region all
bool isAllBoolean(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isBoolean(path)) : false;
}
// #endregion all

// #region any
bool isAnyBoolean(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isBoolean(path)) : false;
}
// #endregion any

// #region is
bool isBoolean(Json json, string[] path) {
  return json.getValue(path).isBoolean;
}
// #endregion is
// #endregion paths

// #region key
bool isAllBoolean(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAllBoolean : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAllBoolean : json.toMap.isAllBoolean(keys);
  }
  return false;
}

bool isAnyBoolean(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAnyBoolean : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAnyBoolean : json.toMap.isAnyBoolean(keys);
  }
  return false;
}

bool isBoolean(Json json, string key) {
  return json.getValue(key).isBoolean;
}
// #region key

// #region base
bool isBoolean(Json json) {
  return (json.type == Json.Type.bool_);
}
// #endregion base
// #endregion Json
