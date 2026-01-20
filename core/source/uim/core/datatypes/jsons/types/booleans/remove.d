/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeBooleans(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isBoolean && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] by Indices and Delegate");

  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];

  // Remove booleans at specific indices
  size_t[] indicesToRemove = [0, 3];
  Json[] result1 = jsons.removeBooleans(indicesToRemove);
  assert(result1.length == 4);
  assert(result1 == [Json(123), Json("Hello"), Json(45.67), Json(true)]);

  // Remove booleans using a delegate
  Json[] result2 = jsons.removeBooleans((size_t index) => index % 2 == 0);
  assert(result2.length == 5);
  assert(result2 == [Json(123), Json("Hello"), Json(false), Json(45.67), Json(true)]);
}

Json[] removeBooleans(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] by Indices");

  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];

  // Remove booleans at specific indices
  size_t[] indicesToRemove = [0, 3];
  Json[] result = jsons.removeBooleans(indicesToRemove);
  assert(result.length == 4);
  assert(result == [Json(123), Json("Hello"), Json(45.67), Json(true)]);
}
Json[] removeBooleans(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isBoolean && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] by Delegate");

  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];  

  // Remove booleans using a delegate
  Json[] result = jsons.removeBooleans((size_t index) => index % 2 == 0);
  assert(result.length == 5);
  assert(result == [Json(123), Json("Hello"), Json(false), Json(45.67), Json(true)]);
}
// #endregion indices

// #region values
Json[] removeBooleans(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isBoolean && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] by Values and Delegate");

  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];

  Json[] valuesToRemove = [Json(true), Json(false)];
  Json[] result1 = jsons.removeBooleans(valuesToRemove, (Json json) => json == Json(true));
  assert(result1.length == 4);
  assert(result1 == [Json(123), Json("Hello"), Json(false), Json(45.67)]);

  // Remove booleans using a delegate
  Json[] result2 = jsons.removeBooleans((Json json) => true);
  assert(result2.length == 3);
  assert(result2 == [Json(123), Json("Hello"), Json(45.67)]);
}

Json[] removeBooleans(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] by Values");

  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];

  Json[] valuesToRemove = [Json(true), Json(false)];
  Json[] result = jsons.removeBooleans(valuesToRemove);
  assert(result.length == 3);
  assert(result == [Json(123), Json("Hello"), Json(45.67)]);
}

Json[] removeBooleans(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isBoolean && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] by Delegate");

  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];

  // Remove booleans using a delegate
  Json[] result = jsons.removeBooleans((Json json) => true);
  assert(result.length == 3);
  assert(result == [Json(123), Json("Hello"), Json(45.67)]);
} 
// #endregion values

// #region base
Json[] removeBooleans(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[] Base");
  
  Json[] jsons = [
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ];

  Json[] result = removeBooleans(jsons);
  assert(result.length == 3);
  assert(result == [Json(123), Json("Hello"), Json(45.67)]);
} 
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeBooleans(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isBoolean && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] by Keys and Delegate");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  string[] keysToRemove = ["a", "d"];
  Json[string] result1 = map.removeBooleans(keysToRemove, (string key) => true);
  assert(result1.length == 4);
  assert(result1 == [
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
    "f": Json(true)
  ]);
}

Json[string] removeBooleans(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] by Keys");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  string[] keysToRemove = ["a", "d"];
  Json[string] result = map.removeBooleans(keysToRemove);
  assert(result.length == 4);
  assert(result == [
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
    "f": Json(true)
  ]);
}

Json[string] removeBooleans(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isBoolean && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] by Delegate");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  // Remove booleans using a delegate
  Json[string] result = map.removeBooleans((string key) => key == "a" || key == "d");
  assert(result.length == 4);
  assert(result == [
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
    "f": Json(true) 
  ]);
}
// #endregion keys

// #region values
Json[string] removeBooleans(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isBoolean && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] by Values and Delegate");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  Json[] valuesToRemove = [Json(true), Json(false)];
  Json[string] result1 = map.removeBooleans(valuesToRemove, (Json json) => true);
  assert(result1.length == 3);
  assert(result1 == [
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67)
  ]);
}

Json[string] removeBooleans(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isBoolean);
}/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] by Values");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  Json[] valuesToRemove = [Json(true), Json(false)];
  Json[string] result = map.removeBooleans(valuesToRemove);
  assert(result.length == 3);
  assert(result == [
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
  ]);
}

Json[string] removeBooleans(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isBoolean && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] by Delegate");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  // Remove booleans using a delegate
  Json[string] result = map.removeBooleans((Json json) => true);
  assert(result.length == 3);
  assert(result == [
    "b": Json(123),
    "c": Json("Hello"), 
    "e": Json(45.67),
  ]);
}
// #endregion values

// #region base
Json[string] removeBooleans(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json[string] Base");

  Json[string] map = [
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ];

  Json[string] result = map.removeBooleans;
  assert(result.length == 3);
  assert(result == [
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
  ]);
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeBooleans(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isBoolean && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Indices and Delegate");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  // Remove booleans at specific indices
  size_t[] indicesToRemove = [0, 3];
  Json result1 = removeBooleans(json, indicesToRemove, (size_t index) => true);
  assert(result1.length == 4);
  assert(result1 == Json([
    Json(123),
    Json("Hello"),
    Json(45.67),
    Json(true)
  ]));
}

Json removeBooleans(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Indices");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  // Remove booleans at specific indices
  size_t[] indicesToRemove = [0, 3];
  Json result = removeBooleans(json, indicesToRemove);
  assert(result.length == 4);
  assert(result == Json([
    Json(123),
    Json("Hello"),
    Json(45.67),
    Json(true)
  ]));
}

Json removeBooleans(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isBoolean && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Delegate");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  // Remove booleans using a delegate
  Json result = removeBooleans(json, (size_t index) => index % 2 == 0);
  assert(result.length == 5);
  assert(result == Json([
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]));
}
// #endregion indices

// #region keys
Json removeBooleans(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isBoolean && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Keys and Delegate");

  Json json = Json([
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ]);

  string[] keysToRemove = ["a", "d"];
  Json result1 = removeBooleans(json, keysToRemove, (string key) => true);
  assert(result1.length == 4);
  assert(result1 == Json([
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
    "f": Json(true)
  ]));
}

Json removeBooleans(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isBoolean);
}/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Keys");

  Json json = Json([
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ]);

  string[] keysToRemove = ["a", "d"];
  Json result = removeBooleans(json, keysToRemove);
  assert(result.length == 4);
  assert(result == Json([
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
    "f": Json(true)
  ]));
}

Json removeBooleans(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isBoolean && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Delegate");

  Json json = Json([
    "a": Json(true),
    "b": Json(123),
    "c": Json("Hello"),
    "d": Json(false),
    "e": Json(45.67),
    "f": Json(true)
  ]);

  // Remove booleans using a delegate
  Json result = removeBooleans(json, (string key) => key == "a" || key == "d");
  assert(result.length == 4);
  assert(result == Json([
    "b": Json(123),
    "c": Json("Hello"),
    "e": Json(45.67),
    "f": Json(true) 
  ]));
}
// #endregion keys

// #region values
Json removeBooleans(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isBoolean && removeFunc(j));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Values and Delegate");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  Json[] valuesToRemove = [Json(true), Json(false)];
  Json result1 = removeBooleans(json, valuesToRemove, (Json j) => true);
  assert(result1.length == 3);
  assert(result1 == Json([
    Json(123),
    Json("Hello"),
    Json(45.67)
  ]));
}

Json removeBooleans(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Values");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  Json[] valuesToRemove = [Json(true), Json(false)];
  Json result = removeBooleans(json, valuesToRemove);
  assert(result.length == 3);
  assert(result == Json([
    Json(123),
    Json("Hello"),
    Json(45.67)
  ]));
}

Json removeBooleans(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isBoolean && removeFunc(j));
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json by Delegate");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  // Remove booleans using a delegate
  Json result = removeBooleans(json, (Json j) => true);
  assert(result.length == 3);
  assert(result == Json([
    Json(123),
    Json("Hello"),
    Json(45.67)
  ]));
}
// #endregion values

// #region base
Json removeBooleans(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isBoolean);
}
/// 
unittest {
  mixin(ShowTest!"Removing Booleans from Json Base");

  Json json = Json([
    Json(true),
    Json(123),
    Json("Hello"),
    Json(false),
    Json(45.67),
    Json(true)
  ]);

  Json result = removeBooleans(json);
  assert(result.length == 3);
  assert(result == Json([
    Json(123),
    Json("Hello"),
    Json(45.67)
  ]));
}
// #endregion base
// #endregion Json


