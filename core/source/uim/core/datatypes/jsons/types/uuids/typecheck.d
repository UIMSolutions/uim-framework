/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.uuids.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region all
bool isAllUUID(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isUUID) : indices.all!(
      index => jsons.isUUID(index));
}
// #endregion all

// #region any
bool isAnyUUID(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isUUID) : indices.any!(
      index => jsons.isUUID(index));
}
// #endregion any

// #region is
bool isUUID(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isUUID;
}
// #endregion is
// #endregion indices
// #endregion Json[]

// #region Json[string]
// #region paths
// #region all
bool isAllUUID(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.all!(path => map.isUUID(path)) : false;
}
// #endregion all

// #region any
bool isAnyUUID(Json[string] map, string[][] paths) {
  return paths.length > 0
    ? paths.any!(path => map.isUUID(path)) : false;
}
// #endregion any

// #region is
bool isUUID(Json[string] map, string[] path) {
  return map.getValue(path).isUUID;
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllUUID(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.all!(key => map.getValue(key)
        .isUUID) : map.getValues.all!(value => value.isUUID);
}
// #endregion all

// #region any
bool isAnyUUID(Json[string] map, string[] keys = null) {
  return keys.length > 0
    ? keys.any!(key => map.getValue(key)
        .isUUID) : map.getValues.any!(value => value.isUUID);
}
// #endregion any

// #region is
bool isUUID(Json[string] map, string key) {
  return map.getValue(key).isUUID;
}
// #endregion is
// #endregion keys
// #endregion Json[string]

// #region Json
// #region index
bool isAllUUID(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.all!(index => json.isUUID(index)) : false;
}

bool isAnyUUID(Json json, size_t[] indices) {
  return json.isArray && indices.length > 0
    ? indices.any!(index => json.isUUID(index)) : false;
}

bool isUUID(Json json, size_t index) {
  return json.getValue(index).isUUID;
}
// #endregion index

// #region paths
// #region all
bool isAllUUID(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.all!(path => json.isUUID(path)) : false;
}
// #endregion all

// #region any
bool isAnyUUID(Json json, string[][] paths) {
  return json.isObject && paths.length > 0
    ? paths.any!(path => json.isUUID(path)) : false;
}
// #endregion any

// #region is
bool isUUID(Json json, string[] path) {
  return json.getValue(path).isUUID;
}
// #endregion is
// #endregion paths

// #region key
bool isAllUUID(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAllUUID : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAllUUID : json.toMap.isAllUUID(keys);
  }
  return false;
}

bool isAnyUUID(Json json, string[] keys = null) {
  if (json.isArray) {
    return keys.length == 0
      ? json.toArray().isAnyUUID : false;
  }
  if (json.isObject) {
    return keys.length == 0
      ? json.toMap.isAnyUUID : json.toMap.isAnyUUID(keys);
  }
  return false;
}

bool isUUID(Json json, string key) {
  return json.getValue(key).isUUID;
}
// #region key

// #region base
bool isUUID(Json json) {
  import uim.core.datatypes.uuids.nulls;

  if (!json.isString) {
    return false;
  }

  auto uuid = json.getString;
  if (!uim.core.datatypes.uuids.nulls.isUUID(uuid)) {
    return false;
  }
  
  // Additional checks for UUID can be added here
  return true;
}
///
unittest {
  mixin(ShowTest!"Testing isUUID for Json");

  auto id = randomUUID().toJson;
  assert(isUUID(id));
  assert(!isUUID("not a uuid".toJson));
}
// #endregion base
// #endregion Json
