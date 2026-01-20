/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeDoubles(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isDouble && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeDoubles with indices and delegate");

  Json[] jsons = [Json(1), Json(2.5), Json("three"), Json(4.0), Json(true), Json(6.7)];
  size_t[] indicesToRemove = [1, 3, 5];
  Json[] result = removeDoubles(jsons, indicesToRemove, (size_t index)  => index == 3);
  assert(result.length == 5);
  assert(result[0] == Json(1));
  assert(result[1] == Json(2.5));
  assert(result[2] == Json("three"));
  assert(result[3] == Json(true));
  assert(result[4] == Json(6.7));
}

Json[] removeDoubles(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isDouble);
}

Json[] removeDoubles(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isDouble && removeFunc(index));
}
// #endregion indices

// #region values
Json[] removeDoubles(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isDouble && removeFunc(json));
}

Json[] removeDoubles(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isDouble);
}

Json[] removeDoubles(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isDouble && removeFunc(json));
}
// #endregion values

// #region base
Json[] removeDoubles(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isDouble);
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeDoubles(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isDouble && removeFunc(key));
}

Json[string] removeDoubles(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isDouble);
}

Json[string] removeDoubles(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isDouble && removeFunc(key));
}
// #endregion keys

// #region values
Json[string] removeDoubles(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isDouble && removeFunc(json));
}

Json[string] removeDoubles(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isDouble);
}

Json[string] removeDoubles(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isDouble && removeFunc(json));
}
// #endregion values

// #region base
Json[string] removeDoubles(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isDouble);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeDoubles(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isDouble && removeFunc(index));
}

Json removeDoubles(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isDouble);
}

Json removeDoubles(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isDouble && removeFunc(index));
}
// #endregion indices

// #region keys
Json removeDoubles(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isDouble && removeFunc(key));
}

Json removeDoubles(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isDouble);
}

Json removeDoubles(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isDouble && removeFunc(key));
}
// #endregion keys

// #region values
Json removeDoubles(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isDouble && removeFunc(j));
}

Json removeDoubles(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isDouble);
}

Json removeDoubles(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isDouble && removeFunc(j));
}
// #endregion values

// #region base
Json removeDoubles(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isDouble);
}
// #endregion base
// #endregion Json


