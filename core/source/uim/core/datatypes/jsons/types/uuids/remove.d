/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.uuids.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeUUIDs(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isUUID && removeFunc(index));
}

Json[] removeUUIDs(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isUUID);
}

Json[] removeUUIDs(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isUUID && removeFunc(index));
}
// #endregion indices

// #region values
Json[] removeUUIDs(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isUUID && removeFunc(json));
}

Json[] removeUUIDs(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isUUID);
}

Json[] removeUUIDs(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isUUID && removeFunc(json));
}
// #endregion values

// #region base
Json[] removeUUIDs(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isUUID);
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeUUIDs(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isUUID && removeFunc(key));
}

Json[string] removeUUIDs(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isUUID);
}

Json[string] removeUUIDs(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isUUID && removeFunc(key));
}
// #endregion keys

// #region values
Json[string] removeUUIDs(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isUUID && removeFunc(json));
}

Json[string] removeUUIDs(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isUUID);
}

Json[string] removeUUIDs(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isUUID && removeFunc(json));
}
// #endregion values

// #region base
Json[string] removeUUIDs(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isUUID);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeUUIDs(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isUUID && removeFunc(index));
}

Json removeUUIDs(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isUUID);
}

Json removeUUIDs(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isUUID && removeFunc(index));
}
// #endregion indices

// #region keys
Json removeUUIDs(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isUUID && removeFunc(key));
}

Json removeUUIDs(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isUUID);
}

Json removeUUIDs(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isUUID && removeFunc(key));
}
// #endregion keys

// #region values
Json removeUUIDs(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isUUID && removeFunc(j));
}

Json removeUUIDs(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isUUID);
}

Json removeUUIDs(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isUUID && removeFunc(j));
}
// #endregion values

// #region base
Json removeUUIDs(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isUUID);
}
// #endregion base
// #endregion Json


