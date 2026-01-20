/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.integers.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
Json getInteger(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  return jsons.getValue(index).isInteger ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json[] with index");

  Json[] jsons = [123.toJson, 1.23.toJson, 456.toJson];
  assert(jsons.getInteger(0) == 123.toJson);
  assert(jsons.getInteger(1, Json("default")) == Json("default"));
  assert(jsons.getInteger(2) == 456.toJson);
}
// #endregion Json[]

// #region Json[string]
Json getInteger(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  return map.getValue(path).isInteger ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json[string] with path");

  Json[string] map = [
    "first": 123.toJson, "second": 1.23.toJson, "third": 456.toJson
  ];
  assert(map.getInteger("first") == 123.toJson);
  assert(map.getInteger("second", Json("default")) == Json("default"));
  assert(map.getInteger("third") == 456.toJson);
}

Json getInteger(Json[string] map, string key, Json defaultValue = Json(null)) {
  return map.getValue(key).isInteger ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json[string] with key");

  Json[string] map = [
    "first": 123.toJson, "second": 1.23.toJson, "third": 456.toJson
  ];
  assert(map.getInteger("first") == 123.toJson);
  assert(map.getInteger("second", Json("default")) == Json("default"));
  assert(map.getInteger("third") == 456.toJson);
}
// #endregion Json[string]

// #region Json
Json getInteger(Json json, size_t index, Json defaultValue = Json(null)) {
  return json.isInteger(index) ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json with index");

  Json json = [123.toJson, 1.23.toJson, 456.toJson].toJson;
  assert(json.getInteger(0) == 123.toJson);
  assert(json.getInteger(1, Json("default")) == Json("default"));
  assert(json.getInteger(2) == 456.toJson);
}

Json getInteger(Json json, string[] path, Json defaultValue = Json(null)) {
  return json.isInteger(path) ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json with path");

  Json json = parseJsonString(`{"first": 123, "second": 1.23, "third": 456}`);
  assert(json.getInteger("first") == 123.toJson);
  assert(json.getInteger("second", Json("default")) == Json("default"));
  assert(json.getInteger("third") == 456.toJson);
}

Json getInteger(Json json, string key, Json defaultValue = Json(null)) {
  return json.isInteger(key) ? json.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getInteger for Json with key");

  Json json = parseJsonString(`{"first": 123, "second": 1.23, "third": 456}`);
  assert(json.getInteger("first") == 123.toJson);
  assert(json.getInteger("second", Json("default")) == Json("default"));
  assert(json.getInteger("third") == 456.toJson);
}
// #endregion Json
