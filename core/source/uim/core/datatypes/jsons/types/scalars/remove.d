/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.scalars.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeScalars(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isScalar && removeFunc(index));
}

Json[] removeScalars(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isScalar);
}

Json[] removeScalars(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isScalar && removeFunc(index));
}
// #endregion indices

// #region values
Json[] removeScalars(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isScalar && removeFunc(json));
}

Json[] removeScalars(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isScalar);
}

Json[] removeScalars(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isScalar && removeFunc(json));
}
// #endregion values

// #region base
Json[] removeScalars(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isScalar);
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region paths
Json[string] removeScalars(Json[string] map, string[][] paths, bool delegate(string[] path) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removePaths(paths, (string[] path) => map.getValue(path).isScalar && removeFunc(path));
}

Json[string] removeScalars(Json[string] map, string[][] paths) {
  mixin(ShowFunction!());

  return map.removePaths(paths, (string[] path) => map.getValue(path).isScalar);
}
// #endregion paths

// #region keys
Json[string] removeScalars(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isScalar && removeFunc(key));
}

Json[string] removeScalars(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isScalar);
}

Json[string] removeScalars(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isScalar && removeFunc(key));
}
// #endregion keys

// #region values
Json[string] removeScalars(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isScalar && removeFunc(json));
}

Json[string] removeScalars(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isScalar);
}

Json[string] removeScalars(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isScalar && removeFunc(json));
}
// #endregion values

// #region base
Json[string] removeScalars(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isScalar);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeScalars(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isScalar && removeFunc(index));
}

Json removeScalars(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isScalar);
}

Json removeScalars(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isScalar && removeFunc(index));
}
// #endregion indices

// #region keys
Json removeScalars(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isScalar && removeFunc(key));
}

Json removeScalars(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isScalar);
}

Json removeScalars(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isScalar && removeFunc(key));
}
// #endregion keys

// #region values
Json removeScalars(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isScalar && removeFunc(j));
}

Json removeScalars(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isScalar);
}

Json removeScalars(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isScalar && removeFunc(j));
}
// #endregion values

// #region base
Json removeScalars(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isScalar);
}
// #endregion base
// #endregion Json


