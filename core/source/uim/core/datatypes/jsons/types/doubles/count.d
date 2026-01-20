/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.count;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region Json with indices and delegate
size_t countDoubles(Json json, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  return json.isArray ? json.toArray.countDoubles(indices, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with indices and delegate");

  auto j1 = 1.1.toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = 2.1.toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];

  size_t count = json.countDoubles([0, 1, 2, 3, 4],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 double value in the provided indices matching the delegate");
  assert(json.countDoubles([0, 1, 2, 3, 4],
      (size_t index) => index < 3) == 2, "Expected 2 double values in the provided indices matching the delegate");
  assert(json.countDoubles([0, 1, 2, 3, 4],
      (size_t index) => index >= 0) == 2, "Expected 2 double values in the provided indices matching the delegate");
}
// #endregion Json with indices and delegate

// #region Json with indices
size_t countDoubles(Json json, size_t[] indices) {
  return json.isArray ? json.toArray.countDoubles(indices) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with indices");

  auto j1 = 1.0.toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = 2.1.toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];

  assert(json.countDoubles([0, 1, 2, 3, 4]) == 2, "Expected 2 double values in the provided indices");
  assert(json.countDoubles([0, 1]) == 1, "Expected 1 double value in the provided indices");
  assert(json.countDoubles([3, 4]) == 0, "Expected 0 double values in the provided indices");
}
// #endregion Json with indices

// #region Json with delegate
size_t countDoubles(Json json, bool delegate(size_t) @safe countFunc) {
  return json.isArray ? json.toArray.countDoubles(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with delegate");

  auto j1 = 1.0.toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = 2.1.toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];

  size_t count = json.countDoubles((size_t index) => index == 2);
  assert(count == 1, "Expected 1 double value matching the delegate");
  assert(json.countDoubles((size_t index) => index < 3) == 2, "Expected 2 double values matching the delegate");
  assert(json.countDoubles((size_t index) => index >= 0) == 2, "Expected 2 double values matching the delegate");
}
// #endregion Json with delegate
// #endregion indices

// #region paths
// #region Json with paths and delegate
size_t countDoubles(Json json, string[][] paths, bool delegate(string[]) @safe countFunc) {
  return json.isObject ? json.toMap.countDoubles(paths, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with paths and delegate");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles([
      ["first"], ["second"], ["third"], ["fourth"]
    ],
    (string[] path) => path.length == 1 && path[0] == "first");
  assert(count == 1, "Expected 1 double value in the provided paths matching the delegate");
  assert(json.countDoubles([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length == 1) == 2, "Expected 2 double values in the provided paths matching the delegate");
  assert(json.countDoubles([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length >= 1) == 2, "Expected 2 double values in the provided paths matching the delegate");
}
// #endregion Json with paths and delegate

// #region Json with paths
size_t countDoubles(Json json, string[][] paths) {
  return json.isObject ? json.toMap.countDoubles(paths) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with paths");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles([
      ["first"], ["second"], ["third"], ["fourth"]
    ]);
  assert(count == 2, "Expected 2 double values in the provided paths");
}
// #endregion Json with paths
// #endregion paths

// #region keys
// #region Json with keys and delegate
size_t countDoubles(Json json, string[] keys, bool delegate(string) @safe countFunc) {
  return json.isObject ? keys.filter!(key => json.isDouble(key) && countFunc(key)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with keys and delegate");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 double value in the provided keys matching the delegate");
}
// #endregion Json with keys and delegate

// #region Json with keys
size_t countDoubles(Json json, string[] keys) {
  return json.isObject ? keys.filter!(key => json.isDouble(key)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with keys");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles(["first", "second", "third", "fourth"]);
  assert(count == 2, "Expected 2 double values in the provided keys");
}
// #endregion Json with keys

// #region Json with delegate(keys)
size_t countDoubles(Json json, bool delegate(string) @safe countFunc) {
  return json.isObject ? json.byKeyValue.filter!(kv => countFunc(kv.key)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json with delegate");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 double value in the Json matching the delegate");
}
// #endregion Json with delegate(keys)
// #endregion keys

// #region values
size_t countDoubles(Json json, Json[] values, bool delegate(Json) @safe countFunc) {
  if (json.isArray) {
    return json.toArray.countDoubles(values, countFunc);
  }
  if (json.isObject) {
    return json.toMap.countDoubles(values, countFunc);
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with values and delegate");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles(
    [1.0.toJson, 2.1.toJson, "string".toJson],
    (Json value) => value.isDouble);
  assert(count == 2, "Expected 2 double values in the Json with the provided values matching the delegate");
}

size_t countDoubles(Json json, bool delegate(Json) @safe countFunc) {
  if (json.isArray) {
    return json.toArray.filter!(value => countFunc(value)).array.length;
  }
  if (json.isObject) {
    return json.byKeyValue.filter!(kv => countFunc(kv.value)).array.length;
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with delegate");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles((Json value) => value.isDouble);
  assert(count == 2, "Expected 2 double values in the Json matching the delegate");
}
// #endregion values

// #region map
size_t countDoubles(Json json, bool delegate(string, Json) @safe countFunc) {
  return json.isObject ? json.byKeyValue.filter!(kv => kv.value.isDouble && countFunc(kv.key, kv.value)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json map with delegate");

  Json json = [
    "first": 1.0.toJson,
    "second": ["a": 1].toJson,
    "third": 2.1.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countDoubles(
    (string key, Json value) => key.startsWith("t"));
  assert(count == 1, "Expected 1 double value in the Json map matching the delegate");
}
// #endregion map
// #endregion Json

// #region Json[]
// #region indices
// #region Json[] with indices and delegate
size_t countDoubles(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  return indices.filter!(index => jsons.isDouble(index) && countFunc(index)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] with indices and delegate");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  size_t count = countDoubles(jsons, [0, 1, 2, 3, 4],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 array in the provided indices matching the delegate");
  assert(countDoubles(jsons, [0, 1, 2, 3, 4],
      (size_t index) => index < 3) == 2, "Expected 2 double values in the provided indices matching the delegate");
  assert(countDoubles(jsons, [0, 1, 2, 3, 4],
      (size_t index) => index >= 0) == 2, "Expected 2 double values in the provided indices matching the delegate");
}
// #endregion Json[] with indices and delegate

// #region Json[] with indices
size_t countDoubles(Json[] jsons, size_t[] indices) {
  return indices.filter!(index => jsons.isDouble(index)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] with indices");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  assert(countDoubles(jsons, [0, 1, 2, 3, 4]) == 2, "Expected 2 double values in the provided indices");
  assert(countDoubles(jsons, [0, 1]) == 1, "Expected 1 array in the provided indices");
  assert(countDoubles(jsons, [3, 4]) == 0, "Expected 0 double values in the provided indices");
}
// #endregion Json[] with indices

// #region Json[] with delegate
size_t countDoubles(Json[] jsons, bool delegate(size_t) @safe countFunc) {
  auto count = 0;
  foreach (index, value; jsons) {
    if (value.isDouble && countFunc(index)) {
      count++;
    }
  }
  return count;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] with delegate");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countDoubles((size_t index) => index == 2);
  assert(count == 1, "Expected 1 array matching the delegate");
  assert(jsons.countDoubles((size_t index) => index < 3) == 2, "Expected 2 double values matching the delegate");
  assert(jsons.countDoubles((size_t index) => index >= 0) == 2, "Expected 2 double values matching the delegate");
}
// #endregion Json[] with delegate
// #endregion indices

// #region values
// #region Json[] with values and delegate
size_t countDoubles(Json[] jsons, Json[] values, bool delegate(Json) @safe countFunc) {
  return jsons.filter!(json => json.isDouble && values.hasValue(json) && countFunc(json))
    .array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] with values and delegate");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countDoubles(
    [1.0.toJson, 2.1.toJson, "string".toJson],
    (Json value) => value.isDouble);
  assert(count == 2, "Expected 2 double values in the Json[] with the provided values matching the delegate");
}
// #endregion Json[] with values and delegate

// #region Json[] with values
size_t countDoubles(Json[] jsons, Json[] values) {
  return jsons.filter!(json => json.isDouble && values.hasValue(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] with values");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countDoubles(
    [1.0.toJson, 2.1.toJson, "string".toJson]);
  assert(count == 2, "Expected 2 double values in the Json[] with the provided values");
}
// #endregion Json[] with values

// #region Json[] with delegate
size_t countDoubles(Json[] jsons, bool delegate(Json) @safe countFunc) {
  return jsons.filter!(json => json.isDouble && countFunc(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] with delegate");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countDoubles((Json value) => value.isDouble);
  assert(count == 2, "Expected 2 arrays in the Json[] matching the delegate");
}
// #endregion Json[] with delegate
// #endregion values

// #region Json[] without delegate
size_t countDoubles(Json[] jsons) {
  return jsons.filter!(json => json.isDouble).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[] without delegate");

  Json[] jsons = [
    1.0.toJson, ["a": 1].toJson, 2.1.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countDoubles();
  assert(count == 2, "Expected 2 arrays in the Json[]");
}
// #endregion Json[] without delegate
// #endregion Json[]

// #region Json[string]
// #region paths
// #region Json[string] with paths and delegate
size_t countDoubles(Json[string] map, string[][] paths, bool delegate(string[]) @safe countFunc) {
  return paths.filter!(path => map.getValue(path).isDouble && countFunc(path)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[string] with paths and delegate");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson, "sixth": ["a": ["b": 1.0.toJson].toJson].toJson
  ];
  size_t count = map.countDoubles([["first"], ["second"], ["third"], ["fourth"]],
    (string[] path) => path.length == 1 && path[0] == "first");
  assert(count == 1, "Expected 1 double value in the provided paths matching the delegate");
  assert(map.countDoubles([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length == 1) == 2, "Expected 2 arrays in the provided paths matching the delegate");
  assert(map.countDoubles([["first"], ["second"], ["third"], ["sixth", "a", "b"]],
      (string[] path) => path.length >= 1) == 3, "Expected 3 double values in the provided paths matching the delegate");
}
// #endregion Json[string] with paths and delegate

// #region Json[string] with paths
size_t countDoubles(Json[string] map, string[][] paths) {
  return paths.filter!(path => map.getValue(path).isDouble).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[string] with paths");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles([["first"], ["second"], ["third"], ["fourth"]]);
  assert(count == 2, "Expected 2 double values in the provided paths");
}
// #endregion Json[string] with paths
// #endregion paths

// #region keys
// #region Json[string] with keys and delegate
size_t countDoubles(Json[string] map, string[] keys, bool delegate(string) @safe countFunc) {
  return keys.filter!(key => map.isDouble(key) && countFunc(key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with keys and delegate");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 double value in the provided keys matching the delegate");
}
// #endregion Json[string] with keys and delegate

// #region Json[string] with keys
size_t countDoubles(Json[string] map, string[] keys) {
  return keys.filter!(key => map.isDouble(key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with keys");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles(["first", "second", "third", "fourth"]);
  assert(count == 2, "Expected 2 double values in the provided keys");
}
// #endregion Json[string] with keys

// #region Json[string] with delegate (keys)
size_t countDoubles(Json[string] map, bool delegate(string) @safe countFunc) {
  return map.byKeyValue.filter!(kv => kv.value.isDouble && countFunc(kv.key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with keys and delegate");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 double value matching the delegate");
}
// #endregion Json[string] with delegate keys
// #endregion keys

// #region values
// #region Json[string] with values and delegate
size_t countDoubles(Json[string] map, Json[] values, bool delegate(Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => values.hasValue(kv.value) && kv.value.isDouble && countFunc(kv.value))
    .array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with values and delegate");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles(
    [1.0.toJson, 2.1.toJson, "string".toJson],
    (Json value) => value.isDouble);
  assert(count == 2, "Expected 2 double values in the provided values matching the delegate");
}
// #endregion Json[string] with values and delegate

// #region Json[string] with values
size_t countDoubles(Json[string] map, Json[] values) {
  return map.byKeyValue.filter!(kv => values.hasValue(kv.value) && kv.value.isDouble).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with values");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles(
    [1.0.toJson, 2.1.toJson, "string".toJson]);
  assert(count == 2, "Expected 2 double values in the provided values");
}
// #endregion Json[string] with values

// #region Json[string] with delegate (value)
size_t countDoubles(Json[string] map, bool delegate(Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => kv.value.isDouble && countFunc(kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles with values and delegate");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles((Json value) => value.isDouble);
  assert(count == 2, "Expected 2 double values in the provided values matching the delegate");
}
// #endregion Json[string] with delegate (value)
// #endregion values

// #region map
// #region key-value delegate
size_t countDoubles(Json[string] map, bool delegate(string, Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => kv.value.isDouble && countFunc(kv.key, kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countDoubles for Json[string] with key-value delegate");

  Json[string] map = [
    "first": 1.0.toJson, "second": ["a": 1].toJson, "third": 2.1.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countDoubles((string key, Json value) => key.startsWith("t") && value.isDouble);
  assert(count == 1, "Expected 1 double value in the provided paths matching the delegate");
}
// #endregion map
// #endregion key-value delegate
// #endregion Json[string]
