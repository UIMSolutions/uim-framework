/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.uuids.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterUUIDs(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] with indices and filterFunc");

  Json[] jsons = [
    1.toJson, "not an array".toJson, randomUUID().toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterUUIDs([0, 1, 2],
    (size_t index) @safe => jsons.isUUID(index));
  assert(filtered.length == 1);
  assert(filtered[0] == jsons[2]);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterUUIDs(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] with indices");

  Json[] jsons = [
    1.toJson, "not an array".toJson, randomUUID().toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterUUIDs([0, 1, 2]);
  assert(filtered.length == 1);
  assert(filtered[0] == jsons[2]);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterUUIDs(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(filterFunc).filterUUIDs;
}
///
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] with filterFunc");

  Json[] jsons = [
    1.toJson, "not an array".toJson, randomUUID().toJson, 4.2.toJson
  ];

  auto filtered = jsons.filterUUIDs(
    (size_t index) @safe => jsons.isUUID(index));
  assert(filtered.length == 1);
  assert(filtered[0] == jsons[2]);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterUUIDs(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] with values and filterFunc");

  auto id = randomUUID().toJson;
  Json[] jsons = [
    1.toJson, "not an array".toJson, id, 4.2.toJson
  ];

  Json[] values = [1.toJson, ["x", "y"].toJson, id];

  auto filtered = jsons.filterUUIDs(
    values,
    (Json json) @safe => json == id);
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion filter with values and filterFunc

// #region with filterFunc
Json[] filterUUIDs(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return filterValues(jsons, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] with filterFunc");

  auto id = randomUUID().toJson;
  Json[] jsons = [
    1.toJson, "not an array".toJson, id, 4.2.toJson
  ];
  auto filtered = jsons.filterUUIDs((Json j) @safe => j.isUUID);
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion with filterFunc

// #region by values
Json[] filterUUIDs(Json[] jsons, Json[] values) {
  return jsons.filterValues(values).filterUUIDs;
} /// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] by values");

  auto id = randomUUID().toJson;
  Json[] jsons = [
    1.toJson, "not an array".toJson, id, 4.2.toJson
  ];
  auto filtered = jsons.filterUUIDs(
    [1.toJson, ["x", "y"].toJson, id]);
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion by values

// #region by datatype
Json[] filterUUIDs(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isUUID).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[] by datatype");

  auto id = randomUUID().toJson;
  Json[] jsons = [
    1.toJson, "not an array".toJson, id, 4.2.toJson
  ];
  auto filtered = jsons.filterUUIDs();
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion by datatype
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region with paths and filterFunc
Json[string] filterUUIDs(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with paths and filterFunc");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs([["a"], ["c"], ["e"]],
    (string[] path) @safe => path.length == 1 && path[0] == "e");
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterUUIDs(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with paths");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs([["a"], ["c"], ["e"]]);
  assert(filtered.length == 1);
  assert(filtered["e"] == map["e"]);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterUUIDs(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with keys and filterFunc");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs(
    ["a", "c", "e"],
     (string key) @safe => key == "e");
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterUUIDs(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with keys");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs(
    ["a", "c", "e"]);
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterUUIDs(Json[string] map, bool delegate(string) @safe filterFunc) {
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
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with filterFunc");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs((string key) @safe => key == "e");
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterUUIDs(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with values and filterFunc");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];

  auto filtered = map.filterUUIDs(
    [1.toJson, ["x", "y"].toJson, id],
    (Json json) @safe => json.isUUID);
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterUUIDs(Json[string] map, Json[] values) {
  return map.filterValues(values).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with values");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs(
    [1.toJson, ["x", "y"].toJson, id]);
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterUUIDs(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] with filterFunc");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs((Json j) @safe => j.isUUID);
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterUUIDs(Json[string] map) {
  return map.filterValues((Json json) => json.isUUID);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json[string] all arrays");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "a": 1.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 4.2.toJson,
    "e": id
  ];
  auto filtered = map.filterUUIDs();
  assert(filtered.length == 1);
  assert(filtered["e"] == id);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterUUIDs(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs with indices and filterFunc");

  auto id = randomUUID().toJson;
  Json json = [Json(1.1), Json(2.1), Json(3), id, Json(5)].toJson;

  auto filtered = json.filterUUIDs([0, 2, 3, 4],
    (size_t index) @safe => json.isUUID(index));
  assert(filtered.length == 1);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterUUIDs(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs with indices");

  auto id = randomUUID().toJson;
  Json json = [Json(1.1), Json(2), Json(3), id, Json(5)].toJson;

  auto filtered = json.filterUUIDs([0, 2, 3, 4]);
  assert(filtered.length == 1);
}
// #endregion with indices

// #region with filterFunc
Json filterUUIDs(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs with filterFunc");

  auto id = randomUUID().toJson;
  Json json1 = [Json(1), Json(2), Json(3), id, Json(5)].toJson;
  auto filtered1 = json1.filterUUIDs(
    (size_t index) @safe => json1.isUUID(index));
  assert(filtered1.length == 1);

  auto id2 = randomUUID().toJson;
  Json json2 = [Json(1.1), Json(2.2), Json(3), id2, Json(5)].toJson;
  auto filtered2 = json2.filterUUIDs(
    (size_t index) @safe => json2.isUUID(index));
  assert(filtered2.length == 1);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterUUIDs(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs with values and filterFunc");


  auto id = randomUUID().toJson;
  Json json = [
    1.toJson, "not an array".toJson, 2.toJson, id, 4.2.toJson
  ].toJson;
  auto filtered = json.filterUUIDs(
    [1.toJson, ["x", "y"].toJson, id],
    (Json json) @safe => json.isUUID);
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterUUIDs(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterUUIDs;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs with filterFunc");

  auto id = randomUUID().toJson;
  Json json = [
    1.toJson, "not an array".toJson, 2.toJson, id, 4.2.toJson
  ].toJson;
  auto filtered = json.filterUUIDs((Json j) @safe => j.isUUID);
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion with filterFunc

// #region simple values
Json filterUUIDs(Json json) {
  return json.filterValues((Json json) => json.isUUID);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterUUIDs for Json by datatype");

  auto id = randomUUID().toJson;
  Json json = [
    1.toJson, "not an array".toJson, 2.toJson, id, 4.2.toJson
  ].toJson;
  auto filtered = json.filterUUIDs();
  assert(filtered.length == 1);
  assert(filtered[0] == id);
}
// #endregion simple values
// #endregion values
// #endregion Json
