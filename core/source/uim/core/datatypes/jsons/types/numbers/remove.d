/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.numbers.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeNumbers(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isNumber && removeFunc(index));
}

Json[] removeNumbers(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isNumber);
}

Json[] removeNumbers(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isNumber && removeFunc(index));
}
// #endregion indices

// #region values
Json[] removeNumbers(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isNumber && removeFunc(json));
}

Json[] removeNumbers(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isNumber);
}

Json[] removeNumbers(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isNumber && removeFunc(json));
}
// #endregion values

// #region base
Json[] removeNumbers(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isNumber);
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region paths
Json[string] removeNumbers(Json[string] map, string[][] paths, bool delegate(string[] path) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removePaths(paths, (string[] path) => map.getValue(path).isNumber && removeFunc(path));
}

Json[string] removeNumbers(Json[string] map, string[][] paths) {
  mixin(ShowFunction!());

  return map.removePaths(paths, (string[] path) => map.getValue(path).isNumber);
}
// #endregion paths

// #region keys
Json[string] removeNumbers(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isNumber && removeFunc(key));
}

Json[string] removeNumbers(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isNumber);
}

Json[string] removeNumbers(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isNumber && removeFunc(key));
}
// #endregion keys

// #region values
Json[string] removeNumbers(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isNumber && removeFunc(json));
}

Json[string] removeNumbers(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isNumber);
}

Json[string] removeNumbers(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isNumber && removeFunc(json));
}
// #endregion values

// #region base
Json[string] removeNumbers(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isNumber);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeNumbers(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isNumber && removeFunc(index));
}

Json removeNumbers(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isNumber);
}

Json removeNumbers(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isNumber && removeFunc(index));
}
// #endregion indices

// #region keys
Json removeNumbers(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isNumber && removeFunc(key));
}

Json removeNumbers(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isNumber);
}

Json removeNumbers(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isNumber && removeFunc(key));
}
// #endregion keys

// #region values
Json removeNumbers(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isNumber && removeFunc(j));
}

Json removeNumbers(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isNumber);
}

Json removeNumbers(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isNumber && removeFunc(j));
}
// #endregion values

// #region base
Json removeNumbers(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isNumber);
}
// #endregion base
// #endregion Json


