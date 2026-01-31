/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.change;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Update the Json object with another Json object.
  *
  * Params:
  *   json = The Json object to update.
  *   map = The Json object containing key-value pairs to set in the original Json object.
  *
  * Returns:
  *   The updated Json object.
  */
Json update(Json json, Json updateMap) {
  if (!json.isObject || !updateMap.isObject) {
    return json;
  }

  foreach (key, value; updateMap.byKeyValue) {
    json = json.update(key, value);
  }
  return json;
}
///
unittest {
  mixin(ShowTest!"Json update(Json json, Json updateMap)");

  Json json = parseJsonString(`{"a":1,"b":2,"c":3}`);
  Json updateMap = parseJsonString(`{"a":10,"c":30}`);
  Json updated = update(json, updateMap);
  assert(updated["a"] == 10);
  assert(updated["b"] == 2);
  assert(updated["c"] == 30);
}

/** 
  * Update the Json object with a string-keyed associative array.
  *
  * Params:
  *   json = The Json object to update.
  *   values = An associative array of string keys and values to set in the Json object.
  *
  * Returns:
  *   The updated Json object.
  */
Json update(Json json, Json[string] map) {
  if (!json.isObject) {
    return json;
  }

  foreach (key, value; map) {
    json = json.update(key, value);
  }

  return json;
}
///
unittest {
  mixin(ShowTest!"Json update(Json json, Json[string] map)");

  Json json = parseJsonString(`{"a":1,"b":2}`);
  Json updated = json.update(["a":Json(42), "b":Json(42)]);
  assert(updated["a"] == 42);
  assert(updated["b"] == 42);
}

/** 
  * Update the Json object at the specified keys with the given value.
  *
  * Params:
  *   json = The Json object to update.
  *   keys = An array of keys representing the keys to update.
  *   value = The value to set at the specified keys.
  *
  * Returns:
  *   The updated Json object.
  */
Json update(Json json, string[] keys, Json value) {
  if (!json.isObject) {
    return json;
  }

  keys.each!(key => json.update(key, value));
  return json;
}
///
unittest {
  mixin(ShowTest!"Json update(Json json, string[] keys, Json value)");

  Json json = parseJsonString(`{"a":1,"b":2,"c":3}`);
  Json updated = json.update(["a", "c"], Json(99))  ;
  assert(updated["a"] == 99);
  assert(updated["b"] == 2);
  assert(updated["c"] == 99);
}

/** 
  * Update the Json object at the specified key with the given value.
  *
  * Params:
  *   json = The Json object to update.
  *   key = The key to update.
  *   value = The value to set at the specified key.
  *
  * Returns:
  *   The updated Json object.
  */
Json update(Json json, string key, Json value) {
  Json result  = json;
  if (result.isObject && result.hasKey(key)) {
    result[key] = value;
  }
  return result;
}
///
unittest {
  mixin(ShowTest!"Json update(Json json, string key, Json value)");

  Json json = parseJsonString(`{"a":1,"b":2}`);
  Json updated = update(json, "a", Json(100));
  assert(updated["a"] == 100);
  assert(updated["b"] == 2);
}