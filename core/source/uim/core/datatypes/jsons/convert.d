/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.convert;

import uim.core;

mixin(ShowModule!());

@safe:

// #region toArray(Json)
Json[] toArray(Json value) {
  if (value == Json(null)) {
    return null;
  }

  return value.isArray
    ? value.to!(Json[]) : null;
}
/// 
unittest {
  auto jsonArray = [1, 2, 3].toJson;
  auto array = toArray(jsonArray);
  assert(array.length == 3);
  assert(array[0] == Json(1));
  assert(array[1] == Json(2));
  assert(array[2] == Json(3));

  assert(toArray(Json(null)) == null);
  assert(toArray("string".toJson) == null);
}
// #endregion toArray(Json)

Json[string] toMap(Json value) {
  if (value == Json(null)) {
    return null;
  }

  return value.isObject
    ? value.to!(Json[string]) : null;
}
/// 
unittest {
  auto jsonMap = ["A": 1, "B": 2].toJson;
  auto map = toMap(jsonMap);
  assert(map.length == 2);
  assert(map["A"] == Json(1));
  assert(map["B"] == Json(2));

  assert(toMap(Json(null)) == null);
  assert(toMap([1, 2, 3].toJson) == null);
}
// #region toJson

// #region value to Json
Json toJson(T)(T value) if (isScalarType!(T)) {
  return Json(value);
}
/// 
unittest {
  assert(toJson(true) == Json(true));
  assert(toJson(42L) == Json(42));
  assert(toJson(3.14) == Json(3.14));
  assert(toJson("example") == Json("example"));
  auto id = randomUUID;
  assert(toJson(id) == Json(id.toString));
  assert(toJson(Json("example")) == Json("example"));
}

/// Convert boolean to Json
Json toJson(T:bool)(T value) {
  return Json(value);
}
/// 
unittest {
  assert(toJson(true) == Json(true));
  assert(toJson(false) == Json(false));
}
/// Convert integer to Json
Json toJson(T:long)(T value) {
  return Json(value);
}
/// 
unittest {

  assert(toJson(42L) == Json(42));  
}
/// Convert double to Json
Json toJson(T:double)(T value) {
  return Json(value);   
}
/// 
unittest {
  assert(toJson(3.14) == Json(3.14));  
}

/// Convert string to Json
Json toJson(T:string)(T value) {
  return Json(value);
}
/// 
unittest {
  assert(toJson("example") == Json("example"));  
}

Json toJson(T:UUID)(T value) {
  return Json(value.toString);
}
/// 
unittest {
  auto id = randomUUID;
  assert(toJson(id) == Json(id.toString));
}

Json toJson(T:Json)(T value) {
  return value;
}
/// 
unittest {
  assert(toJson(true) == Json(true));
  assert(toJson(42L) == Json(42));
  assert(toJson(3.14) == Json(3.14));
  assert(toJson("example") == Json("example"));
  auto id = randomUUID;
  assert(toJson(id) == Json(id.toString));
  assert(toJson(Json("example")) == Json("example"));
}
// #endregion value to Json

// #region array to Json
Json toJson(V)(V[] values) {
  Json json = values.map!(value => value.toJson).array;
  return json;
}
/// 
unittest {
  auto json1 = [1, 2, 3].toJson;
  assert(json1.isArray);
  assert(json1.length == 3);
  assert(json1[0] == Json(1));
  assert(json1[1] == Json(2));
  assert(json1[2] == Json(3));

  auto json2 = [Json("a"), Json("b"), Json("c")].toJson;
  assert(json2.isArray);
  assert(json2.length == 3);
  assert(json2[0] == Json("a"));
  assert(json2[1] == Json("b"));
  assert(json2[2] == Json("c"));

  auto id1 = randomUUID;
  auto id2 = randomUUID;
  auto id3 = randomUUID;

  auto uuids = [id1, id2, id3];
  auto json3 = uuids.toJson;
  assert(json3.isArray);
  assert(json3.length == 3);
  assert(json3[0] == id1.toJson);
  assert(json3[1] == id2.toJson);
  assert(json3[2] == id3.toJson);
}
// #endregion array to Json

// #region map to Json
Json toJson(V)(V[string] map) {
  Json json = Json.emptyObject;
  map.each!((key, value) => json[key] = value.toJson);
  return json;
}
unittest {
  string[string] map = ["A": "a", "B": "b"];
  assert(map.toJson["A"] == Json("a"));
}
// #endregion

// #region to Json object
// #region UUID 
Json toJson(string aKey, UUID uuid) {
  Json result = Json.emptyObject;
  result[aKey] = uuid.toJson;
  return result;
}
unittest {
  auto id = randomUUID;
  auto id2 = randomUUID;
  auto id3 = randomUUID;
  auto id4 = randomUUID;
  
  assert(id.toJson.get!string == id.toString);
  /* assert([id, id2, id3].toJson.hasKey(id));
  assert(![id, id2, id3].toJson.hasKey(id4)); */

  // assert([id, id2, id3].toJson.hasAllKey(id, id2, id3));
  // assert(id.toJson.get!string == id.toString);

  // assert(UUID(toJson("id", id)["id"].get!string) == id); */
}
// #endregion UUID

/// Special case for managing entities

Json toJson(UUID id, size_t versionNumber) {
  Json result = toJson("id", id);
  result["versionNumber"] = versionNumber;
  return result;
}
// #endregion

Json toJson(string[] values) {
  auto json = Json.emptyArray;
  values.each!(value => json ~= value);
  return json;
}

Json toJson(string[string] map, string[] excludeKeys = null) {
  Json json = Json.emptyObject;
  map.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => key == kv.key))
    .each!(kv => json[kv.key] = kv.value);
  return json;
}

Json toJson(Json[string] map) {
  Json json = Json.emptyObject;  
  map.each!((key, value) => json[key] = value);
  return json;
}
// #endregion toJson

// #region toJsonMap
Json[string] toJsonMap(bool[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => key in values))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
}

Json[string] toJsonMap(long[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => key in values))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
}

Json[string] toJsonMap(double[string] values, string[] excludeKeys = null) {
  Json[string] result;
  values.byKeyValue
    .filter!(kv => !excludeKeys.any!(key => key in values))
    .each!(kv => result[kv.key] = Json(kv.value));
  return result;
}

Json[string] toJsonMap(string[string] items, string[] excludeKeys = null) {
  Json[string] result;
  items.byKeyValue
    .filter!(item => !excludeKeys.hasValue(item.key))
    .each!(item => result[item.key] = Json(item.value));
  return result;
}

// #endregion toJsonMap

// #region toString

// #region Json[string]
string toString(Json[string] items) {
  return Json(items).toString;
}

string toString(Json[string] items, string[] keys) {
  if (keys.length == 0) keys = items.keys;

  Json json = Json.emptyObject;
  keys
    .filter!(key => items.hasKey(key))
    .each!(key => json[key] = items[key]);
  return json.toString; 
}
// #region Json[string]

// #region Json[]
string toString(Json[] jsons) {
  return Json(jsons).toString;
}
// #endregion Json[]

// #region Json
string toString(Json json, string[] keys) {
  if (!json.isObject) return json.toString; 
  
  if (keys.length == 0) return null;
  
  Json result = Json.emptyObject;
  keys
    .filter!(key => (key in json) ? true : false)
    .each!(key => result[key] = json[key]);
  return result.toString; 
}
// #endregion Json

unittest {
  auto jsons = [Json(1), Json("x"), Json(true)];
  assert(jsons.toStrings == ["1", "\"x\"", "true"]);

  // TODO: More tests
}
// #endregion toString

// #region toStrings
string[] toStrings(Json json) {
  if (!json.isArray) return null; 
  return json.toArray.array.toStrings;
}

string[] toStrings(Json[] jsons) {
  return jsons.map!(json => json.toString).array;
}
unittest {
  auto json1 = `{"name": "Example1", "id": 1}`.parseJsonString;
  auto json2 = `{"name": "Example2", "id": 2}`.parseJsonString;
  auto json3 = `{"name": "Example3", "id": 3}`.parseJsonString;

  auto jsons = [json1, json2, json3];
  assert(jsons.toStrings == [json1.toString, json2.toString, json3.toString]); 
}

string[] toStrings(UUID[] uuids) {
  return uuids.map!("a.toString").array;
}
unittest {
  auto id1 = randomUUID;
  auto id2 = randomUUID;
  auto id3 = randomUUID;

  auto uuids = [id1, id2, id3];
  assert(uuids.toStrings == [id1.toString, id2.toString, id3.toString]);
}
// #endregion toStrings
