/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.uuids.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region path
// #region getUUIDs(json, paths)
/**
  * Retrieves all uuids at the specified paths from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   paths = The paths of the uuids to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  * Returns:
  *   An UUID[] containing all uuids found at the specified paths.
**/
UUID[] getUUIDs(Json json, string[][] paths, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getUUIDs(paths, defaultValue) : null;
}
// #endregion getUUIDs(json, paths)

// #region getUUID(json, path)
/**
  * Retrieves the uuid at the specified path from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the uuid to retrieve.
  *  defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *  The uuid at the specified path, or the default value if not found.
**/
UUID getUUID(Json json, string[] path, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return json.isUUID(path) ? json.getValue(path).getUUID : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID with path");

  Json json = parseJsonString(`{"data": { "test": [ 1, {"a": 1}, [3, 4] ]}}`);
  // assert(json.getUUID(["data", "test"])[0] == 1.toJson, "Expected uuid at path ['data', 'test'][0]");
  // assert(json.getUUID(["data", "test"]).filterArrays()[0] == 1.toJson, "Expected filtered uuid at path ['data', 'test'][0]");
}
// #endregion getUUID(json, path)
// #endregion path

// #region key
// #region getUUIDs(json, keys)
/**
  * Retrieves all uuids at the specified keys from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  *   keys = The keys of the uuids to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An UUID[] containing all uuids found at the specified keys.
**/
UUID[] getUUIDs(Json json, string[] keys, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.getUUIDs(keys, defaultValue) : null;
}
// #endregion getUUIDs(json, keys)

// #region getUUID(json, key)
/**
  * Retrieves the uuid at the specified key from the Json object.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the uuid to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *   The uuid at the specified key, or the default value if not found.
**/
UUID getUUID(Json json, string key, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return json.isUUID(key) ? json[key].getUUID : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID for Json with key");

  auto id = randomUUID().toJson;
  Json jsonMap = [
    "first": id, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ].toJson;
  // TODO: writeln("map[first] -> ", jsonMap["first"], " - length: ", jsonMap["first"].toString.length); 
  // TODO: writeln("map -> ", jsonMap.getUUID("first"), " - length: ", jsonMap.getUUID("first").toString.length); 
  // TODO: writeln("id -> ", id.getString, " - length: ", UUID(id.getString).toString.length); 
  // TODO: assert(jsonMap.getUUID("first") == UUID(id.getString), "Expected uuid at key 'first'");
}
// #endregion getUUID(Json, key)
// #endregion key

// #region index
// #region getUUIDs(json, indices)
/**
  * Retrieves all uuids at the specified indices from the Json array.
  * Params:
  *   json = The Json object to retrieve from.
  *   indices = The indices of the uuids to retrieve.
  *   defaultValue = The value to return if the key does not contain an array.
  * Returns:
  *   An UUID[] containing all uuids found at the specified keys.
**/
UUID[] getUUIDs(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getUUIDs(indices) : null;
}
// #endregion getUUIDs(json, indices)

// #region getUUID(json, index)
/**
  * Retrieves the uuid at the specified index from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the uuid to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The uuid at the specified index, or the default value if not found.
**/
UUID getUUID(Json json, size_t index, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return json.isUUID(index) ? json[index].getUUID : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID for Json with index");

  auto id = randomUUID().toJson;
  Json jsonArray = [
    id, ["a": 1].toJson, [3, 4].toJson
  ].toJson;
  assert(jsonArray.getUUID(0) == UUID(id.getString), "Expected uuid at index 0");
}
// #endregion getUUID(json, index)
// #endregion index
// #endregion Json

// #region Json[string]
// #region path
UUID[] getUUIDs(Json[string] map, string[][] paths, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return paths.map!(path => map.getUUID(path, defaultValue)).array;
}
/**
  * Retrieves the uuid at the specified path from the Json map.
  *
  * Params:
  *   map = The Json map to retrieve from.
  *   path = The path of the uuid to retrieve.
  *   defaultValue = The value to return if the path does not contain an array.
  *
  * Returns:
  *   The uuid at the specified path, or the default value if not found.
**/
UUID getUUID(Json[string] map, string[] path, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return map.getValue(path).isUUID ? map.getValue(path).getUUID : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID for Json[string] with path");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "first": id, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getUUID("first") == UUID(id.getString), "Expected uuid at path 'first'");
}
// #endregion path

// #region key
// #region getUUIDs(Json[string] map, keys)
/**
  * Retrieves all uuids at the specified keys from the Json map.
  * Params:
  *   map = The Json map to retrieve from.
  *   keys = The keys of the uuids to retrieve.
  * Returns:
  *   An UUID[] containing all uuids found at the specified keys.
**/ 
UUID[] getUUIDs(Json[string] map, string[] keys, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return keys.map!(key => map.getUUID(key, defaultValue)).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUIDs for Json[string] with keys");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "first": id, "second": ["a": 1].toJson, "third": id, "fourth": [3, 4].toJson
  ];
  auto uuids = map.getUUIDs(["first", "third", "fourth"]);
  assert(uuids.length == 3, "Expected 3 uuids");
  assert(uuids[0] == UUID(id.getString), "Expected uuid at key 'first'");
  assert(uuids[1] == UUID(id.getString), "Expected uuid at key 'third'");
}
// #endregion getUUIDs(Json[string] map, keys)

// #region getUUID(Json[string] map, key)
/**
  * Retrieves the uuid at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the uuid to retrieve.
  *  defaultValue = The value to return if the key does not contain an array.
  *
  * Returns:
  *  The uuid at the specified key, or the default value if not found.
**/
UUID getUUID(Json[string] map, string key, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return map.getValue(key).isUUID ? map.getValue(key).getUUID : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID for Json[string] with key");

  auto id = randomUUID().toJson;
  Json[string] map = [
    "first": id, "second": ["a": 1].toJson, "third": [3, 4].toJson
  ];
  assert(map.getUUID("first") == UUID(id.getString), "Expected uuid at key 'first'");
}
// #endregion getUUID(Json[string] map, key)
// #endregion key

// #region getUUIDs(Json[string] map)
/** 
  * Retrieves all uuids from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *
  * Returns:
  *  A Json[string] containing all uuids found in the Json map.
**/
UUID[string] getUUIDs(Json[string] map) {
  mixin(ShowFunction!());

  UUID[string] result;
  foreach (key, value; map) {
    if (value.isUUID) {
      result[key] = value.getUUID;
    }
  }
  return result;
}
// #endregion getUUIDs(Json[string] map)
// #endregion Json[string]

// #region Json[]
// #region getUUIDs(Json[], indices) 
/** 
  * Retrieves all uuids at the specified indices from the Json array.
  *
  * Params:
  *   jsons = The array of Json objects to retrieve from.
  *   indices = The indices of the uuids to retrieve.
  * Returns:
  *   An array of uuids found at the specified indices.
**/
UUID[] getUUIDs(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues(indices, (size_t index) => jsons[index].isUUID).map!(json => json.getUUID).array;
}
///
unittest {
  mixin(ShowTest!"Testing getUUIDs for Json[] with indices");

  auto id = randomUUID().toJson;
  Json[] jsons = [id, ["a": 1].toJson, id, [3, 4].toJson];
  auto uuids = jsons.getUUIDs([0, 2]);
  assert(uuids.length == 2, "Expected 2 uuids");
  assert(uuids[0] == UUID(id.getString), "Expected uuid at index 0");
  assert(uuids[1] == UUID(id.getString), "Expected uuid at index 2");
}
// #endregion getUUIDs(Json[], indices) 

// #region getUUID(Json[], index)
/** 
  * Retrieves the uuid at the specified index from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *  index = The index of the uuid to retrieve.
  *  defaultValue = The value to return if the index does not contain an array.
  *
  * Returns:
  *  The uuid at the specified index, or the default value if not found.
**/
UUID getUUID(Json[] jsons, size_t index, UUID defaultValue = NULLUUID) {
  mixin(ShowFunction!());

  return jsons.getValue(index).isUUID ? jsons[index].getUUID : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID for Json[] with index");

  auto id = randomUUID().toJson;
  Json[] jsons = [id, ["a": 1].toJson, id, [3, 4].toJson];
  assert(jsons.getUUID(0) == UUID(id.getString), "Expected uuid at index 0");
}
// #endregion getUUID(Json[], index)

// #region getUUID(Json[])
/** 
  * Retrieves all uuids from the Json array.
  *
  * Params:
  *  jsons = The array of Json objects to retrieve from.
  *
  * Returns:
  *  An array of uuids found in the input array.
**/
UUID[] getUUIDs(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.filter!(json => json.isUUID).map!(json => json.getUUID).array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUIDs for Json[]");

  auto id = randomUUID().toJson;
  Json[] jsons = [
    id, ["a": 1].toJson, id, [3, 4].toJson
  ];
  auto uuids = jsons.getUUIDs;
  assert(uuids.length == 2, "Expected 2 uuids");
  assert(uuids[0] == UUID(id.getString), "Expected uuid at index 0");
  assert(uuids[1] == UUID(id.getString), "Expected uuid at index 2");
}
// #endregion getUUID(Json[])
// #endregion Json[]

// #region Json
// #region getUUIDs(Json)
/** 
  * Retrieves all uuids from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *
  * Returns:
  *  A Json containing all uuids found in the Json object.
**/
UUID[] getUUIDs(Json json) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.getUUIDs : null;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUIDs for Json");

  auto id = randomUUID().toJson;
  Json jsonArray = [
    id, ["a": 1].toJson, id, [3, 4].toJson
  ].toJson;
  auto arraysFromArray = jsonArray.getUUIDs;
  // TODO
}
// #endregion getUUIDs(Json)

// #region getUUID(Json)
/** 
  * Retrieves the uuid from the Json object.
  * Params:
  *   json = The Json object to retrieve from.
  * Returns:
  *   The uuid contained in the Json object, or null if not an uuid.
**/
UUID getUUID(Json json) {
  mixin(ShowFunction!());

  return json.getString.isUUID ? UUID(json.getString) : NULLUUID;
}
/// 
unittest {
  mixin(ShowTest!"Testing getUUID for Json");

  auto id = randomUUID().toJson;
  Json json = id;
  assert(json.getUUID == UUID(id.getString), "Expected uuid from Json");
}
// #endregion getUUID(Json)