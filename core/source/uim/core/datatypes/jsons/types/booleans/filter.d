/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterBooleans(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] with indices and filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];

  auto filtered = jsons.filterBooleans([0, 2, 3],
    (size_t index) @safe => jsons.isBoolean(index));
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterBooleans(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] with indices");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];

  auto filtered = jsons.filterBooleans([0, 1, 2]);
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterBooleans(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(filterFunc).filterBooleans;
}
///
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] with filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];

  auto filtered = jsons.filterBooleans(
    (size_t index) @safe => jsons.isBoolean(index));
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterBooleans(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] with values and filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterBooleans(
    [true.toJson, ["x", "y"].toJson],
    (Json json) @safe => json == Json(true));
  assert(filtered.length == 1);
  assert(filtered[0] == true.toJson);
}
// #endregion filter with values and filterFunc

// #region with filterFunc
Json[] filterBooleans(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return filterValues(jsons, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] with filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterBooleans((Json j) @safe => j.isBoolean);
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc

// #region by values
Json[] filterBooleans(Json[] jsons, Json[] values) {
  return jsons.filterValues(values).filterBooleans;
} /// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] by values");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterBooleans(
    [true.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered[0] == true.toJson);
}
// #endregion by values

// #region by datatype
Json[] filterBooleans(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isBoolean).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[] by datatype");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterBooleans();
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion by datatype
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region with paths and filterFunc
Json[string] filterBooleans(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with paths and filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans([["a"], ["c"]],
    (string[] path) @safe => path.length == 1 && path[0] == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterBooleans(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with paths");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans([["a"], ["c"]]);
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterBooleans(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with keys and filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans(
    ["a", "c"],
    (string key) @safe => key == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterBooleans(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with keys");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans(
    ["a", "c"]);
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterBooleans(Json[string] map, bool delegate(string) @safe filterFunc) {
  if (map.length == 0) {
    return null;
  }

  Json[string] result;
  foreach (key; map.keys) {
    if (filterFunc(key)) {
      result[key] = map[key];
    }
  }

  return result;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans((string key) @safe => key == "b");
  assert(filtered.length == 1);
  assert(filtered["b"] == ["x", "y"].toJson);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterBooleans(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with values and filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans(
    [true.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isBoolean);
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterBooleans(Json[string] map, Json[] values) {
  return map.filterValues(values).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with values");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans(
    [true.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterBooleans(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] with filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans((Json j) @safe => j.isBoolean);
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterBooleans(Json[string] map) {
  return map.filterValues((Json json) => json.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json[string] all arrays");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterBooleans();
  assert(filtered.length == 1);
  assert(filtered["a"] == true.toJson);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterBooleans(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans with indices and filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterBooleans([0, 2, 4],
    (size_t index) @safe => json.isBoolean(index));
  assert(filtered.length == 0);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterBooleans(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans with indices");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterBooleans([0, 2, 4]);
  assert(filtered.length == 0);
}
// #endregion with indices

// #region with filterFunc
Json filterBooleans(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans with filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterBooleans(
    (size_t index) @safe => json.isBoolean(index));
  assert(filtered.length == 0);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterBooleans(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans with values and filterFunc");

  Json json = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterBooleans(
    [true.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isBoolean);
  assert(filtered.length == 1);
  assert(filtered[0] == true.toJson);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterBooleans(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterBooleans;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans with filterFunc");

  Json json = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterBooleans((Json j) @safe => j.isBoolean);
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc

// #region simple values
Json filterBooleans(Json json) {
  return json.filterValues((Json json) => json.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterBooleans for Json by datatype");

  Json json = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterBooleans();
  assert(filtered.length == 2);
  assert(filtered[0] == true.toJson);
  assert(filtered[1] == false.toJson);
}
// #endregion simple values
// #endregion values
// #endregion Json

