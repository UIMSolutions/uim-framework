/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.nulls.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeNulls(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isNull && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with indices and delegate");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  size_t[] indicesToRemove = [0, 3, 5];
  Json[] result = removeNulls(jsons, indicesToRemove, (size_t index) => index == 3);
  assert(result.length == 5);
  assert(result[0] == Json(null));
  assert(result[1] == Json(2.5));
  assert(result[2] == Json("three"));
  assert(result[3] == Json(true));
  assert(result[4] == Json(null));
}

Json[] removeNulls(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with indices");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  size_t[] indicesToRemove = [0, 3, 5];
  Json[] result = removeNulls(jsons, indicesToRemove);
  assert(result.length == 3);
  assert(result[0] == Json(2.5));
  assert(result[1] == Json("three"));
  assert(result[2] == Json(true));
}

Json[] removeNulls(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isNull && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  Json[] result = removeNulls(jsons, (size_t index)  => index % 2 == 0);
  assert(result.length == 5);
  assert(result[0] == Json(2.5));
  assert(result[1] == Json("three"));
  assert(result[2] == Json(null));
  assert(result[3] == Json(true));
  assert(result[4] == Json(null));
}
// #endregion indices

// #region values
Json[] removeNulls(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeNulls((Json json) => json.isNull && values.hasValue(json) && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with values and delegate");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  Json[] valuesToRemove = [Json(null)];
  Json[] result = removeNulls(jsons, valuesToRemove, (Json json)  => true);
  assert(result.length == 3);
  assert(result[0] == Json(2.5));
  assert(result[1] == Json("three"));
  assert(result[2] == Json(true));
}

Json[] removeNulls(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeNulls((Json json) => json.isNull && values.hasValue(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with values");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  Json[] valuesToRemove = [Json(null)];
  Json[] result = removeNulls(jsons, valuesToRemove);
  assert(result.length == 3);
  assert(result[0] == Json(2.5));
  assert(result[1] == Json("three"));
  assert(result[2] == Json(true));
}

Json[] removeNulls(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isNull && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  Json[] result = removeNulls(jsons, (Json json)  => true);
  assert(result.length == 3);
  assert(result[0] == Json(2.5));
  assert(result[1] == Json("three"));
  assert(result[2] == Json(true));
}
// #endregion values

// #region base
Json[] removeNulls(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls base");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  Json[] result = removeNulls(jsons);
  assert(result.length == 3);
  assert(result[0] == Json(2.5));
  assert(result[1] == Json("three"));
  assert(result[2] == Json(true));
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeNulls(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map[key].isNull && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with keys and delegate");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  string[] keysToRemove = ["a", "c"];
  Json[string] result = removeNulls(map, keysToRemove, (string key)  => key == "c");
  assert(result.length == 3);
  assert(result["a"] == Json(null));
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json[string] removeNulls(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with keys");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  string[] keysToRemove = ["a", "c"];
  Json[string] result = removeNulls(map, keysToRemove);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json[string] removeNulls(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isNull && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  Json[string] result = removeNulls(map, (string key)  => true);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}
  // #endregion keys

// #region values
Json[string] removeNulls(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isNull && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with values and delegate");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  Json[] valuesToRemove = [Json(null)];
  Json[string] result = removeNulls(map, valuesToRemove, (Json json)  => true);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json[string] removeNulls(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with values");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  Json[] valuesToRemove = [Json(null)];
  Json[string] result = removeNulls(map, valuesToRemove);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json[string] removeNulls(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isNull && removeFunc(json));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  Json[string] result = removeNulls(map, (Json json)  => true);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}
// #endregion values

// #region base
Json[string] removeNulls(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls base");

  Json[string] map = ["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")];
  Json[string] result = removeNulls(map);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeNulls(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isNull && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with indices and delegate");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  size_t[] indicesToRemove = [0, 3, 5];
  Json result = removeNulls(Json(jsons), indicesToRemove, (size_t index)  => index == 3);
  Json[] resultArray = result.toArray;
  assert(resultArray.length == 5);
  assert(resultArray[0] == Json(null));
  assert(resultArray[1] == Json(2.5));
  assert(resultArray[2] == Json("three"));
  assert(resultArray[3] == Json(true));
  assert(resultArray[4] == Json(null));
}

Json removeNulls(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with indices");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  size_t[] indicesToRemove = [0, 3, 5];
  Json result = removeNulls(Json(jsons), indicesToRemove);
  Json[] resultArray = result.toArray;
  assert(resultArray.length == 3);
  assert(resultArray[0] == Json(2.5));
  assert(resultArray[1] == Json("three"));
  assert(resultArray[2] == Json(true));
}

Json removeNulls(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isNull && removeFunc(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json[] jsons = [Json(null), Json(2.5), Json("three"), Json(null), Json(true), Json(null)];
  Json result = removeNulls(Json(jsons), (size_t index)  => index % 2 == 0);
  Json[] resultArray = result.toArray;
  assert(resultArray.length == 5);
  assert(resultArray[0] == Json(2.5));
  assert(resultArray[1] == Json("three"));
  assert(resultArray[2] == Json(null));
  assert(resultArray[3] == Json(true)); 
  assert(resultArray[4] == Json(null));
}
// #endregion indices

// #region keys
Json removeNulls(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isNull && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with keys and delegate");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  string[] keysToRemove = ["a", "c"];
  Json result = removeNulls(json, keysToRemove, (string key)  => key == "c");
  assert(result.length == 3);
  assert(result["a"] == Json(null));
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json removeNulls(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with keys");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  string[] keysToRemove = ["a", "c"];
  Json result = removeNulls(json, keysToRemove);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json removeNulls(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isNull && removeFunc(key));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  Json result = removeNulls(json, (string key)  => true);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}
// #endregion keys

// #region values
Json removeNulls(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isNull && removeFunc(j));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with values and delegate");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  Json[] valuesToRemove = [Json(null)];
  Json result = removeNulls(json, valuesToRemove, (Json j)  => true);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json removeNulls(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with values");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  Json[] valuesToRemove = [Json(null)];
  Json result = removeNulls(json, valuesToRemove);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}

Json removeNulls(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isNull && removeFunc(j));
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls with delegate");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  Json result = removeNulls(json, (Json j)  => true);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}
// #endregion values

// #region base
Json removeNulls(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isNull);
}
/// 
unittest {
  mixin(ShowTest!"Testing removeNulls base");

  Json json = Json(["a": Json(null), "b": Json(2.5), "c": Json(null), "d": Json("four")]);
  Json result = removeNulls(json);
  assert(result.length == 2);
  assert(result["b"] == Json(2.5));
  assert(result["d"] == Json("four"));
}
// #endregion base
// #endregion Json


