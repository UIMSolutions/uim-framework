/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.doubles.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
Json getDouble(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  return jsons.getValue(index).isDouble() ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json[] with index");

  Json[] jsons = [1.23.toJson, 123.toJson, 4.56.toJson];
  assert(jsons.getDouble(0) == 1.23.toJson);
  assert(jsons.getDouble(1, Json("default")) == Json("default"));
  assert(jsons.getDouble(2) == 4.56.toJson);
}
// #endregion Json[]

// #region Json[string]
Json getDouble(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  return map.getValue(path).isDouble ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json[string] with path");

  Json[string] map = [
    "first": 1.23.toJson, "second": 123.toJson, "third": 4.56.toJson
  ];
  assert(map.getDouble("first") == 1.23.toJson);
  assert(map.getDouble("second", Json("default")) == Json("default"));
  assert(map.getDouble("third") == 4.56.toJson);
}
Json getDouble(Json[string] map, string key, Json defaultValue = Json(null)) {
  return map.getValue(key).isDouble ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json[string] with key");

  Json[string] map = [
    "first": 1.23.toJson, "second": 123.toJson, "third": 4.56.toJson
  ];
  assert(map.getDouble("first") == 1.23.toJson);
  assert(map.getDouble("second", Json("default")) == Json("default"));
  assert(map.getDouble("third") == 4.56.toJson);
}
// #endregion Json[string]

// #region Json
Json getDouble(Json json, size_t index, Json defaultValue = Json(null)) {
  return json.isDouble(index) ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json with index");

  Json json = [1.23.toJson, 123.toJson, 4.56.toJson].toJson;
  assert(json.getDouble(0) == 1.23.toJson);
  assert(json.getDouble(1, Json("default")) == Json("default"));
  assert(json.getDouble(2) == 4.56.toJson);
}

Json getDouble(Json json, string[] path, Json defaultValue = Json(null)) {
  return json.isDouble(path) ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json with path");

  Json json = parseJsonString(`{"first": 1.23, "second": 123, "third": 4.56}`);
  assert(json.getDouble("first") == 1.23.toJson);
  assert(json.getDouble("second", Json("default")) == Json("default"));
  assert(json.getDouble("third") == 4.56.toJson);
}

Json getDouble(Json json, string key, Json defaultValue = Json(null)) {
  return json.isDouble(key) ? json.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getDouble for Json with key");

  Json json = parseJsonString(`{"first": 1.23, "second": 123, "third": 4.56}`);
  assert(json.getDouble("first") == 1.23.toJson);
  assert(json.getDouble("second", Json("default")) == Json("default"));
  assert(json.getDouble("third") == 4.56.toJson);
}

Json getDoubles(Json json) {
  if (json.isArray) {
    Json result = Json.emptyArray;
    json.toArray.filter!(value => value.isDouble).each!(value => result ~= value);
    return result;     
  }
  if (json.isObject) {
    Json result = Json.emptyObject;
    json.byKeyValue.filter!(kv => kv.value.isDouble).each!(kv => result[kv.key] = kv.value);
    return result;     
  }
  return Json(null);
}
// #endregion Json
