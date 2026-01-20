/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.undefineds.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeUndefineds(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isUndefined && removeFunc(index));
}

Json[] removeUndefineds(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isUndefined);
}

Json[] removeUndefineds(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isUndefined && removeFunc(index));
}
// #endregion indices

// #region values
Json[] removeUndefineds(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isUndefined && removeFunc(json));
}

Json[] removeUndefineds(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isUndefined);
}

Json[] removeUndefineds(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isUndefined && removeFunc(json));
}
// #endregion values

// #region base
Json[] removeUndefineds(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isUndefined);
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeUndefineds(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isUndefined && removeFunc(key));
}

Json[string] removeUndefineds(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isUndefined);
}

Json[string] removeUndefineds(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isUndefined && removeFunc(key));
}
// #endregion keys

// #region values
Json[string] removeUndefineds(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isUndefined && removeFunc(json));
}

Json[string] removeUndefineds(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isUndefined);
}

Json[string] removeUndefineds(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isUndefined && removeFunc(json));
}
// #endregion values

// #region base
Json[string] removeUndefineds(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isUndefined);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeUndefineds(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isUndefined && removeFunc(index));
}

Json removeUndefineds(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isUndefined);
}

Json removeUndefineds(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isUndefined && removeFunc(index));
}
// #endregion indices

// #region keys
Json removeUndefineds(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isUndefined && removeFunc(key));
}

Json removeUndefineds(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isUndefined);
}

Json removeUndefineds(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isUndefined && removeFunc(key));
}
// #endregion keys

// #region values
Json removeUndefineds(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isUndefined && removeFunc(j));
}

Json removeUndefineds(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isUndefined);
}

Json removeUndefineds(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isUndefined && removeFunc(j));
}
// #endregion values

// #region base
Json removeUndefineds(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isUndefined);
}
// #endregion base
// #endregion Json


