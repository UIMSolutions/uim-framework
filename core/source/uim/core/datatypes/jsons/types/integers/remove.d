/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.integers.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeIntegers(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isInteger && removeFunc(index));
}

Json[] removeIntegers(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isInteger);
}

Json[] removeIntegers(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isInteger && removeFunc(index));
}
// #endregion indices

// #region values
Json[] removeIntegers(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isInteger && removeFunc(json));
}

Json[] removeIntegers(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isInteger);
}

Json[] removeIntegers(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isInteger && removeFunc(json));
}
// #endregion values

// #region base
Json[] removeIntegers(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isInteger);
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeIntegers(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isInteger && removeFunc(key));
}

Json[string] removeIntegers(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isInteger);
}

Json[string] removeIntegers(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isInteger && removeFunc(key));
}
// #endregion keys

// #region values
Json[string] removeIntegers(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isInteger && removeFunc(json));
}

Json[string] removeIntegers(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isInteger);
}

Json[string] removeIntegers(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isInteger && removeFunc(json));
}
// #endregion values

// #region base
Json[string] removeIntegers(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isInteger);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeIntegers(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isInteger && removeFunc(index));
}

Json removeIntegers(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isInteger);
}

Json removeIntegers(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isInteger && removeFunc(index));
}
// #endregion indices

// #region keys
Json removeIntegers(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isInteger && removeFunc(key));
}

Json removeIntegers(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isInteger);
}

Json removeIntegers(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isInteger && removeFunc(key));
}
// #endregion keys

// #region values
Json removeIntegers(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isInteger && removeFunc(j));
}

Json removeIntegers(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isInteger);
}

Json removeIntegers(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isInteger && removeFunc(j));
}
// #endregion values

// #region base
Json removeIntegers(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isInteger);
}
// #endregion base
// #endregion Json


