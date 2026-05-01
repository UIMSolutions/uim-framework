/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.has;

import uim.core;

mixin(ShowModule!());

@safe:

// #region hasKey
// #region Json
/** 
  * Checks if the given Json value has the specified key.
  *
  * Params:
  *   json = The Json value to check.
  *   key = The key to check for.
  *
  * Returns:
  *   `true` if the Json value has the specified key, `false` otherwise.
  */
bool hasKey(Json json, string key) {
  return json.isObject && key in json;
}
///
unittest {
  mixin(ShowTest!"Testing hasKey for Json with key");

  // Non-object Json -> always false
  auto json1 = Json(1);
  assert(!hasKey(json1, "foo"));
  assert(!hasKey(json1, ""));

  // Object with keys -> true for present keys, false for absent
  auto json2 = ["a": Json(1), "": Json(2)].toJson;
  assert(hasKey(json2, "a"));
  assert(hasKey(json2, ""));
  assert(!hasKey(json2, "b"));

  // Keys are exact (case-sensitive)
  auto json3 = ["Key": Json(1)].toJson;
  assert(hasKey(json3, "Key"));
  assert(!hasKey(json3, "key"));

  // Keys with special characters
  auto json4 = ["weird:key!": Json(42)].toJson;
  assert(hasKey(json4, "weird:key!"));
}
// #endregion Json

// #region Json[string]
bool hasKey(Json[string] map, string key) {
  return (key in map) ? true : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing hasKey for Json[string] with key");

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(hasKey(map, "a"));
  assert(!hasKey(map, "d"));
}
// #endregion Json[string]
// #endregion hasKey

// #region hasKeyValue
bool hasKeyValue(Json json, string key, Json value) {
  return json.hasKey(key) && json[key] == value;
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
// #endregion hasKeyValue

// #region Json
// #region key
// #region hasAllKey(Json json, string[] keys)
bool hasAllKey(Json json, string[] keys) {
  if (!json.isObject || keys.length == 0) {
    return false;
  }

  return keys.all!(key => json.hasKey(key));
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
// #endregion hasAllKey(Json json, string[] keys)

// #region hasAnyKey(Json json, string[] keys)
bool hasAnyKey(Json json, string[] keys) {
  return keys.any!(key => json.hasKey(key));
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
// #endregion hasAnyKey(Json json, string[] keys)
// #endregion key
// #endregion Json

// #endregion has

// #region hasKey
// #endregion hasKey

// #region Json[]
// #region indices
// #region hasAll
bool hasAllIndices(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  if (indices.length == 0) {
    return true;
  }

  if (jsons.length == 0) {
    return false;
  }

  foreach (index; indices) {
    if (jsons.length <= index || !hasFunc(index)) {
      return false;
    }
  }
  return true;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllIndices for Json[] with indices and function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAllIndices([0, 1], i => i < 3));
  assert(!jsons.hasAllIndices([0, 3], i => i < 3));
}

bool hasAllIndices(Json[] jsons, size_t[] indices) {
  if (indices.length == 0) {
    return true;
  }

  if (jsons.length == 0) {
    return false;
  }

  return indices.all!(index => jsons.length > index);
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllIndices for Json[] with indices"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAllIndices([0, 1]));
  assert(!jsons.hasAllIndices([0, 3]));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAllIndices for Json[] with function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAllIndices(i => i < 3));
  assert(!jsons.hasAllIndices(i => i < 2));
}
// #endregion hasAll

// #region hasAny
bool hasAnyIndices(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  if (indices.length == 0) {
    return true;
  }

  if (jsons.length == 0) {
    return false;
  }

  return indices.any!(index => jsons.length > index && hasFunc(index));
}

/// 
unittest {
  mixin(ShowTest!("Testing hasAnyIndices for Json[] with indices and function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyIndices([0, 1], i => i < 3));
  assert(jsons.hasAnyIndices([0, 3], i => i < 3));
}

bool hasAnyIndices(Json[] jsons, size_t[] indices) {
  if (indices.length == 0) {
    return true;
  }

  if (jsons.length == 0) {
    return false;
  }

  return indices.any!(index => jsons.length > index);
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyIndices for Json[] with indices"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyIndices([0, 1]));
  assert(jsons.hasAnyIndices([0, 3]));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyIndices for Json[] with indices"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyIndices([0, 1]));
  assert(jsons.hasAnyIndices([0, 3]));
}

bool hasAnyIndices(Json[] jsons, bool delegate(size_t) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  foreach (index, value; jsons) {
    if (hasFunc(index)) {
      return true;
    }
  }
  return false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyIndices for Json[] with function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyIndices(i => i < 3));
  assert(jsons.hasAnyIndices(i => i < 2));
}
// #endregion hasAny

// #region has
bool hasIndex(Json[] jsons, size_t index) {
  return jsons.length > index;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasIndex for Json[] with index"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasIndex(0));
  assert(jsons.hasIndex(2));
  assert(!jsons.hasIndex(3));
}
// #endregion has
// #endregion indices

// #region values
// #region hasAll
bool hasAllValues(Json[] jsons, Json[] values, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return values.all!(value => jsons.canFind(value) && hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues for Json[] with values and function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAllValues([Json(1), Json(2)], v => v.isNumber));
  assert(!jsons.hasAllValues([Json(1), Json(4)], v => v.isNumber));
}

bool hasAllValues(Json[] jsons, Json[] values) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return values.all!(value => jsons.canFind(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues for Json[] with values"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAllValues([Json(1), Json(2)]));
  assert(!jsons.hasAllValues([Json(1), Json(4)]));
}

bool hasAllValues(Json[] jsons, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  return jsons.all!(value => hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues for Json[] with function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAllValues(v => v.isNumber));
  assert(!jsons.hasAllValues(v => v.isString));
}

// #endregion hasAll

// #region hasAny
bool hasAnyValues(Json[] jsons, Json[] values, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return values.any!(value => jsons.canFind(value) && hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues for Json[] with values and function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyValues([Json(1), Json(2)], v => v.isNumber));
  assert(jsons.hasAnyValues([Json(1), Json(4)], v => v.isNumber));
  assert(!jsons.hasAnyValues([Json(4), Json(5)], v => v.isNumber));
}

bool hasAnyValues(Json[] jsons, Json[] values) {
  if (jsons.length == 0 || values.length == 0) {
    return false;
  }

  return values.any!(value => jsons.canFind(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues for Json[] with values"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyValues([Json(1), Json(2)]));
  assert(jsons.hasAnyValues([Json(1), Json(4)]));
  assert(!jsons.hasAnyValues([Json(4), Json(5)]));
}

bool hasAnyValues(Json[] jsons, bool delegate(Json) @safe hasFunc) {
  if (jsons.length == 0) {
    return false;
  }

  return jsons.any!(value => hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues for Json[] with function"));

  auto jsons = [Json(1), Json(2), Json(3)];
  assert(jsons.hasAnyValues(v => v.isNumber));
  assert(!jsons.hasAnyValues(v => v.isString));
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

  return keys.all!(key => map.hasKey(key) && hasFunc(key));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllKeys for Json[string] with keys and function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAllKeys(["a", "b"], k => k.length == 1));
  assert(!map.hasAllKeys(["a", "d"], k => k.length == 1));
}

bool hasAllKeys(Json[string] map, string[] keys) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return keys.all!(key => map.hasKey(key));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllKeys for Json[string] with keys"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAllKeys(["a", "b"]));
  assert(!map.hasAllKeys(["a", "d"]));
}

bool hasAllKeys(Json[string] map, bool delegate(string) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  return map.keys.all!(key => hasFunc(key));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllKeys for Json[string] with function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAllKeys(k => k.length == 1));
  assert(!map.hasAllKeys(k => k.length == 2));
}
// #endregion hasAll

// #region hasAny
bool hasAnyKeys(Json[string] map, string[] keys, bool delegate(string) @safe hasFunc) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return keys.any!(key => map.hasKey(key) && hasFunc(key));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyKeys for Json[string] with keys and function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAnyKeys(["b", "d"], k => k.length == 1));
  assert(!map.hasAnyKeys(["d", "e"], k => k.length == 1));
}

bool hasAnyKeys(Json[string] map, string[] keys) {
  if (map.length == 0 || keys.length == 0) {
    return false;
  }

  return keys.any!(key => map.hasKey(key));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyKeys for Json[string] with keys"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAnyKeys(["b", "d"]));
  assert(!map.hasAnyKeys(["d", "e"]));
}

bool hasAnyKeys(Json[string] map, bool delegate(string) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  return map.keys.any!(key => hasFunc(key));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyKeys for Json[string] with function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAnyKeys(k => k.length == 1));
  assert(!map.hasAnyKeys(k => k.length == 2));
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
  return values.all!(value => map.hasValue(value) && hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues for Json[string] with values and function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAllValues([Json(1), Json(2)], v => v.isNumber));
  assert(!map.hasAllValues([Json(1), Json(4)], v => v.isNumber));
}

bool hasAllValues(Json[string] map, Json[] values) {
  return values.all!(value => map.hasValue(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues for Json[string] with values"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAllValues([Json(1), Json(2)]));
  assert(!map.hasAllValues([Json(1), Json(4)]));
}

bool hasAllValues(Json[string] map, bool delegate(Json) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  foreach (key, value; map) {
    if (!hasFunc(value)) {
      return false;
    }
  }
  return true;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues for Json[string] with function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAllValues(v => v.isNumber));
  assert(!map.hasAllValues(v => v.isString));
}
// #endregion hasAll

// #region hasAny
bool hasAnyValues(Json[string] map, Json[] values, bool delegate(Json) @safe hasFunc) {
  return values.any!(value => map.hasValue(value) && hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues for Json[string] with values and function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAnyValues([Json(1), Json(4)], v => v.isNumber));
  assert(!map.hasAnyValues([Json(4), Json(5)], v => v.isNumber));
}

bool hasAnyValues(Json[string] map, Json[] values) {
  return values.any!(value => map.hasValue(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues for Json[string] with values"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAnyValues([Json(1), Json(4)]));
  assert(!map.hasAnyValues([Json(4), Json(5)]));
}

bool hasAnyValues(Json[string] map, bool delegate(Json) @safe hasFunc) {
  if (map.length == 0) {
    return false;
  }

  return map.values.any!(value => hasFunc(value));
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues for Json[string] with function"));

  Json[string] map = ["a": Json(1), "b": Json(2), "c": Json(3)];
  assert(map.hasAnyValues(v => v.isNumber));
  assert(!map.hasAnyValues(v => v.isString));
}
// #endregion hasAny

// #region has
bool hasValue(Json[string] map, Json value) {
  if (map.length == 0) {
    return false;
  }

  foreach (k, v; map) {
    if (v == value) {
      return true;
    }
  }
  return false;
}
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
  * Checks if the given Json value has the specified path.
  *
  * Params:
  *   json = The Json value to check.
  *   path = An array of keys representing the path to check.
  *
  * Returns:
  *   `true` if the Json value has the specified path, `false` otherwise.
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

// #region Json
// #region indices
// #region hasAll
bool hasAllIndices(Json json, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAllIndices(indices, hasFunc) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllIndices with indices and function"));

  auto json = [1, 2, 3].toJson;
  assert(json.hasAllIndices([0, 1], i => i < 3));
  assert(!json.hasAllIndices([0, 3], i => i < 3));
}

bool hasAllIndices(Json json, size_t[] indices) {
  return json.isArray ? indices.all!(i => json.length > i) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllIndices with indices"));

  auto json = [1, 2, 3].toJson;
  assert(json.hasAllIndices([0, 1]));
  assert(!json.hasAllIndices([0, 3]));
}

bool hasAllIndices(Json json, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAllIndices(hasFunc) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllIndices with function"));

  auto json = [1, 2, 3].toJson;
  assert(json.hasAllIndices(i => i < 3));
  assert(!json.hasAllIndices(i => i < 2));
}
// #endregion hasAll

// #region hasAny
bool hasAnyIndices(Json json, size_t[] indices, bool delegate(size_t) @safe hasFunc) {
  return json.isArray ? json.toArray.hasAnyIndices(indices, hasFunc) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyIndices with indices and function"));

  auto json = [1, 2, 3].toJson;
  assert(json.hasAnyIndices([0, 3], i => i < 3));
  assert(!json.hasAnyIndices([3, 4], i => i < 3));
}

bool hasAnyIndices(Json json, size_t[] indices) {
  return json.isArray ? json.toArray.hasAnyIndices(indices) : false;
}

bool hasAnyIndices(Json json, bool delegate(size_t) @safe hasFunc) {
  if (!json.isArray) {
    return false;
  }

  return json.toArray.hasAnyIndices(hasFunc);
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyIndices with function"));

  auto json = [1, 2, 3].toJson;
  assert(json.hasAnyIndices(i => i < 3));
  assert(json.hasAnyIndices(i => i < 2));
  assert(!json.hasAnyIndices(i => i < 0));
}
// #endregion hasAny

// #region has
bool hasIndex(Json json, size_t index) {
  return json.isArray ? json.length > index : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasIndex for Json with index"));

  auto json = [1, 2, 3].toJson;
  assert(json.hasIndex(0));
  assert(json.hasIndex(2));
  assert(!json.hasIndex(3));
}
// #endregion has
// #endregion indices

// #region keys
// #region hasAllKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc)
bool hasAllKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc) {
  if (!json.isObject) {
    return false;
  }

  return json.isObject ? keys.all!(key => json.hasKey(key) && hasFunc(key)) : false;
} /// 
unittest {
  mixin(ShowTest!("Testing hasAllKeys with keys and function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAllKeys(["a", "b"], k => k.length == 1));
  assert(!json.hasAllKeys(["a", "d"], k => k.length == 1));
}
// #endregion hasAllKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc)

// #region hasAllKeys(Json json, string[] keys)
bool hasAllKeys(Json json, string[] keys) {
  return json.isObject ? keys.all!(key => json.hasKey(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllKeys with keys"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAllKeys(["a", "b"]));
  assert(!json.hasAllKeys(["a", "d"]));
}
// #endregion hasAllKeys(Json json, string[] keys)

// #region hasAllKeys(Json json, bool delegate(string) @safe hasFunc)
bool hasAllKeys(Json json, bool delegate(string) @safe hasFunc) {
  return json.isObject ? json.toMap.keys.all!(key => hasFunc(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAllKeys with function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAllKeys(k => k.length == 1));
  assert(!json.hasAllKeys(k => k.length == 2));
}
// #endregion hasAllKeys(Json json, bool delegate(string) @safe hasFunc)

// #region hasAnyKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc)
bool hasAnyKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc) {
  return json.isObject ? keys.any!(key => json.hasKey(key) && hasFunc(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyKeys with keys and function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAnyKeys(["b", "d"], k => k.length == 1));
  assert(!json.hasAnyKeys(["d", "e"], k => k.length == 1));
}
// #endregion hasAnyKeys(Json json, string[] keys, bool delegate(string) @safe hasFunc)

bool hasAnyKeys(Json json, string[] keys) {
  return json.isObject ? keys.any!(key => json.hasKey(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyKeys with keys"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAnyKeys(["b", "d"]));
  assert(!json.hasAnyKeys(["d", "e"]));
}

bool hasAnyKeys(Json json, bool delegate(string) @safe hasFunc) {
  return json.isObject ? json.toMap.keys.any!(key => hasFunc(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyKeys with function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAnyKeys(k => k.length == 1));
  assert(!json.hasAnyKeys(k => k.length == 2));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues with values and function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.hasAllValues([Json(1), Json(2)], v => v.isNumber));
  assert(!json.hasAllValues([Json(1), Json(4)], v => v.isNumber));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues with values"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.isObject && !json.isArray);
  assert(json.hasAllValues([Json(1), Json(2)]));
  assert(!json.hasAllValues([Json(1), Json(4)]));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAllValues with function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.isObject && !json.isArray);
  assert(json.hasAllValues(v => v.isNumber));
  assert(!json.hasAllValues(v => v.isString));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues with values and function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.isObject && !json.isArray);
  assert(json.hasAnyValues([Json(1), Json(4)], v => v.isNumber));
  assert(!json.hasAnyValues([Json(4), Json(5)], v => v.isNumber));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues with values"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.isObject && !json.isArray);
  assert(json.hasAnyValues([Json(1), Json(4)]));
  assert(!json.hasAnyValues([Json(4), Json(5)]));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasAnyValues with function"));

  auto json = ["a": 1, "b": 2, "c": 3].toJson;
  assert(json.isObject && !json.isArray);
  assert(json.hasAnyValues(v => v.isNumber));
  assert(!json.hasAnyValues(v => v.isString));
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
/// 
unittest {
  mixin(ShowTest!("Testing hasValue for Json with value"));

  auto json = ["a": 1, "b": 2, "d": 5].toJson;
  assert(json.isObject && !json.isArray);
  assert(json.hasValue(Json(2)));
  assert(!json.hasValue(Json(6)));
}
// #endregion has
// #endregion values
// #endregion Json
