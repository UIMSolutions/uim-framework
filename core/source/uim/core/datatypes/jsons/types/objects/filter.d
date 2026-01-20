/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.objects.filter;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region filter with indices and filterFunc
Json[] filterObjects(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices(indices, (size_t index) => jsons[index].isObject && filterFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] with indices and filterFunc");

  // Test filterObjects with indices and filterFunc - basic functionality
  Json[] jsons1 = [
    ["key": "value"].toJson,
    "string".toJson,
    ["a": 1, "b": 2].toJson,
    42.toJson,
    ["x": "y"].toJson
  ];

  auto filtered1 = jsons1.filterObjects(
    [0, 2, 4],
    (size_t index) => index < 3
  );

  assert(filtered1.length == 2);
  assert(filtered1[0] == ["key": "value"].toJson);
  assert(filtered1[1] == ["a": 1, "b": 2].toJson);

  // Test filterObjects with empty array
  Json[] jsons2;
  auto filtered2 = jsons2.filterObjects([0, 1], (size_t index) => true);
  assert(filtered2.length == 0);

  // Test filterObjects with no matching indices
  Json[] jsons3 = [Json("string"), Json(42), Json(true)];
  auto filtered3 = jsons3.filterObjects([0, 1, 2], (size_t index) => false);
  assert(filtered3.length == 0);

  // Test filterObjects with all objects matching
  Json[] jsons4 = [
    ["a": 1].toJson,
    ["b": 2].toJson,
    ["c": 3].toJson
  ];

  auto filtered4 = jsons4.filterObjects(
    [0, 1, 2],
    (size_t index) => true
  );

  assert(filtered4.length == 3);
}
// #endregion filter with indices and filterFunc

// #region filter with indices
Json[] filterObjects(Json[] jsons, size_t[] indices) {
  return jsons.filterIndices(indices, (size_t index) => jsons[index].isObject);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] with indices");

  // Test basic filtering of objects by indices
  Json[] jsons1 = [
    ["key": "value"].toJson,
    "string".toJson,
    ["a": 1, "b": 2].toJson,
    42.toJson,
    ["x": "y"].toJson
  ];

  auto filtered1 = jsons1.filterObjects([0, 2, 4]);
  assert(filtered1.length == 3);
  assert(filtered1[0] == ["key": "value"].toJson);
  assert(filtered1[1] == ["a": 1, "b": 2].toJson);
  assert(filtered1[2] == ["x": "y"].toJson);

  // Test filtering with non-object indices
  Json[] jsons2 = [
    ["key": "value"].toJson,
    "string".toJson,
    ["a": 1].toJson,
    42.toJson
  ];

  auto filtered2 = jsons2.filterObjects([1, 3]);
  assert(filtered2.length == 0);

  // Test filtering with empty indices array
  Json[] jsons3 = [
    ["key": "value"].toJson,
    ["a": 1].toJson
  ];

  Json[] values; 
  auto filtered3 = jsons3.filterObjects(values);
  assert(filtered3.length == 0);

  // Test filtering with empty jsons array
  Json[] jsons4;
  auto filtered4 = jsons4.filterObjects([0, 1]);
  assert(filtered4.length == 0);

  // Test filtering with mixed types
  Json[] jsons5 = [
    ["obj1": 1].toJson,
    [1, 2, 3].toJson,
    "text".toJson,
    ["obj2": "val"].toJson,
    true.toJson,
    ["obj3": false].toJson
  ];

  auto filtered5 = jsons5.filterObjects([0, 1, 2, 3, 4, 5]);
  assert(filtered5.length == 3);
  assert(filtered5[0] == ["obj1": 1].toJson);
  assert(filtered5[1] == ["obj2": "val"].toJson);
  assert(filtered5[2] == ["obj3": false].toJson);

  // Test filtering with out-of-bounds indices (should be handled by filterIndices)
  Json[] jsons6 = [
    ["key": "value"].toJson,
    42.toJson
  ];

  auto filtered6 = jsons6.filterObjects([0, 5, 10]);
  assert(filtered6.length == 1);
  assert(filtered6[0] == ["key": "value"].toJson);

  // Test filtering with all objects
  Json[] jsons7 = [
    ["a": 1].toJson,
    ["b": 2].toJson,
    ["c": 3].toJson
  ];

  auto filtered7 = jsons7.filterObjects([0, 1, 2]);
  assert(filtered7.length == 3);

  // Test filtering with duplicate indices
  Json[] jsons8 = [
    ["key": "value"].toJson,
    "string".toJson,
    ["a": 1].toJson
  ];

  auto filtered8 = jsons8.filterObjects([0, 0, 2, 2]);
  assert(filtered8.length >= 2);
}
// #endregion filter with indices

// #region with filterFunc
Json[] filterObjects(Json[] jsons, bool delegate(size_t) @safe filterFunc) {
  return jsons.filterIndices((size_t index) => jsons[index].isObject && filterFunc(index));
}
///
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] with filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];

  auto filtered = jsons.filterObjects(
    (size_t index) @safe => jsons[index].isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region filter with values and filterFunc
Json[] filterObjects(Json[] jsons, Json[] values, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues(values, (Json json) => json.isObject && filterFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] with values and filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterObjects(
    [true.toJson, ["x", "y"].toJson],
    (Json json) @safe => json == Json(true));
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter with values and filterFunc

// #region by values
Json[] filterObjects(Json[] jsons, Json[] values) {
  return jsons.filterValues(values, (Json json) => json.isObject);
} /// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] by values");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterObjects(
    [true.toJson, ["x", "y"].toJson]);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion by values

// #region with filterFunc
Json[] filterObjects(Json[] jsons, bool delegate(Json) @safe filterFunc) {
  return jsons.filterValues((Json json) => json.isObject && filterFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] with filterFunc");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterObjects((Json j) @safe => j.isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc
// #endregion by values

// #region by datatype
Json[] filterObjects(Json[] jsons) {
  if (jsons.length == 0) {
    return null;
  }

  return jsons.filter!(json => json.isObject).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[] by datatype");

  Json[] jsons = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ];
  auto filtered = jsons.filterObjects();
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion by datatype
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
// #region with paths and filterFunc
Json[string] filterObjects(Json[string] map, string[][] paths, bool delegate(string[]) @safe filterFunc) {
  return map.filterPaths(paths, (string[] path) @safe => map.getValue(path).isObject && filterFunc(path));
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with paths and filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects([["a"], ["c"]],
    (string[] path) @safe => path.length == 1 && path[0] == "a");
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with paths and filterFunc

// #region with paths
Json[string] filterObjects(Json[string] map, string[][] paths) {
  return map.filterPaths(paths).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with paths");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects([["a"], ["c"]]);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with paths
// #endregion paths

// #region keys
// #region filter with keys and filterFunc
Json[string] filterObjects(Json[string] map, string[] keys, bool delegate(string) @safe filterFunc) {
  return map.filterKeys(keys, filterFunc).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with keys and filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects(
    ["a", "c"],
    (string key) @safe => key == "a");
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter with keys and filterFunc

// #region filter with keys
Json[string] filterObjects(Json[string] map, string[] keys) {
  return map.filterKeys(keys).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with keys");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects(
    ["a", "c"]);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter with keys

// #region with filterFunc
Json[string] filterObjects(Json[string] map, bool delegate(string) @safe filterFunc) {
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
  mixin(ShowTest!"Testing filterObjects for Json[string] with filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects((string key) @safe => key == "b");
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc
// #endregion keys

// #region values
// #region filter with values and filterFunc
Json[string] filterObjects(Json[string] map, Json[] values, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(values, filterFunc).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with values and filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects(
    [true.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter with values and filterFunc

// #region filter with values
Json[string] filterObjects(Json[string] map, Json[] values) {
  return map.filterValues(values).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with values");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects(
    [true.toJson, ["x", "y"].toJson]);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter with values

// #region filter with filterFunc
Json[string] filterObjects(Json[string] map, bool delegate(Json) @safe filterFunc) {
  return map.filterValues(filterFunc).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] with filterFunc");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects((Json j) @safe => j.isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter with filterFunc

// #region filter all arrays
Json[string] filterObjects(Json[string] map) {
  return map.filterValues((Json json) => json.isObject);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json[string] all arrays");

  Json[string] map = [
    "a": true.toJson,
    "b": ["x", "y"].toJson,
    "c": "not an array".toJson,
    "d": 42.toJson
  ];
  auto filtered = map.filterObjects();
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion filter all arrays
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
// #region with indices and filterFunc
Json filterObjects(Json json, size_t[] indices, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(indices, filterFunc).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects with indices and filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterObjects([0, 2, 4],
    (size_t index) @safe => json[index].isObject);
  assert(filtered.length == 0);
}
// #endregion with indices and filterFunc

// #region with indices
Json filterObjects(Json json, size_t[] indices) {
  return json.filterIndices(indices).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects with indices");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterObjects([0, 2, 4]);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with indices

// #region with filterFunc
Json filterObjects(Json json, bool delegate(size_t) @safe filterFunc) {
  return json.filterIndices(filterFunc);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects with filterFunc");

  Json json = [Json(1), Json(2), Json(3), Json(4), Json(5)].toJson;

  auto filtered = json.filterObjects(
    (size_t index) @safe => json[index].isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc
// #endregion indices

// #region values
// #region with values and filterFunc
Json filterObjects(Json json, Json[] values, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(values, filterFunc).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects with values and filterFunc");

  Json json = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterObjects(
    [true.toJson, ["x", "y"].toJson],
    (Json json) @safe => json.isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with values and filterFunc

// #region with filterFunc
Json filterObjects(Json json, bool delegate(Json) @safe filterFunc) {
  return json.filterValues(filterFunc).filterObjects;
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects with filterFunc");

  Json json = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterObjects((Json j) @safe => j.isObject);
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion with filterFunc

// #region simple values
Json filterObjects(Json json) {
  return json.filterValues((Json json) => json.isObject);
}
/// 
unittest {
  mixin(ShowTest!"Testing filterObjects for Json by datatype");

  Json json = [
    true.toJson, "not an array".toJson, false.toJson, 42.toJson
  ].toJson;
  auto filtered = json.filterObjects();
  // TODO
  // assert(filtered.length == 2);
  // assert(filtered[0] == true.toJson);
  // assert(filtered[1] == false.toJson);
}
// #endregion simple values
// #endregion values
// #endregion Json
