/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterFloats(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] with indices and filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];

  auto filtered = jsons.filterFloats([0, 2, 3],
    (size_t index) @safe => jsons.isFloat(index));
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterFloats(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] with indices");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];

  auto filtered = jsons.filterFloats([0, 1, 2]);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterFloats(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(filterFunc).filterFloats;
}
///
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] with filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];

  auto filtered = jsons.filterFloats(
    (size_t index) @safe => jsons.isFloat(index));
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterFloats(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] with values and filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterFloats(
    [1.1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json == 1.1.toJson);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.1.toJson);
}
// #endregion filter with values and filterFunc

// #region with filterFunc
Json[] filterFloats(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return filterValues(jsons, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] with filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterFloats((Json j) @safe => j.isFloat);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion with filterFunc

// #region by values
Json[] filterFloats(Json[] jsons, Json[] values) {
  return jsons.filterValues(values).filterFloats;
} /// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] by values");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterFloats(
    [1.1.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.1.toJson);
}
// #endregion by values

// #region by datatype
Json[] filterFloats(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isFloat).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[] by datatype");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterFloats();
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion by datatype
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region with paths and filterFunc
Json[string] filterFloats(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with paths and filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats([["a"], ["c"]],
    (string[] path) @safe => path.length == 1 && path[0] == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterFloats(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with paths");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats([["a"], ["c"]]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterFloats(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with keys and filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats(
    ["a", "c"],
    (string key) @safe => key == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterFloats(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with keys");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats(
    ["a", "c"]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterFloats(Json[string] map, bool delegate(string) @safe filterFunc) {
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
  mixin(ShowTest!"Testing filterFloats for Json[string] with filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats((string key) @safe => key == "b");
  assert(filtered.length == 1);
  assert(filtered["b"] == ["x", "y"].toJson);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterFloats(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with values and filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats(
    [1.1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isFloat);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterFloats(Json[string] map, Json[] values) {
  return map.filterValues(values).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with values");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats(
    [1.1.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterFloats(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] with filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats((Json j) @safe => j.isFloat);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterFloats(Json[string] map) {
  return map.filterValues((Json json) => json.isFloat);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json[string] all arrays");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterFloats();
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterFloats(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats with indices and filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterFloats([0, 2, 4],
    (size_t index) @safe => json.isFloat(index));
  assert(filtered.length == 0);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterFloats(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats with indices");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterFloats([0, 2, 4]);
  assert(filtered.length == 0);
}
// #endregion with indices

// #region with filterFunc
Json filterFloats(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats with filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterFloats(
    (size_t index) @safe => json.isFloat(index));
  assert(filtered == Json(null) || filtered.length == 0);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterFloats(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats with values and filterFunc");

  Json json = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterFloats(
    [1.1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isFloat);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.1.toJson);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterFloats(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterFloats;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats with filterFunc");

  Json json = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterFloats((Json j) @safe => j.isFloat);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion with filterFunc

// #region simple values
Json filterFloats(Json json) {
  return json.filterValues((Json json) => json.isFloat);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterFloats for Json by datatype");

  Json json = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterFloats();
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion simple values
// #endregion values
// #endregion Json

