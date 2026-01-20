/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.strings.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterStrings(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] with indices and filterFunc");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterStrings([0, 2, 3],
    (size_t index) @safe => jsons.isString(index));
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterStrings(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] with indices");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterStrings([0, 1, 2]);
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterStrings(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(filterFunc).filterStrings;
}
///
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] with filterFunc");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterStrings(
    (size_t index) @safe => jsons.isString(index));
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterStrings(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] with values and filterFunc");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterStrings(
    ["abc".toJson, ["x", "y"].toJson],
    (Json json) @safe => json == "abc".toJson);
  assert(filtered.length == 1);
  assert(filtered[0] == "abc".toJson);
}
// #endregion filter with values and filterFunc

// #region with filterFunc
Json[] filterStrings(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return filterValues(jsons, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] with filterFunc");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterStrings((Json j) @safe => j.isString);
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion with filterFunc

// #region by values
Json[] filterStrings(Json[] jsons, Json[] values) {
  return jsons.filterValues(values).filterStrings;
} /// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] by values");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterStrings(
    ["abc".toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered[0] == "abc".toJson);
}
// #endregion by values

// #region by datatype
Json[] filterStrings(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isString).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[] by datatype");

  Json[] jsons = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ];
  auto filtered = jsons.filterStrings();
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion by datatype
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region with paths and filterFunc
Json[string] filterStrings(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with paths and filterFunc");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings([["a"], ["c"]],
    (string[] path) @safe => path.length == 1 && path[0] == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterStrings(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with paths");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings([["a"], ["c"]]);
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterStrings(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with keys and filterFunc");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings(
    ["a", "c"],
    (string key) @safe => key == "a");
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterStrings(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with keys");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings(
    ["a", "c"]);
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterStrings(Json[string] map, bool delegate(string) @safe filterFunc) {
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
  mixin(ShowTest!"Testing filterStrings for Json[string] with filterFunc");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings((string key) @safe => key == "b");
  assert(filtered.length == 1);
  assert(filtered["b"] == ["x", "y"].toJson);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterStrings(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with values and filterFunc");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings(
    ["abc".toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isString);
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterStrings(Json[string] map, Json[] values) {
  return map.filterValues(values).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with values");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings(
    ["abc".toJson, ["x", "y"].toJson]);
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterStrings(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] with filterFunc");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings((Json j) @safe => j.isString);
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterStrings(Json[string] map) {
  return map.filterValues((Json json) => json.isString);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json[string] all arrays");

  Json[string] map = [
    "a": "abc".toJson,
    "b": ["x", "y"].toJson,
    "c": 2.toJson,
    "d": 4.2.toJson
  ];
  auto filtered = map.filterStrings();
  assert(filtered.length == 1);
  assert(filtered["a"] == "abc".toJson);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterStrings(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings with indices and filterFunc");

  Json json = [Json(1.1), Json(2.1), Json("abc"), Json("def"), Json("xyz")].toJson;
  auto filtered = json.filterStrings([0, 2, 4],
    (size_t index) @safe => json.isString(index));
  assert(filtered.length == 2);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterStrings(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings with indices");

  Json json = [Json(1.1), Json(2.1), Json("abc"), Json("def"), Json("xyz")].toJson;
  auto filtered = json.filterStrings([0, 2, 4]);
  assert(filtered.length == 2);
}
// #endregion with indices

// #region with filterFunc
Json filterStrings(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings with filterFunc");

  Json json1 = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;
  auto filtered1 = json1.filterStrings(
    (size_t index) @safe => json1.isString(index));
  assert(filtered1.length == 0);

  Json json2 = [Json("abc"), Json("def"), Json("xyz"), Json(4), Json(5)].toJson;
  auto filtered2 = json2.filterStrings(
    (size_t index) @safe => json2.isString(index));
  assert(filtered2.length == 3);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterStrings(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings with values and filterFunc");

  Json json = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ].toJson;
  auto filtered = json.filterStrings(
    ["abc".toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isString);
  assert(filtered.length == 1);
  assert(filtered[0] == "abc".toJson);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterStrings(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterStrings;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings with filterFunc");

  Json json = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ].toJson;
  auto filtered = json.filterStrings((Json j) @safe => j.isString);
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion with filterFunc

// #region simple values
Json filterStrings(Json json) {
  return json.filterValues((Json json) => json.isString);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterStrings for Json by datatype");

  Json json = [
    "abc".toJson, 2.toJson, "def".toJson, 4.2.toJson
  ].toJson;
  auto filtered = json.filterStrings();
  assert(filtered.length == 2);
  assert(filtered[0] == "abc".toJson);
  assert(filtered[1] == "def".toJson);
}
// #endregion simple values
// #endregion values
// #endregion Json

