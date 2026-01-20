/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.count;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region Json with indices and delegate
size_t countBooleans(Json json, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  return json.isArray ? json.toArray.countBooleans(indices, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with indices and delegate");

  auto j1 = true.toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = false.toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];
  size_t count = json.countBooleans([0, 1, 2, 3, 4],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 boolean value in the provided indices matching the delegate");
  assert(json.countBooleans([0, 1, 2, 3, 4],
      (size_t index) => index < 3) == 2, "Expected 2 boolean values in the provided indices matching the delegate");
  assert(json.countBooleans([0, 1, 2, 3, 4],
      (size_t index) => index >= 0) == 2, "Expected 2 boolean values in the provided indices matching the delegate");
}
// #endregion Json with indices and delegate

// #region Json with indices
size_t countBooleans(Json json, size_t[] indices) {
  return json.isArray ? json.toArray.countBooleans(indices) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with indices");

  auto j1 = true.toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = false.toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];

  assert(json.countBooleans([0, 1, 2, 3, 4]) == 2, "Expected 2 boolean values in the provided indices");
  assert(json.countBooleans([0, 1]) == 1, "Expected 1 boolean value in the provided indices");
  assert(json.countBooleans([3, 4]) == 0, "Expected 0 boolean values in the provided indices");
}
// #endregion Json with indices

// #region Json with delegate
size_t countBooleans(Json json, bool delegate(size_t) @safe countFunc) {
  return json.isArray ? json.toArray.countBooleans(countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with delegate");

  auto j1 = true.toJson;
  auto j2 = ["a": 1].toJson;
  auto j3 = false.toJson;
  auto j4 = "string".toJson;
  auto j5 = 42.toJson;

  Json json = [
    j1, j2, j3, j4, j5
  ];

  size_t count = json.countBooleans((size_t index) => index == 2);
  assert(count == 1, "Expected 1 boolean value matching the delegate");
  assert(json.countBooleans((size_t index) => index < 3) == 2, "Expected 2 boolean values matching the delegate");
  assert(json.countBooleans((size_t index) => index >= 0) == 2, "Expected 2 boolean values matching the delegate");
}
// #endregion Json with delegate
// #endregion indices

// #region paths
// #region Json with paths and delegate
size_t countBooleans(Json json, string[][] paths, bool delegate(string[]) @safe countFunc) {
  return json.isObject ? json.toMap.countBooleans(paths, countFunc) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with paths and delegate");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans([
      ["first"], ["second"], ["third"], ["fourth"]
    ],
    (string[] path) => path.length == 1 && path[0] == "first");
  assert(count == 1, "Expected 1 boolean value in the provided paths matching the delegate");
  assert(json.countBooleans([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length == 1) == 2, "Expected 2 boolean values in the provided paths matching the delegate");
  assert(json.countBooleans([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length >= 1) == 2, "Expected 2 boolean values in the provided paths matching the delegate");
}
// #endregion Json with paths and delegate

// #region Json with paths
size_t countBooleans(Json json, string[][] paths) {
  return json.isObject ? json.toMap.countBooleans(paths) : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with paths");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans([
      ["first"], ["second"], ["third"], ["fourth"]
    ]);
  assert(count == 2, "Expected 2 boolean values in the provided paths");
}
// #endregion Json with paths
// #endregion paths

// #region keys
// #region Json with keys and delegate
size_t countBooleans(Json json, string[] keys, bool delegate(string) @safe countFunc) {
  return json.isObject ? keys.filter!(key => json.isBoolean(key) && countFunc(key)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with keys and delegate");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 boolean value in the provided keys matching the delegate");
}
// #endregion Json with keys and delegate

// #region Json with keys
size_t countBooleans(Json json, string[] keys) {
  return json.isObject ? keys.filter!(key => json.isBoolean(key)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with keys");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans(["first", "second", "third", "fourth"]);
  assert(count == 2, "Expected 2 boolean values in the provided keys");
}
// #endregion Json with keys

// #region Json with delegate(keys)
size_t countBooleans(Json json, bool delegate(string) @safe countFunc) {
  return json.isObject ? json.byKeyValue.filter!(kv => countFunc(kv.key)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json with delegate");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 boolean value in the Json matching the delegate");
}
// #endregion Json with delegate(keys)
// #endregion keys

// #region values
size_t countBooleans(Json json, Json[] values, bool delegate(Json) @safe countFunc) {
  if (json.isArray) {
    return json.toArray.countBooleans(values, countFunc);
  }
  if (json.isObject) {
    return json.toMap.countBooleans(values, countFunc);
  }
  return 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with values and delegate");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans(
    [true.toJson, false.toJson, "string".toJson],
    (Json value) => value.isBoolean);
  assert(count == 2, "Expected 2 boolean values in the Json with the provided values matching the delegate");
}

size_t countBooleans(Json json, bool delegate(Json) @safe countFunc) {
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
  mixin(ShowTest!"Testing countBooleans with delegate");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans((Json value) => value.isBoolean);
  assert(count == 2, "Expected 2 boolean values in the Json matching the delegate");
}
// #endregion values

// #region map
size_t countBooleans(Json json, bool delegate(string, Json) @safe countFunc) {
  return json.isObject ? json.byKeyValue.filter!(kv => kv.value.isBoolean && countFunc(kv.key, kv.value)).array.length : 0;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json map with delegate");

  Json json = [
    "first": true.toJson,
    "second": ["a": 1].toJson,
    "third": false.toJson,
    "fourth": "string".toJson
  ].toJson;
  size_t count = json.countBooleans(
    (string key, Json value) => key.startsWith("t"));
  assert(count == 1, "Expected 1 boolean value in the Json map matching the delegate");
}
// #endregion map
// #endregion Json

// #region Json[]
// #region indices
// #region Json[] with indices and delegate
size_t countBooleans(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe countFunc) {
  return indices.filter!(index => jsons.isBoolean(index) && countFunc(index)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] with indices and delegate");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  size_t count = countBooleans(jsons, [0, 1, 2, 3, 4],
    (size_t index) => index == 2);
  assert(count == 1, "Expected 1 array in the provided indices matching the delegate");
  assert(countBooleans(jsons, [0, 1, 2, 3, 4],
      (size_t index) => index < 3) == 2, "Expected 2 boolean values in the provided indices matching the delegate");
  assert(countBooleans(jsons, [0, 1, 2, 3, 4],
      (size_t index) => index >= 0) == 2, "Expected 2 boolean values in the provided indices matching the delegate");
}
// #endregion Json[] with indices and delegate

// #region Json[] with indices
size_t countBooleans(Json[] jsons, size_t[] indices) {
  return indices.filter!(index => jsons.isBoolean(index)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] with indices");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  assert(countBooleans(jsons, [0, 1, 2, 3, 4]) == 2, "Expected 2 boolean values in the provided indices");
  assert(countBooleans(jsons, [0, 1]) == 1, "Expected 1 array in the provided indices");
  assert(countBooleans(jsons, [3, 4]) == 0, "Expected 0 boolean values in the provided indices");
}
// #endregion Json[] with indices

// #region Json[] with delegate
size_t countBooleans(Json[] jsons, bool delegate(size_t) @safe countFunc) {
  auto count = 0;
  foreach (index, value; jsons) {
    if (value.isBoolean && countFunc(index)) {
      count++;
    }
  }
  return count;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] with delegate");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countBooleans((size_t index) => index == 2);
  assert(count == 1, "Expected 1 array matching the delegate");
  assert(jsons.countBooleans((size_t index) => index < 3) == 2, "Expected 2 boolean values matching the delegate");
  assert(jsons.countBooleans((size_t index) => index >= 0) == 2, "Expected 2 boolean values matching the delegate");
}
// #endregion Json[] with delegate
// #endregion indices

// #region values
// #region Json[] with values and delegate
size_t countBooleans(Json[] jsons, Json[] values, bool delegate(Json) @safe countFunc) {
  return jsons.filter!(json => json.isBoolean && values.hasValue(json) && countFunc(json))
    .array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] with values and delegate");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countBooleans(
    [true.toJson, false.toJson, "string".toJson],
    (Json value) => value.isBoolean);
  assert(count == 2, "Expected 2 boolean values in the Json[] with the provided values matching the delegate");
}
// #endregion Json[] with values and delegate

// #region Json[] with values
size_t countBooleans(Json[] jsons, Json[] values) {
  return jsons.filter!(json => json.isBoolean && values.hasValue(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] with values");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countBooleans(
    [true.toJson, false.toJson, "string".toJson]);
  assert(count == 2, "Expected 2 boolean values in the Json[] with the provided values");
}
// #endregion Json[] with values

// #region Json[] with delegate
size_t countBooleans(Json[] jsons, bool delegate(Json) @safe countFunc) {
  return jsons.filter!(json => json.isBoolean && countFunc(json)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] with delegate");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countBooleans((Json value) => value.isBoolean);
  assert(count == 2, "Expected 2 arrays in the Json[] matching the delegate");
}
// #endregion Json[] with delegate
// #endregion values

// #region Json[] without delegate
size_t countBooleans(Json[] jsons) {
  return jsons.filter!(json => json.isBoolean).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[] without delegate");

  Json[] jsons = [
    true.toJson, ["a": 1].toJson, false.toJson, "string".toJson, 42.toJson
  ];

  size_t count = jsons.countBooleans();
  assert(count == 2, "Expected 2 arrays in the Json[]");
}
// #endregion Json[] without delegate
// #endregion Json[]

// #region Json[string]
// #region paths
// #region Json[string] with paths and delegate
size_t countBooleans(Json[string] map, string[][] paths, bool delegate(string[]) @safe countFunc) {
  return paths.filter!(path => map.isBoolean(path) && countFunc(path)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[string] with paths and delegate");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson, "sixth": ["a": ["b": true.toJson].toJson].toJson
  ];
  size_t count = map.countBooleans([["first"], ["second"], ["third"], ["fourth"]],
    (string[] path) => path.length == 1 && path[0] == "first");
  assert(count == 1, "Expected 1 boolean value in the provided paths matching the delegate");
  assert(map.countBooleans([["first"], ["second"], ["third"], ["fourth"]],
      (string[] path) => path.length == 1) == 2, "Expected 2 arrays in the provided paths matching the delegate");
  assert(map.countBooleans([["first"], ["second"], ["third"], ["sixth", "a", "b"]],
      (string[] path) => path.length >= 1) == 3, "Expected 3 boolean values in the provided paths matching the delegate");
}
// #endregion Json[string] with paths and delegate

// #region Json[string] with paths
size_t countBooleans(Json[string] map, string[][] paths) {
  return paths.filter!(path => map.isBoolean(path)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[string] with paths");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans([["first"], ["second"], ["third"], ["fourth"]]);
  assert(count == 2, "Expected 2 boolean values in the provided paths");
}
// #endregion Json[string] with paths
// #endregion paths

// #region keys
// #region Json[string] with keys and delegate
size_t countBooleans(Json[string] map, string[] keys, bool delegate(string) @safe countFunc) {
  return keys.filter!(key => map.isBoolean(key) && countFunc(key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with keys and delegate");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans(["first", "second", "third", "fourth"],
    (string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 boolean value in the provided keys matching the delegate");
}
// #endregion Json[string] with keys and delegate

// #region Json[string] with keys
size_t countBooleans(Json[string] map, string[] keys) {
  return keys.filter!(key => map.isBoolean(key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with keys");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans(["first", "second", "third", "fourth"]);
  assert(count == 2, "Expected 2 boolean values in the provided keys");
}
// #endregion Json[string] with keys

// #region Json[string] with delegate (keys)
size_t countBooleans(Json[string] map, bool delegate(string) @safe countFunc) {
  return map.byKeyValue.filter!(kv => kv.value.isBoolean && countFunc(kv.key)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with keys and delegate");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans((string key) => key.startsWith("t"));
  assert(count == 1, "Expected 1 boolean value matching the delegate");
}
// #endregion Json[string] with delegate keys
// #endregion keys

// #region values
// #region Json[string] with values and delegate
size_t countBooleans(Json[string] map, Json[] values, bool delegate(Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => values.hasValue(kv.value) && kv.value.isBoolean && countFunc(kv.value))
    .array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with values and delegate");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans(
    [true.toJson, false.toJson, "string".toJson],
    (Json value) => value.isBoolean);
  assert(count == 2, "Expected 2 boolean values in the provided values matching the delegate");
}
// #endregion Json[string] with values and delegate

// #region Json[string] with values
size_t countBooleans(Json[string] map, Json[] values) {
  return map.byKeyValue.filter!(kv => values.hasValue(kv.value) && kv.value.isBoolean).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with values");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans(
    [true.toJson, false.toJson, "string".toJson]);
  assert(count == 2, "Expected 2 boolean values in the provided values");
}
// #endregion Json[string] with values

// #region Json[string] with delegate (value)
size_t countBooleans(Json[string] map, bool delegate(Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => kv.value.isBoolean && countFunc(kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans with values and delegate");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans((Json value) => value.isBoolean);
  assert(count == 2, "Expected 2 boolean values in the provided values matching the delegate");
}
// #endregion Json[string] with delegate (value)
// #endregion values

// #region map
// #region key-value delegate
size_t countBooleans(Json[string] map, bool delegate(string, Json) @safe countFunc) {
  return map.byKeyValue.filter!(kv => kv.value.isBoolean && countFunc(kv.key, kv.value)).array.length;
}
/// 
unittest {
  mixin(ShowTest!"Testing countBooleans for Json[string] with key-value delegate");

  Json[string] map = [
    "first": true.toJson, "second": ["a": 1].toJson, "third": false.toJson,
    "fourth": "string".toJson
  ];
  size_t count = map.countBooleans((string key, Json value) => key.startsWith("t") && value.isBoolean);
  assert(count == 1, "Expected 1 boolean value in the provided paths matching the delegate");
}
// #endregion map
// #endregion key-value delegate
// #endregion Json[string]
