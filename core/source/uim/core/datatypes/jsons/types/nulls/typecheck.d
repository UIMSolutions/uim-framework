/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.nulls.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
bool isAllNull(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isNull)
    : indices.all!(index => jsons.isNull(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllNull for Json[]");
    
  Json[] jsons = [Json(null), Json(null), Json(null)];
  assert(isAllNull(jsons));
  assert(isAllNull(jsons, [0, 1]));
  assert(!isAllNull(jsons, [0, 1, 2, 3]));
  
  jsons = [Json(null), Json(5), Json(null)];
  assert(!isAllNull(jsons));
  assert(!isAllNull(jsons, [0, 1]));
  assert(isAllNull(jsons, [0, 2]));
}

bool isAnyNull(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isNull)
    : indices.any!(index => jsons.isNull(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyNull for Json[]");
    
  Json[] jsons = [Json(1), Json(2), Json(3)];
  assert(!isAnyNull(jsons));
  assert(!isAnyNull(jsons, [0, 1]));
  
  jsons = [Json(1), Json(null), Json(3)];
  assert(isAnyNull(jsons));
  assert(isAnyNull(jsons, [0, 1]));
  assert(!isAnyNull(jsons, [0]));
}

bool isNull(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isNull;
}
/// 
unittest {
  mixin(ShowTest!"Testing isNull for Json[]");
    
  Json[] jsons = [Json(1), Json(2), Json(3)];
  assert(!isNull(jsons, 0));
  assert(!isNull(jsons, 1));
  
  jsons = [Json(1), Json(null), Json(3)];
  assert(!isNull(jsons, 0));
  assert(isNull(jsons, 1));
}
// #endregion Json[]

// #region Json[string]
bool isAllNull(Json[string] jsons, string[] keys = null) {
  return keys.length == 0 
    ? jsons.getValues.isAllNull
    : jsons.getValues(keys).isAllNull;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllNull for Json[string]");
    
  Json[string] jsons = [ "a": Json(null), "b": Json(null) ];
  assert(isAllNull(jsons));
  assert(isAllNull(jsons, ["a", "b"]));
  
  jsons = [ "a": Json(null), "b": Json(5) ];
  assert(!isAllNull(jsons));
  assert(!isAllNull(jsons, ["a", "b"]));
  assert(isAllNull(jsons, ["a"]));
}

bool isAnyNull(Json[string] jsons, string[] keys = null) {
  return keys.length == 0 
    ? jsons.getValues.isAnyNull
    : jsons.getValues(keys).isAnyNull;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyNull for Json[string]");
    
  Json[string] jsons = [ "a": Json(1), "b": Json(2) ];
  assert(!isAnyNull(jsons));
  assert(!isAnyNull(jsons, ["a", "b"]));
  
  jsons = [ "a": Json(1), "b": Json(null) ];
  assert(isAnyNull(jsons));
  assert(isAnyNull(jsons, ["a", "b"]));
  assert(!isAnyNull(jsons, ["a"]));
}

bool isNull(Json[string] jsons, string key) {
  return key in jsons ? jsons[key].isNull : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing isNull for Json[string]"); 
  Json[string] jsons = [ "a": Json(1), "b": Json(2) ];
  assert(!isNull(jsons, "a"));
  assert(!isNull(jsons, "b"));

  jsons = [ "a": Json(1), "b": Json(null) ];
  assert(!isNull(jsons, "a"));
  assert(isNull(jsons, "b"));
} 
// #endregion Json[string]

// #region Json
// #region path
bool isAllNull(Json json, string[][] paths) {
  if (json.isNull || paths.length == 0) return false;

  return paths.all!(path => json.isNull(path));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllNull for Json with paths");
    
  Json json = [
    "a": Json(null),
    "b": [
      "c": Json(null),
      "d": Json(5)
    ].toJson
  ].toJson;

  assert(!json.isAllNull([["a"], ["b", "c"], ["b", "d"]]), "Expected false");
  assert(json.isAllNull([["a"], ["b", "c"]]), "Expected true");
}

bool isAnyNull(Json json, string[][] paths) {
  if (json.isNull) return false; 
  if (paths.length == 0) return false;
  
  return paths.any!(path => json.isNull(path));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyNull for Json with paths");
    
  Json json = [
    "a": Json(1),
    "b": [
      "c": Json(null),
      "d": Json(5)
    ].toJson
  ].toJson;
  
  assert(isAnyNull(json, [["a"], ["b", "c"], ["b", "d"]]));
  assert(!isAnyNull(json, [["a"], ["b", "d"]]));
}
bool isNull(Json json, string[] path) {
  return json.getValue(path).isNull;
}
/// 
unittest {
  mixin(ShowTest!"Testing isNull for Json with path");
    
  Json json = [
    "a": Json(1),
    "b": [
      "c": Json(null),
      "d": Json(5)
    ].toJson
  ].toJson;
  
  assert(!isNull(json, ["a"]));
  assert(isNull(json, ["b", "c"]));
}
// #endregion path

// #region key
bool isAllNull(Json json, string[] keys) {
  if (!json.isObject) return false;
  if (keys.length == 0) return false;
  if (!json.hasAllKey(keys)) return false;

  return keys.all!(key => json.isNull(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllNull for Json with keys");
    
  Json json = [
    "a": Json(null),
    "b": Json(5),
    "c": Json(null)
  ].toJson;
  
  assert(!isAllNull(json, ["a", "b", "c"]), "Expected false");
  assert(isAllNull(json, ["a", "c"]), "Expected true");
}

bool isAnyNull(Json json, string[] keys) {
  if (!json.isObject) return false;
  if (keys.length == 0) return false;
  
  return keys.any!(key => json.isNull(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyNull for Json with keys");
    
  Json json = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(null)
  ].toJson;
  
  assert(isAnyNull(json, ["a", "b", "c"]));
  assert(!isAnyNull(json, ["a", "b"]));
}

bool isNull(Json json, string key) {
  if (!json.isObject) return false;
  if (!json.hasKey(key)) return false;

  return json.getValue(key).isNull;
}
/// 
unittest {
  mixin(ShowTest!"Testing isNull for Json with key");
    
  Json json = [
    "a": Json(1),
    "b": Json(null),
    "c": Json(3)
  ].toJson;
  
  assert(!isNull(json, "a"));
  assert(isNull(json, "b"));
}
// #region key

// #region index
bool isAllNull(Json json, size_t[] indices) {
  if (!json.isArray) return false;
  if (indices.length == 0) return false;

  return indices.all!(index => json.isNull(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllNull for Json with indices");
    
  Json json = [ Json(null), Json(5), Json(null) ].toJson;
  
  assert(!isAllNull(json, [0, 1, 2]));
  assert(isAllNull(json, [0, 2]));
}

bool isAnyNull(Json json, size_t[] indices) {
  if (!json.isArray) return false;
  if (indices.length == 0) return false;

  return indices.any!(index => json.isNull(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyNull for Json with indices");
    
  Json json = [ Json(1), Json(null), Json(3) ].toJson;
  
  assert(isAnyNull(json, [0, 1, 2]));
  assert(!isAnyNull(json, [0, 2]));
}

bool isNull(Json json, size_t index) {
  if (!json.isArray) return false;
  if (json.length <= index) return false;

  return json.getValue(index).isNull;
}
/// 
unittest {
  mixin(ShowTest!"Testing isNull for Json with index");
    
  Json json = [ Json(1), Json(null), Json(3) ].toJson;
  
  assert(!isNull(json, 0));
  assert(isNull(json, 1));
}
// #endregion index

bool isNull(Json json) {
  return json == Json(null); 
}
/// 
unittest {
  mixin(ShowTest!"Testing isNull for Json");
    
  assert(isNull(Json(null)));
  assert(!isNull(Json(5)));
}
// #endregion Json