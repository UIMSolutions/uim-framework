module uim.core.datatypes.jsons.has;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region hasAll
bool hasAllIndices(Json json, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAllIndices(indices, hasFunc) : false;
}

bool hasAllIndices(Json json, size_t[] indices) {
  return json.isArray ? json.toArray.hasAllIndices(indices) : false;
}

bool hasAllIndices(Json json, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAllIndices(hasFunc) : false;
}
// #endregion hasAll

// #region hasAny
bool hasAnyIndices(Json json, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAnyIndices(indices, hasFunc) : false;
}

bool hasAnyIndices(Json json, size_t[] indices) {
  return json.isArray ? json.toArray.hasAnyIndices(indices) : false;
}

bool hasAnyIndices(Json json, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAnyIndices(hasFunc) : false;
}
// #endregion hasAny

// #region has
bool hasIndex(Json json, size_t index) {
  return json.isArray ? json.length > index : false;
}
// #endregion has
// #endregion indices

// #region keys
// #region hasAll
bool hasAllKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc) {
  return json.isObject ? json.toMap.keys.all!(key => keys.canFind(key) && hasFunc(key)) : false;
}

bool hasAllKeys(Json json, string[] keys) {
  return json.isObject ? json.toMap.keys.all!(key => keys.canFind(key)) : false;
}

bool hasAllKeys(Json json, bool delegate(string) @safe hasFunc) {
  return json.isObject ? json.toMap.keys.all!(key => hasFunc(key)) : false;
}
// #endregion hasAll

// #region hasAny
bool hasAnyKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc) {
  return json.isObject ? json.toMap.keys.any!(key => keys.canFind(key) && hasFunc(key)) : false;
}

bool hasAnyKeys(Json json, string[] keys) {
  return json.isObject ? json.toMap.keys.any!(key => keys.canFind(key)) : false;
}

bool hasAnyKeys(Json json, bool delegate(string) @safe hasFunc) {
  return json.isObject ? json.toMap.keys.any!(key => hasFunc(key)) : false;
}
// #endregion hasAny

// #region has
// bool hasValue(Json[string] map, Json value) {
//   if (json == Json(null)) {
//     return false;
//   }

//   return jsons.any!(v => v == value);
// }
// #endregion has
// #endregion keys

// #region values
// #region hasAll
bool hasAllValues(Json json, Json[] values, bool delegate(Json) @safe hasFunc) {
  if (json.isArray) {
    return json.toArray.hasAllValues(values, hasFunc);
  }
  if (json.isObject) {
    return json.toMap.hasAllValues(values, hasFunc);
  }
  return false;
}

bool hasAllValues(Json json, Json[] values) {
  if (json.isArray) {
    return json.toArray.hasAllValues(values);
  }
  if (json.isObject) {
    return json.toMap.hasAllValues(values);
  }
  return false;
}

bool hasAllValues(Json json, bool delegate(Json) @safe hasFunc) {
  if (json.isArray) {
    return json.toArray.hasAllValues(hasFunc);
  }
  if (json.isObject) {
    return json.toMap.hasAllValues(hasFunc);
  }
  return false;
}
// #endregion hasAll

// #region hasAny
bool hasAnyValues(Json json, Json[] values, bool delegate(Json) @safe hasFunc) {
  if (json.isArray) {
    return json.toArray.hasAnyValues(values, hasFunc);
  }
  if (json.isObject) {
    return json.toMap.hasAnyValues(values, hasFunc);
  }
  return false;
}

bool hasAnyValues(Json json, Json[] values) {
  if (json.isArray) {
    return json.toArray.hasAnyValues(values);
  }
  if (json.isObject) {
    return json.toMap.hasAnyValues(values);
  }
  return false;
}

bool hasAnyValues(Json json, bool delegate(Json) @safe hasFunc) {
  if (json.isArray) {
    return json.toArray.hasAnyValues(hasFunc);
  }
  if (json.isObject) {
    return json.toMap.hasAnyValues(hasFunc);
  }
  return false;
}
// #endregion hasAny

// #region has
bool hasValue(Json json, Json value) {
  if (json == Json(null)) {
    return false;
  }

  if (json.isArray) {
    return json.toArray.any!(v => v == value);
  } else if (json.isObject) {
    foreach (k, v; json.toMap) {
      if (v == value) {
        return true;
      }
    }
  }
  return false;
}
// #endregion has
// #endregion values
// #endregion Json

// #region Json[]
// #region indices
// #region hasAll
bool hasAllIndices(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  if (jsons.length == 0 || indices.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (!indices.canFind(index) || !hasFunc(index)) {
      return false;
    }
  }
  return true;
}

bool hasAllIndices(Json[] jsons, size_t[] indices) {
  if (jsons.length == 0 || indices.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (!indices.canFind(index)) {
      return false;
    }
  }
  return true;
}

bool hasAllIndices(Json[] jsons, bool delegate(size_t) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (!hasFunc(index)) {
      return false;
    }
  }
  return true;
}
// #endregion hasAll

// #region hasAny
bool hasAnyIndices(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  if (jsons.length == 0 || indices.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (indices.canFind(index) && hasFunc(index))
      return true;
  }
  return false;
}

bool hasAnyIndices(Json[] jsons, size_t[] indices) {
  if (jsons.length == 0 || indices.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (indices.canFind(index))
      return true;
  }
  return false;
}

bool hasAnyIndices(Json[] jsons, bool delegate(size_t) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (hasFunc(index))
      return true;
  }
  return false;
}
// #endregion hasAny

// #region has
bool hasIndex(Json[] jsons, size_t index) {
  return jsons.length > index;
}
// #endregion has
// #endregion indices

// #region values
// #region hasAll
bool hasAllValues(Json[] jsons, Json[] values, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return jsons.all!(value => values.canFind(value) && hasFunc(value));
}

bool hasAllValues(Json[] jsons, Json[] values) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return jsons.all!(value => values.canFind(value));
}

bool hasAllValues(Json[] jsons, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  return jsons.all!(value => hasFunc(value));
}
// #endregion hasAll

// #region hasAny
bool hasAnyValues(Json[] jsons, Json[] values, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return jsons.any!(value => values.canFind(value) && hasFunc(value));
}

bool hasAnyValues(Json[] jsons, Json[] values) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return jsons.any!(value => values.canFind(value));
}

bool hasAnyValues(Json[] jsons, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  return jsons.any!(value => hasFunc(value));
}
// #endregion hasAny

// #region has
// bool hasValue(Json[] jsons, Json value) {
//   if (json == Json(null)) {
//     return false;
//   }

//   return jsons.any!(v => v == value);
// }
// #endregion has
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region keys
// #region hasAll
bool hasAllKeys(Json[string] map, string[] keys, bool delegate(string) @safe hasFunc) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return map.keys.all!(key => keys.canFind(key) && hasFunc(key));
}

bool hasAllKeys(Json[string] map, string[] keys) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return map.keys.all!(key => keys.canFind(key));
}

bool hasAllKeys(Json[string] map, bool delegate(string) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  return map.keys.all!(key => hasFunc(key));
}
// #endregion hasAll

// #region hasAny
bool hasAnyKeys(Json[string] map, string[] keys, bool delegate(string) @safe hasFunc) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return map.keys.any!(key => keys.canFind(key) && hasFunc(key));
}

bool hasAnyKeys(Json[string] map, string[] keys) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return map.keys.any!(key => keys.canFind(key));
}

bool hasAnyKeys(Json[string] map, bool delegate(string) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  return map.keys.any!(key => hasFunc(key));
}
// #endregion hasAny

// #region has
// bool hasValue(Json[string] map, Json value) {
//   if (json == Json(null)) {
//     return false;
//   }

//   return jsons.any!(v => v == value);
// }
// #endregion has
// #endregion keys

// #region values
// #region hasAll
bool hasAllValues(Json[string] map, Json[] values, bool delegate(Json) @safe hasFunc) {
  return map.hasAllValues((Json value) => values.canFind(value) && hasFunc(value));
}

bool hasAllValues(Json[string] map, Json[] values) {
  return map.hasAllValues((Json value) => values.canFind(value));
}

bool hasAllValues(Json[string] map, bool delegate(Json) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  foreach(key, value; map) {
    if (!hasFunc(value)) {
      return false;
    }
  }
  return true;
}
// #endregion hasAll

// #region hasAny
bool hasAnyValues(Json[string] map, Json[] values, bool delegate(Json) @safe hasFunc) {
  return map.hasAnyValues((Json value) => values.canFind(value) && hasFunc(value));
}

bool hasAnyValues(Json[string] map, Json[] values) {
  return map.hasAnyValues((Json value) => values.canFind(value));
}

bool hasAnyValues(Json[string] map, bool delegate(Json) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  foreach(key, value; map) {
    if (hasFunc(value)) {
      return true;
    }
  }
  return false;
}
// #endregion hasAny

// #region has
// bool hasValue(Json[string] map, Json value) {
//   if (json == Json(null)) {
//     return false;
//   }

//   return jsons.any!(v => v == value);
// }
// #endregion has
// #endregion values
// #endregion Json[string]


/*
// #region value
bool hasAllValue(Json json, Json[] values) {
  return values.all!(value => json.hasValue(value));
}

/// 
unittest {
  mixin(ShowTest!"Testing hasAllValue for Json with values");

  Json json = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(3)
  ].toJson;

  assert(json.hasValue(Json(2)));
  assert(!json.hasValue(Json(4)));

  assert(hasAllValue(json, [Json(1), Json(2)]));
  assert(!hasAllValue(json, [Json(1), Json(4)]));
}

bool hasAnyValue(Json json, Json[] values) {
  return values.any!(value => json.hasValue(value));
}
/// 
unittest {
  mixin(ShowTest!"Testing hasAnyValue for Json with values");

  Json json = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(3)
  ].toJson;

  assert(hasAnyValue(json, [Json(2), Json(4)]));
  assert(!hasAnyValue(json, [Json(4), Json(5)]));
}

bool hasValue(Json json, Json value) {
  if (json == Json(null)) {
    return false;
  }

  if (json.isArray) {
    return json.toArray.any!(v => v == value);
  } else if (json.isObject) {
    foreach (k, v; json.toMap) {
      if (v == value) {
        return true;
      }
    }
  }
  return false;
}
/// 
unittest {
  mixin(ShowTest!"Testing hasValue for Json with value");

  Json json = [
    "a": Json(1),
    "b": Json(4),
    "d": Json(5)
  ].toJson;

  assert(json.hasValue(Json(4)));
  assert(!json.hasValue(Json(6)));
}
// #endregion value

// #region path
// #region hasAll
bool hasAllPath(Json json, string[][] paths) {
  if (!json.isObject || paths.length == 0) {
    return false;
  }

  return paths.all!(path => json.hasPath(path));
}
/// 
unittest {
  mixin(ShowTest!"Testing hasAllPath for Json with paths");

  Json json = [
    "a": [
      "b": [
        "c": 123.toJson
      ].toJson
    ].toJson,
    "x": 456.toJson
  ].toJson;

  assert(json.hasAllPath([["a", "b", "c"], ["x"]]));
  assert(!json.hasAllPath([["a", "b", "d"], ["x"]]));

  Json json2 = [
    "a": [
      "b": [
        "c": Json(null)
      ].toJson
    ].toJson,
    "x": Json(null)
  ].toJson;

  assert(json2.hasAllPath([["a", "b", "c"], ["x"]]));
  assert(!json2.hasAllPath([["a", "b", "d"], ["x"]]));
}
// #endregion hasAll

// #region hasAny
bool hasAnyPath(Json json, string[][] paths) {
  if (!json.isObject || paths.length == 0) {
    return false;
  }

  return paths.any!(path => hasPath(json, path));
}
/// 
unittest {
  mixin(ShowTest!"Testing hasAnyPath for Json with paths");

  Json json = [
    "a": [
      "b": [
        "c": 123.toJson
      ].toJson
    ].toJson,
    "x": 456.toJson
  ].toJson;

  assert(json.hasAnyPath([["a", "b", "c"], ["y"]]));
  assert(!json.hasAnyPath([["a", "b", "d"], ["y"]]));
}
// #endregion hasAny
*/
// #region has
/** 
  * Checks if the given JSON value has the specified path.
  *
  * Params:
  *   json = The JSON value to check.
  *   path = An array of keys representing the path to check.
  *
  * Returns:
  *   `true` if the JSON value has the specified path, `false` otherwise.
  */
bool hasPath(Json json, string[] path) {
  if (!json.isObject || path.length == 0) {
    return false;
  }

  auto first = hasKey(json, path[0]);
  if (!first) {
    return false;
  }

  if (path.length == 1) {
    return first;
  }

  return json[path[0]].isObject ? hasPath(json[path[0]], path[1 .. $]) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing hasPath for Json with path");

  Json json = [
    "a": [
      "b": [
        "c": 123.toJson
      ].toJson
    ].toJson,
    "x": 456.toJson
  ].toJson;

  assert(hasPath(json, ["a", "b", "c"]));
  assert(!hasPath(json, ["a", "b", "d"]));
}
// #endregion has

// #region Json[string]
bool hasPath(Json[string] map, string[] path) {
  import uim.core.containers.associative.maps.has;

  if (map.length == 0 || path.length == 0) {
    return false;
  }

  auto keyFound = (path[0] in map) ? true : false;
  if (path.length == 1) {
    return keyFound;
  }

  if (!keyFound) {
    return false;
  }

  auto value = map[path[0]];
  return path.length > 1 && value.isObject ? value.hasPath(path[1 .. $]) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing hasPath for Json with path");

  Json json = [
    "a": [
      "b": [
        "c": 123.toJson
      ].toJson
    ].toJson,
    "x": 456.toJson
  ].toJson;

  assert(hasPath(json, ["a", "b", "c"]));
  assert(!hasPath(json, ["a", "b", "d"]));
}
// #endregion Json[string]

// #region key
// Check if json has key
bool hasAllKey(Json json, string[] keys) {
  if (!json.isObject || keys.length == 0) {
    return false;
  }

  return keys.all!(key => hasKey(json, key));
}
/// 
unittest {
  mixin(ShowTest!"Testing hasAllKey for Json with keys");

  Json json = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(3)
  ].toJson;

  assert(hasAllKey(json, ["a", "b"]));
  assert(!hasAllKey(json, ["a", "d"]));
}

/// Check if Json has key
bool hasAnyKey(Json json, string[] keys) {
  return keys.any!(key => hasKey(json, key));
}
/// 
unittest {
  mixin(ShowTest!"Testing hasAnyKey for Json with keys");

  Json json = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(3)
  ].toJson;

  assert(hasAnyKey(json, ["b", "d"]));
  assert(!hasAnyKey(json, ["d", "e"]));
}

// #region hasKey
/** 
  * Checks if the given JSON value has the specified key.
  *
  * Params:
  *   json = The JSON value to check.
  *   key = The key to check for.
  *
  * Returns:
  *   `true` if the JSON value has the specified key, `false` otherwise.
  */
bool hasKey(Json json, string key) {
  return json.isObject && key in json;
}
///
unittest {
  mixin(ShowTest!"Testing hasKey for Json with key");

  // Non-object JSON -> always false
  auto json1 = Json(1);
  assert(!hasKey(json1, "foo"));
  assert(!hasKey(json1, ""));

  // Object with keys -> true for present keys, false for absent
  auto json2 = Json(["a": Json(1), "": Json(2)]);
  assert(hasKey(json2, "a"));
  assert(hasKey(json2, ""));
  assert(!hasKey(json2, "b"));

  // Keys are exact (case-sensitive)
  auto json3 = Json(["Key": Json(1)]);
  assert(hasKey(json3, "Key"));
  assert(!hasKey(json3, "key"));

  // Keys with special characters
  auto json4 = Json(["weird:key!": Json(42)]);
  assert(hasKey(json4, "weird:key!"));
}
// #endregion hasKey

bool hasKey(Json[string] map, string key) {
  return (key in map) ? true : false;
}
// #endregion key

bool hasKeyValue(Json json, string key, Json value) {
  if (!json.isObject || !json.hasKey(key)) {
    return false;
  }

  return json[key] == value;
}
/// 
unittest {
  mixin(ShowTest!"Testing hasKeyValue for Json with key and value");

  Json json = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(3)
  ].toJson;

  assert(hasKeyValue(json, "a", Json(1)));
  assert(!hasKeyValue(json, "b", Json(3)));
  assert(!hasKeyValue(json, "d", Json(4)));
}
// #endregion has

