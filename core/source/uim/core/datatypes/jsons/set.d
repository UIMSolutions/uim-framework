/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.set;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
/// Sets multiple keys to values from a map
Json setValues(Json json, Json newJson) {
  auto result = json;
  foreach (kv; newJson.byKeyValue) {
    result[kv.key] = kv.value;
  }
  return result;
}

Json setValues(Json json, Json[string] map) {
  auto result = json;
  foreach (key, value; map) {
    result[key] = value;
  }
  return result;
}
/// 
unittest {
  version (show_module)
    writeln("Testing setValues with map");

  auto json = Json.emptyObject;
  Json[string] map;
  map["one"] = Json(1);
  map["two"] = Json(2);
  json = json.setValues(map);
  assert(json["one"] == Json(1));
  assert(json["two"] == Json(2));
}

/// Sets multiple keys to the same value
Json setValues(Json json, string[] keys, Json value) {
  keys.each!(key => json = json.setValue(key, value));
  return json;
}
/// 
unittest {
  version (show_module)
    writeln("Testing setValues with keys and value");

  auto json = Json.emptyObject;
  json = json.setValues(["a", "b", "c"], Json(42));
  assert(json["a"] == Json(42));
  assert(json["b"] == Json(42));
  assert(json["c"] == Json(42));
}

Json setValue(Json json, string[] path, Json value) {
  auto result = json;
  if (!result.isObject || path.length == 0) {
    return result;
  }

  if (path.length == 1) {
    return result.setValue(path[0], value);
  }

  if (result.hasKey(path[0])) {
    result[path[0]] = result[path[0]].setValue(path[1 .. $], value);
  } else {
    Json child = Json.emptyObject;
    child = child.setValue(path[1 .. $], value);
    result[path[0]] = child;
  }

  return result;
}
/// 
unittest {
  version (show_module)
    writeln("Testing setValue with path and value");

  auto json = Json.emptyObject;
  json = json.setValue(["a", "b", "c"], Json(123));
  assert(json["a"]["b"]["c"] == Json(123));
}
// #endregion Json

// #region Json[]
// #endregion Json[]

// #region Json[string]
Json[string] setValue(Json[string] map, string[] path, Json value) {
  Json[string] result = map.dup;

  if (path.length == 0) {
    return result;
  }

  if (path.length == 1) {
    result[path[0]] = value;
  }

  if (path.length > 1) {
    result[path[0]] = Json.emptyObject.setValue(path[1 .. $], value);
  }

  return result;
}
/// 
unittest {
  version (show_module)
    writeln("Testing setValue with path and value for map");

  Json[string] map;
  map = setValue(map, ["a", "b", "c"], Json(456));
  assert(map["a"]["b"]["c"] == Json(456));
}
// #endregion Json[string]

/// Set path with value

/// Sets a single key to a value
Json setValue(Json json, string key, Json value) {
  auto result = json;
  if (result.isObject) {
    result[key] = value;
  }
  return result;
}
/// 
unittest {
  mixin(ShowTest!("Testing setValue with key and value"));

  auto json = Json.emptyObject;
  json = json.setValue("name", Json("example"));
  assert(json["name"] == Json("example"));
}

Json set(T)(Json json, string key, T value) {
  if (!json.isObject)
    return json;

  json[key] = value.toJson;
  return json;
}
/// 
unittest {
  mixin(ShowTest!("Testing set with key and value for generic type"));

  auto json = Json.emptyObject;

  json = json.set("age", 30);
  assert(json["age"] == Json(30));

  json = json.set("name", "Alice");
  assert(json["name"] == Json("Alice"));

  json = json.set("isActive", true);
  assert(json["isActive"] == Json(true));

  auto id = randomUUID();
  json = json.set("id", id);
  assert(json["id"] == id.toJson);

  auto json2 = Json.emptyObject
    .set("age", 30)
    .set("name", "Alice")
    .set("isActive", true);
  assert(json2["age"] == Json(30));
  assert(json2["name"] == Json("Alice"));
  assert(json2["isActive"] == Json(true));
}

Json set(T)(Json json, string key, T[] values) if (!is(T[] == string)) {
  if (!json.isObject)
    return json;

  json[key] = values.toJson;
  return json;
}
///
unittest {
  mixin(ShowTest!("Testing set with key and value for generic type"));

  auto json = Json.emptyObject;
  json = json.set("age", 30);
  assert(json["age"] == Json(30));

  json = json.set("name", "Alice");
  assert(json["name"] == Json("Alice"));

  json = json.set("isActive", true);
  assert(json["isActive"] == Json(true));

  auto json2 = Json.emptyObject
    .set("age", 30)
    .set("name", "Alice")
    .set("isActive", true);

  assert(json2["age"] == Json(30));
  assert(json2["name"] == Json("Alice"));
  assert(json2["isActive"] == Json(true));

}

Json set(T)(Json json, string key, T[] values) if (!is(T[] == string)) {
  if (!json.isObject)
    return json;

  Json jArray = Json.emptyArray;
  foreach (v; values) {
    jArray ~= v.toJson;
  }
  json[key] = jArray;
  return json;
}

unittest {
  Json j1 = Json.emptyObject
    .set("key1", "value1");

  assert(j1["key1"] == "value1");

  Json j2 = Json.emptyObject
    .set("key1", "value1")
    .set("key2", "value2");

  assert(j2["key1"] == "value1");
  assert(j2["key2"] == "value2");
}
