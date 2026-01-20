/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject get the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.values;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
// #region indices
// #region with indices and getFunc(index)
Json[] getValues(Json[] jsons, size_t[] indices, bool delegate(size_t index) @safe getFunc) {
  mixin(ShowFunction!());

  return jsons.getValues((size_t index) => indices.canFind(index) && getFunc(index));
}
// #endregion with indices and getFunc(index)

// #region with indices
Json[] getValues(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.getValues((size_t index) => indices.canFind(index));
}
// #endregion with indices

// #region with getFunc(index)
Json[] getValues(Json[] jsons, bool delegate(size_t) @safe getFunc) {
  Json[] result;
  foreach (index, value; jsons) {
    if (getFunc(index)) {
      result ~= value;
    }
  }
  return result;
}
// #endregion with getFunc(index)

// #region index
Json getValue(Json[] jsons, size_t index) {
  return index < jsons.length ? jsons[index] : Json(null);
}
// #endregion index
// #endregion indices

// #region values
// #region with values and getFunc(value)
Json[] getValues(Json[] jsons, Json[] values, bool delegate(Json) @safe getFunc) {
  mixin(ShowFunction!());

  return jsons.getValues(values).getValues((Json value) => getFunc(value));
}
// #endregion with values and getFunc(value)

// #region with values
Json[] getValues(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.getValues((Json value) => values.canFind(value));
}

Json[] getValues(Json[] jsons, bool delegate(Json) @safe getFunc) {
  mixin(ShowFunction!());

  return jsons.filter!(json => getFunc(json)).array;
}
// #endregion with values

Json[] getValues(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.dup;
}
// #endregion values 
// #endregion Json[]

// #region Json[string]
Json[] getValues(Json[string] map, string[][] paths, bool delegate(string[] path) @safe getFunc) {
  return paths.filter!(path => map.getValue(path) != Json(null) && getFunc(path))
    .map!(path => map.getValue(path))
    .array;
}
// #region paths
/** 
  * Retrieves values from the Json map based on the specified paths.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  paths = An array of string arrays, each representing a path to retrieve.
  *
  * Returns:
  *  An array of Json objects found at the specified paths.
**/
Json[] getValues(Json[string] map, string[][] paths) {
  return paths.filter!(path => map.getValue(path) != Json(null))
    .map!(path => map.getValue(path))
    .array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getValues with paths");

  Json[string] map = [
    "data": ["test": [1, 2, 3].toJson].toJson,
    "info": ["details": "sample".toJson].toJson
  ];

  auto values = map.getValues([
    ["data", "test"], ["info", "details"], ["nonexistent"]
  ]);
  assert(values.length == 2);
  assert(values[0] == [1, 2, 3].toJson);
  assert(values[1] == "sample".toJson);
}

/** 
  * Retrieves the value at the specified path from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  path = The path of the value to retrieve.
  *
  * Returns:
  *  The value at the specified path, or Json(null) if not found.
**/
Json getValue(Json[string] map, string[] path) {
  if (map.isNull || path.length == 0) {
    return Json(null);
  }

  auto key = path[0];
  if (!(key in map)) {
    return Json(null);
  }

  auto value = map[key];
  if (value == Json(null) || path.length == 1) {
    return value;
  }

  return value.isObject && path.length > 1 ? value.getValue(path[1 .. $]) : Json(null);
}
/// 
unittest {
  mixin(ShowTest!"Testing getValue with path");

  // Test with null map
  Json[string] nullMap;
  assert(nullMap.getValue(["key"]) == Json(null));

  // Test with empty path
  Json[string] map = ["key": "value".toJson];
  string[] emptyPath;
  assert(map.getValue(emptyPath) == Json(null));

  // Test with non-existent key in path
  assert(map.getValue(["nonexistent"]) == Json(null));

  // Test with single element path
  Json[string] map2 = ["data": "value".toJson];
  assert(map2.getValue(["data"]) == "value".toJson);

  // Test with nested path - successful
  Json[string] map3 = ["data": ["test": "nested".toJson].toJson];
  assert(map3.getValue(["data", "test"]) == "nested".toJson);

  // Test with nested path - null value
  Json[string] map4 = ["data": Json(null)];
  assert(map4.getValue(["data", "test"]) == Json(null));

  // Test with path longer than structure
  Json[string] map5 = ["data": ["test": "value".toJson].toJson];
  assert(map5.getValue(["data", "test", "extra"]) == Json(null));

  // Test with non-object intermediate value
  Json[string] map6 = ["data": "string".toJson];
  assert(map6.getValue(["data", "test"]) == Json(null));

  // Test with array values
  Json[string] map7 = ["data": ["test": [1, 2, 3].toJson].toJson];
  assert(map7.getValue(["data", "test"]) == [1, 2, 3].toJson);

  // Test with multiple nested levels
  Json[string] map8 = ["a": ["b": ["c": "deep".toJson].toJson].toJson];
  assert(map8.getValue(["a", "b", "c"]) == "deep".toJson);

  Json getValue(Json[string] map, string key) {
    return key in map ? map[key] : Json(null);
  }
}
// #endregion paths

// #region keys
Json[] getValues(Json[string] map, string[] keys, bool delegate(string) @safe getFunc) {
  return map.getValueMap(keys).getValues(getFunc);
}

/** 
  * Retrieves values from the Json map based on the specified keys.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  keys = An array of keys to retrieve.
  *
  * Returns:
  *  An array of Json objects found at the specified keys.
**/
Json[] getValues(Json[string] map, string[] keys) {
  return map.byKeyValue
    .filter!(kv => keys.hasValue(kv.key))
    .map!(kv => kv.value)
    .array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getValues with keys");

  Json[string] map = [
    "key1": "value1".toJson,
    "key2": "value2".toJson,
    "key3": "value3".toJson
  ];

  auto values = map.getValues(["key1", "key3", "nonexistent"]);
  assert(values.length == 2);
  assert(values[0] == "value1".toJson);
  assert(values[1] == "value3".toJson);
}

Json[] getValues(Json[string] map, bool delegate(string) @safe getFunc) {
  return map.byKeyValue
    .filter!(kv => getFunc(kv.key))
    .map!(kv => kv.value)
    .array;
}

/** 
  * Retrieves the value at the specified key from the Json map.
  *
  * Params:
  *  map = The Json map to retrieve from.
  *  key = The key of the value to retrieve.
  *
  * Returns:
  *  The value at the specified key, or Json(null) if not found.
**/
Json getValue(Json[string] map, string key) {
  return key in map ? map[key] : Json(null);
}
/// 
unittest {
  mixin(ShowTest!"Testing getValue with key");

  Json[string] map = ["key1": "value1".toJson, "key2": "value2".toJson];
  assert(map.getValue("key2") == "value2".toJson);
}
// #endregion keys

// #region values
// #region with values and getFunc(value)
Json[] getValues(Json[string] map, Json[] values, bool delegate(Json) @safe getFunc) {
  mixin(ShowFunction!());

  return map.getValues(values).getValues((Json value) => getFunc(value));
}
// #endregion with values and getFunc(value)

// #region with values
Json[] getValues(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.getValues((Json value) => values.canFind(value));
}

Json[] getValues(Json[string] map, bool delegate(Json) @safe getFunc) {
  mixin(ShowFunction!());

  Json[] result;
  foreach (key, value; map) {
    if (getFunc(value)) {
      result ~= value;
    }
  }
  return result;
}
// #endregion with values

// #region base
Json[] getValues(Json[string] map) {
  mixin(ShowFunction!());

  return map.byKeyValue
    .map!(kv => kv.value).array;
}
// #endregion base
// #endregion values
// #endregion Json[string]

// #region Json
// #region indices
/** 
  * Retrieves values from the Json object based on the specified indices.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  indices = An array of indices to retrieve.
  *
  * Returns:
  *  An array of Json objects found at the specified indices.
**/
Json[] getValues(Json json, size_t[] indices) {
  return indices.filter!(index => json.getValue(index) != Json(null))
    .map!(index => json.getValue(index))
    .array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getValues with indices");

  Json json = [1.toJson, 2.toJson, 3.toJson].toJson;
  auto values = json.getValues([0, 2, 5]);
  assert(values.length == 2);
  assert(values[0] == 1.toJson);
  assert(values[1] == 3.toJson);
}

/** 
  * Retrieves the value at the specified index from the Json array.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  index = The index of the value to retrieve.
  *
  * Returns:
  *  The value at the specified index, or Json(null) if the index is out of bounds.
**/
Json getValue(Json json, size_t index) {
  return json.isArray && json.length > index ? json[index] : Json(null);
}
/// 
unittest {
  mixin(ShowTest!"Testing getValue with index");

  Json json = [1, 2, 3].toJson;
  assert(json.getValue(1) == 2.toJson);
}
// #endregion indices

// #region paths
/** 
  * Retrieves values from the Json object based on the specified paths.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  paths = An array of string arrays, each representing a path to retrieve.
  *
  * Returns:
  *  An array of Json objects found at the specified paths.
**/
Json[] getValues(Json json, string[][] paths) {
  return paths.filter!(path => json.getValue(path) != Json(null))
    .map!(path => json.getValue(path))
    .array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getValues with paths");

  Json json = parseJsonString(`{"data": { "test": [1, 2, 3]}, "info": { "details": "sample"}}`);
  auto values = json.getValues([
    ["data", "test"], ["info", "details"], ["nonexistent"]
  ]);
  assert(values.length == 2);
  assert(values[0] == [1, 2, 3].toJson);
  assert(values[1] == "sample".toJson);
}

/** 
  * Retrieves the value at the specified path from the Json map.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  path = The path of the value to retrieve.
  *
  * Returns:
  *  The value at the specified path, or Json(null) if not found.
**/
Json getValue(Json json, string[] path) {
  if (json == Json(null) || path.length == 0) {
    return Json(null);
  }

  // writeln("Checking isArray for path: ", path, " in json: ", json, " of type ", json.type);
  auto firstJson = json.getValue(path[0]);
  if (path.length == 1 || firstJson == Json(null)) {
    return firstJson;
  }

  // writeln("Checking isArray for path[0]: ", path[0], " in firstJson: ", firstJson, " of type ", firstJson.type);
  return path.length > 1 ? firstJson.getValue(
    path[1 .. $]) : Json(null);
}
/// 
unittest {
  mixin(ShowTest!"Testing getValue with path");

  Json json = parseJsonString(`{"data": { "test": [1, 2, 3]}}`);
  assert(json.getValue(["data"]).getValue(["test"]) != Json(null));
  assert(json.getValue(["data", "test"]) != Json(null));
  assert(json.getValue(["data", "test"]) == [1, 2, 3].toJson);
}
// #endregion paths

// #region keys
/** 
  * Retrieves values from the Json object based on the specified keys.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  keys = An array of keys to retrieve.
  *
  * Returns:
  *  An array of Json objects found at the specified keys.
**/
Json[string] getValueMap(Json json, string[] keys) {
  Json[string] result;
  foreach (key; keys) {
    if (key in json) {
      result[key] = json[key];
    }
  }
  return result;
}

/** 
  * Retrieves values from the Json object based on the specified keys.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  keys = An array of keys to retrieve.
  *
  * Returns:
  *  An array of Json objects found at the specified keys.
**/
Json[] getValues(Json json, string[] keys) {
  return keys.filter!(key => json.getValue(key) != Json(null))
    .map!(key => json.getValue(key))
    .array;
}
/// 
unittest {
  mixin(ShowTest!"Testing getValues with keys");

  Json json = parseJsonString(`{"key1": "value1", "key2": "value2", "key3": "value3"}`);
  auto values = json.getValues(["key1", "key3", "nonexistent"]);
  assert(values.length == 2);
  assert(values[0] == "value1".toJson);
  assert(values[1] == "value3".toJson);
}

/** 
  * Retrieves the value at the specified key from the Json object.
  *
  * Params:
  *  json = The Json object to retrieve from.
  *  key = The key of the value to retrieve.
  *
  * Returns:
  *  The value at the specified key, or Json(null) if not found.
**/
Json getValue(Json json, string key) {
  if (!json.isObject) {
    return Json(null);
  }

  return key in json ? json[key] : Json(null);
}
/// 
unittest {
  mixin(ShowTest!"Testing getValue with key");

  Json json = ["key1": "value1".toJson, "key2": "value2".toJson].toJson;
  assert(json.getValue("key2") == "value2".toJson);
}
// #endregion keys

Json[] getValues(Json json, bool delegate(size_t) @safe getFunc) {
  Json[] result;
  if (json.isArray) {
    foreach (index, value; json.toArray) {
      if (getFunc(index)) {
        result ~= value;
      }
    }
  }
  return result;
}

Json[] getValues(Json json, bool delegate(string) @safe getFunc) {
  return json.isObject ? json.byKeyValue
    .filter!(kv => getFunc(kv.key))
    .map!(kv => kv.value)
    .array : null;
}

Json[] getValues(Json json, bool delegate(Json) @safe getFunc) {
  if (json == Json(null)) {
    return null;
  }
  if (json.isArray) {
    return json.toArray.filter!(value => getFunc(value)).array;
  }
  if (json.isObject) {
    return json.byKeyValue
      .filter!(kv => getFunc(kv.value))
      .map!(kv => kv.value)
      .array;
  }
  return null;
}
// #endregion Json

// #region ValueMap
Json[string] getValueMap(Json[string] map, string[] keys, bool delegate(string key) @safe getFunc) {
  return map.getValueMap(keys).getValueMap(getFunc);
}

Json[string] getValueMap(Json[string] map, string[] keys) {
  return map.getValueMap((string key) => keys.canFind(key));
}

Json[string] getValueMap(Json[string] map, bool delegate(string key) @safe getFunc) {
  Json[string] result;

  foreach (key, value; map) {
    if (getFunc(key)) {
      result[key] = value;
    }
  }

  return result;
}
// #endregion ValueMap
