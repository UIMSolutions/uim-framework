/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.numbers.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
bool isAllNumber(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isNumber)
    : indices.all!(index => jsons.isNumber(index));
}

bool isAnyNumber(Json[] jsons, size_t[] indices = null) {
  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isNumber)
    : indices.any!(index => jsons.isNumber(index));
}

bool isNumber(Json[] jsons, size_t index) {
  return jsons.length > index && jsons.getValue(index).isNumber;
}
// #endregion Json[]

// #region Json[string]
bool isAllNumber(Json[string] map, string[] keys = null) {
  return keys.length == 0 
    ? map.getValues.isAllNumber
    : map.getValues(keys).isAllNumber;
}

bool isAnyNumber(Json[string] map, string[] keys = null) {
 return keys.length == 0 
    ? map.getValues.isAnyNumber
    : map.getValues(keys).isAnyNumber;
}

bool isNumber(Json[string] map, string key) {
  return map.getValue(key).isNumber;
}
// #endregion Json[string]

// #region Json
// #region path
bool isAllNumber(Json json, string[][] paths) {
  return json.isNumber && paths.length > 0
    ? paths.all!(path => json.isNumber(path)) : false;
}

bool isAnyNumber(Json json, string[][] paths) {
  return json.isNumber && paths.length > 0
    ? paths.any!(path => json.isNumber(path)) : false;
}

bool isNumber(Json json, string[] path) {
  return json.getValue(path).isNumber;
}
// #endregion path

// #region key
bool isAllNumber(Json json, string[] keys) {
  return json.isNumber && keys.length > 0
    ? keys.all!(key => json.isNumber(key)) : false;
}

bool isAnyNumber(Json json, string[] keys) {
  return json.isNumber && keys.length > 0
    ? keys.any!(key => json.isNumber(key)) : false;
}

bool isNumber(Json json, string key) {
  return json.getValue(key).isNumber;
}
// #region key

// #region index
bool isAllNumber(Json json, size_t[] indices) {
  return json.isNumber && indices.length > 0
    ? indices.all!(index => json.isNumber(index)) : false;
}

bool isAnyNumber(Json json, size_t[] indices) {
  return json.isNumber && indices.length > 0
    ? indices.any!(index => json.isNumber(index)) : false;
}

bool isNumber(Json json, size_t index) {
  return json.getValue(index).isNumber;
}
// #endregion index

bool isNumber(Json json) {
  return json.isInteger || json.isFloat;
}
// #endregion Json