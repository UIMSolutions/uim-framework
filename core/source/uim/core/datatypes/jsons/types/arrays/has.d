/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.arrays.has;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
bool hasAllArrays(Json[] jsons, size_t[] indices) {
  return indices.all!(index => jsons[index].isArray);
}
/// 
unittest {
  mixin(ShowTest!"Json[] hasAllArrays(Json[], size_t[] indices)");
  
  Json[] jsons = [[1, 2, 3].toJson, ["a": 1].toJson, [4, 5].toJson];
  size_t[] indicesAll = [0, 2];
  size_t[] indicesAny = [1, 2];

  assert(hasAllArrays(jsons, indicesAll) == true);
}

bool hasAnyArrays(Json[] jsons, size_t[] indices) {
  return indices.any!(index => jsons[index].isArray);
}
/// 
unittest {
  mixin(ShowTest!"Json[] hasAnyArrays(Json[], size_t[] indices)");
  
  Json[] jsons = [[1, 2, 3].toJson, ["a": 1].toJson, [4, 5].toJson];
  size_t[] indicesAll = [0, 2];
  size_t[] indicesAny = [1, 2];

  assert(hasAnyArrays(jsons, indicesAny) == true);
}
// #endregion indices
// #endregion Json[]

// #region Json[string]
bool hasAllArrays(Json[string] map, string[][] paths) {
  return paths.all!(path => map.getValue(path).isArray);
}
/// 
unittest {
  mixin(ShowTest!"Json[string] hasAllArrays(Json[string], string[][] paths)");
  
  Json[string] map = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson];
  string[][] pathsAll = [["first"], ["third"]];
  string[][] pathsAny = [["second"], ["third"]];

  assert(hasAllArrays(map, pathsAll) == true);
}

bool hasAnyArrays(Json[string] map, string[][] paths) {
  return paths.any!(path => map.getValue(path).isArray);
}
/// 
unittest {
  mixin(ShowTest!"Json[string] hasAnyArrays(Json[string], string[][] paths)");
  
  Json[string] map = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson];
  string[][] pathsAll = [["first"], ["third"]];
  string[][] pathsAny = [["second"], ["third"]];

  assert(hasAnyArrays(map, pathsAny) == true);
}

bool hasAllArrays(Json[string] map, string[] keys) {
  return keys.all!(key => map[key].isArray);
}
/// 
unittest {
  mixin(ShowTest!"Json[string] hasAllArrays(Json[string], string[] keys)");
  
  Json[string] map = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson];
  string[] keysAll = ["first", "third"];
  string[] keysAny = ["second", "third"];

  assert(hasAllArrays(map, keysAll) == true);
}

bool hasAnyArrays(Json[string] map, string[] keys) {
  return keys.any!(key => map.getValue(key).isArray);
}
/// 
unittest {
  mixin(ShowTest!"Json[string] hasAnyArrays(Json[string], string[] keys)");
  
  Json[string] map = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson];
  string[] keysAll = ["first", "third"];
  string[] keysAny = ["second", "third"];

  assert(hasAnyArrays(map, keysAny) == true);
}
// #endregion Json[string]

// #region Json
bool hasAllArrays(Json json, size_t[] indices) {
  return json.isArray ? indices.all!(index => json[index].isArray) : false;
}
/// 
unittest {
  mixin(ShowTest!"Json hasAllArrays(Json, size_t[] indices)");
  
  Json jsonArray = [[1, 2].toJson, [3, 4].toJson, [4, 5].toJson].toJson;
  size_t[] indicesAll = [0, 1];

  assert(hasAllArrays(jsonArray, indicesAll), "Expected all arrays at specified indices");
}

bool hasAnyArrays(Json json, size_t[] indices) {
  return json.isArray ? indices.any!(index => json[index].isArray) : false;
}
/// 
unittest {
  mixin(ShowTest!"Json hasAnyArrays(Json, size_t[] indices)");
  
  Json jsonArray = [[1, 2].toJson, [3, 4].toJson, [4, 5].toJson].toJson;
  size_t[] indicesAny = [1, 3];

  assert(hasAnyArrays(jsonArray, indicesAny), "Expected at least one array at specified indices");
}

bool hasAllArrays(Json json, string[][] paths) {
  return json.isObject ? paths.all!(path => json.getValue(path).isArray) : false;
}
/// 
unittest {
  mixin(ShowTest!"Json hasAllArrays(Json, string[][] paths)");
  
  Json jsonObject = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson].toJson;
  string[][] pathsAll = [["first"], ["third"]];
  string[][] pathsAny = [["second"], ["third"]];

  assert(hasAllArrays(jsonObject, pathsAll) == true);
}

bool hasAnyArrays(Json json, string[][] paths) {
  return json.isObject ? paths.any!(path => json.getValue(path).isArray) : false;
}
/// 
unittest {
  mixin(ShowTest!"Json hasAnyArrays(Json, string[][] paths)");
  
  Json jsonObject = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson].toJson;
  string[][] pathsAll = [["first"], ["third"]];
  string[][] pathsAny = [["second"], ["third"]];

  assert(hasAnyArrays(jsonObject, pathsAny) == true);
}

bool hasAllArrays(Json json, string[] keys) {
  return json.isObject ? keys.all!(key => json.getValue(key).isArray) : false;
}
/// 
unittest {
  mixin(ShowTest!"Json hasAllArrays(Json, string[] keys)");
  
  Json jsonObject = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson].toJson;
  string[] keysAll = ["first", "third"];
  string[] keysAny = ["second", "third"];

  assert(hasAllArrays(jsonObject, keysAll) == true);
}

bool hasAnyArrays(Json json, string[] keys) {
  return json.isObject ? keys.any!(key => json.getValue(key).isArray) : false;
}
/// 
unittest {
  mixin(ShowTest!"Json hasAnyArrays(Json, string[] keys)");
  
  Json jsonObject = ["first": [1, 2, 3].toJson, "second": ["a": 1].toJson, "third": [4, 5].toJson].toJson;
  string[] keysAll = ["first", "third"];
  string[] keysAny = ["second", "third"];

  assert(jsonObject.hasAnyArrays(keysAny) == true);
}
// #endregion Json