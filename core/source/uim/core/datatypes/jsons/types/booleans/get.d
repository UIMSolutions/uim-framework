/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
Json getBoolean(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  return jsons.getValue(index).isBoolean() ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json[] with index");

  Json[] jsons = [true.toJson, 123.toJson, false.toJson];
  assert(jsons.getBoolean(0) == true.toJson);
  assert(jsons.getBoolean(1, Json("default")) == Json("default"));
  assert(jsons.getBoolean(2) == false.toJson);
}
// #endregion Json[]

// #region Json[string]
Json getBoolean(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  return map.getValue(path).isBoolean ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json[string] with path");

  Json[string] map = [
    "first": true.toJson, "second": 123.toJson, "third": false.toJson
  ];
  assert(map.getBoolean("first") == true.toJson);
  assert(map.getBoolean("second", Json("default")) == Json("default"));
  assert(map.getBoolean("third") == false.toJson);
}

Json getBoolean(Json[string] map, string key, Json defaultValue = Json(null)) {
  return map.getValue(key).isBoolean ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json[string] with key");

  Json[string] map = [
    "first": true.toJson, "second": 123.toJson, "third": false.toJson
  ];
  assert(map.getBoolean("first") == true.toJson);
  assert(map.getBoolean("second", Json("default")) == Json("default"));
  assert(map.getBoolean("third") == false.toJson);
}
// #endregion Json[string]

// #region Json
Json getBoolean(Json json, size_t index, Json defaultValue = Json(null)) {
  return json.isBoolean(index) ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json with index");

  Json json = [true.toJson, 123.toJson, false.toJson].toJson;
  assert(json.getBoolean(0) == true.toJson);
  assert(json.getBoolean(1, Json("default")) == Json("default"));
  assert(json.getBoolean(2) == false.toJson);
}

Json getBoolean(Json json, string[] path, Json defaultValue = Json(null)) {
  return json.isBoolean(path) ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json with path");

  Json json = parseJsonString(`{"first": true, "second": 123, "third": false}`);
  assert(json.getBoolean("first") == true.toJson);
  assert(json.getBoolean("second", Json("default")) == Json("default"));
  assert(json.getBoolean("third") == false.toJson);
}

Json getBoolean(Json json, string key, Json defaultValue = Json(null)) {
  return json.isBoolean(key) ? json.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getBoolean for Json with key");

  Json json = parseJsonString(`{"first": true, "second": 123, "third": false}`);
  assert(json.getBoolean("first") == true.toJson);
  assert(json.getBoolean("second", Json("default")) == Json("default"));
  assert(json.getBoolean("third") == false.toJson);
}

Json getBooleans(Json json) {
  if (json.isArray) {
    Json result = Json.emptyArray;
    json.toArray.filter!(value => value.isBoolean).each!(value => result ~= value);
    return result;     
  }
  if (json.isObject) {
    Json result = Json.emptyObject;
    json.byKeyValue.filter!(kv => kv.value.isBoolean).each!(kv => result[kv.key] = kv.value);
    return result;     
  }
  return Json(null);
}
// #endregion Json
