/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.integers.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterIntegers(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] with indices and filterFunc");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterIntegers([0, 2, 3],
    (size_t index) @safe => jsons.isInteger(index));
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterIntegers(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] with indices");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterIntegers([0, 1, 2]);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterIntegers(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(filterFunc).filterIntegers;
}
///
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] with filterFunc");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterIntegers(
    (size_t index) @safe => jsons.isInteger(index));
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterIntegers(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] with values and filterFunc");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterIntegers(
    [1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json == 1.toJson);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.toJson);
}
// #endregion filter with values and filterFunc

// #region with filterFunc
Json[] filterIntegers(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return filterValues(jsons, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] with filterFunc");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterIntegers((Json j) @safe => j.isInteger);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion with filterFunc

// #region by values
Json[] filterIntegers(Json[] jsons, Json[] values) {
  return jsons.filterValues(values).filterIntegers;
} /// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] by values");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterIntegers(
    [1.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.toJson);
}
// #endregion by values

// #region by datatype
Json[] filterIntegers(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isInteger).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[] by datatype");

  Json[] jsons = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterIntegers();
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion by datatype
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region with paths and filterFunc
Json[string] filterIntegers(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with paths and filterFunc");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers([["a"], ["c"]],
    (string[] path) @safe => path.length == 1 && path[0] == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterIntegers(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with paths");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers([["a"], ["c"]]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterIntegers(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with keys and filterFunc");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers(
    ["a", "c"],
    (string key) @safe => key == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterIntegers(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with keys");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers(
    ["a", "c"]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterIntegers(Json[string] map, bool delegate(string) @safe filterFunc) {
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
  mixin(ShowTest!"Testing filterIntegers for Json[string] with filterFunc");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers((string key) @safe => key == "b");
  assert(filtered.length == 1);
  assert(filtered["b"] == ["x", "y"].toJson);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterIntegers(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with values and filterFunc");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers(
    [1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isInteger);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterIntegers(Json[string] map, Json[] values) {
  return map.filterValues(values).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with values");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers(
    [1.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterIntegers(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] with filterFunc");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers((Json j) @safe => j.isInteger);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterIntegers(Json[string] map) {
  return map.filterValues((Json json) => json.isInteger);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json[string] all arrays");

  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterIntegers();
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.toJson);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterIntegers(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers with indices and filterFunc");

  Json json = [Json(1.1), Json(2.1), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterIntegers([0, 2, 4],
    (size_t index) @safe => json.isInteger(index));
  assert(filtered.length == 2);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterIntegers(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers with indices");

  Json json = [Json(1.1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterIntegers([0, 2, 4]);
  assert(filtered.length == 2);
}
// #endregion with indices

// #region with filterFunc
Json filterIntegers(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers with filterFunc");

  Json json1 = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;
  auto filtered1 = json1.filterIntegers(
    (size_t index) @safe => json1.isInteger(index));
  assert(filtered1.length == 5);

  Json json2 = [Json(1.1), Json(2.2), Json(3), Json(4), Json(5)].toJson;
  auto filtered2 = json2.filterIntegers(
    (size_t index) @safe => json2.isInteger(index));
  assert(filtered2.length == 3);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterIntegers(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers with values and filterFunc");

  Json json = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ].toJson;
  auto filtered = json.filterIntegers(
    [1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isInteger);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.toJson);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterIntegers(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterIntegers;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers with filterFunc");

  Json json = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ].toJson;
  auto filtered = json.filterIntegers((Json j) @safe => j.isInteger);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion with filterFunc

// #region simple values
Json filterIntegers(Json json) {
  return json.filterValues((Json json) => json.isInteger);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterIntegers for Json by datatype");

  Json json = [
    1.toJson, "not an array".toJson, 2.toJson, 4.2.toJson
  ].toJson;
  auto filtered = json.filterIntegers();
  assert(filtered.length == 2);
  assert(filtered[0] == 1.toJson);
  assert(filtered[1] == 2.toJson);
}
// #endregion simple values
// #endregion values
// #endregion Json

