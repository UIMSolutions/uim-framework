/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterDoubles(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] with indices and filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];

  auto filtered = jsons.filterDoubles([0, 2, 3],
    (size_t index) @safe => jsons.isDouble(index));
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterDoubles(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] with indices");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];

  auto filtered = jsons.filterDoubles([0, 1, 2]);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterDoubles(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(filterFunc).filterDoubles;
}
///
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] with filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];

  auto filtered = jsons.filterDoubles(
    (size_t index) @safe => jsons.isDouble(index));
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterDoubles(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] with values and filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterDoubles(
    [1.1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json == 1.1.toJson);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.1.toJson);
}
// #endregion filter with values and filterFunc

// #region with filterFunc
Json[] filterDoubles(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return filterValues(jsons, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] with filterFunc");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterDoubles((Json j) @safe => j.isDouble);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion with filterFunc

// #region by values
Json[] filterDoubles(Json[] jsons, Json[] values) {
  return jsons.filterValues(values).filterDoubles;
} /// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] by values");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterDoubles(
    [1.1.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.1.toJson);
}
// #endregion by values

// #region by datatype
Json[] filterDoubles(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isDouble).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[] by datatype");

  Json[] jsons = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ];
  auto filtered = jsons.filterDoubles();
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
Json[string] filterDoubles(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with paths and filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles([["a"], ["c"]],
    (string[] path) @safe => path.length == 1 && path[0] == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterDoubles(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with paths");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles([["a"], ["c"]]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterDoubles(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with keys and filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles(
    ["a", "c"],
    (string key) @safe => key == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterDoubles(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with keys");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles(
    ["a", "c"]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterDoubles(Json[string] map, bool delegate(string) @safe filterFunc) {
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
  mixin(ShowTest!"Testing filterDoubles for Json[string] with filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles((string key) @safe => key == "b");
  assert(filtered.length == 1);
  assert(filtered["b"] == ["x", "y"].toJson);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterDoubles(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with values and filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles(
    [1.1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isDouble);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterDoubles(Json[string] map, Json[] values) {
  return map.filterValues(values).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with values");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles(
    [1.1.toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterDoubles(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] with filterFunc");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles((Json j) @safe => j.isDouble);
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterDoubles(Json[string] map) {
  return map.filterValues((Json json) => json.isDouble);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json[string] all arrays");

  Json[string] map = [
    "a": 1.1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterDoubles();
  assert(filtered.length == 1);
  assert(filtered["a"] == 1.1.toJson);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterDoubles(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles with indices and filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterDoubles([0, 2, 4],
    (size_t index) @safe => json.isDouble(index));
  assert(filtered.length == 0);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterDoubles(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles with indices");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterDoubles([0, 2, 4]);
  assert(filtered.length == 0);
}
// #endregion with indices

// #region with filterFunc
Json filterDoubles(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles with filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterDoubles(
    (size_t index) @safe => json.isDouble(index));
  assert(filtered == Json(null) || filtered.length == 0);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterDoubles(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles with values and filterFunc");

  Json json = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterDoubles(
    [1.1.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isDouble);
  assert(filtered.length == 1);
  assert(filtered[0] == 1.1.toJson);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterDoubles(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterDoubles;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles with filterFunc");

  Json json = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterDoubles((Json j) @safe => j.isDouble);
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion with filterFunc

// #region simple values
Json filterDoubles(Json json) {
  return json.filterValues((Json json) => json.isDouble);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterDoubles for Json by datatype");

  Json json = [
    1.1.toJson, "not an array".toJson, 2.2.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterDoubles();
  assert(filtered.length == 2);
  assert(filtered[0] == 1.1.toJson);
  assert(filtered[1] == 2.2.toJson);
}
// #endregion simple values
// #endregion values
// #endregion Json

