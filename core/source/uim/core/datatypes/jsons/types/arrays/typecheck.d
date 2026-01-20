/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.arrays.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region all
bool isAllArray(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.isAllArray(indices) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray for Json with indices");

  Json arr = [[1, 2].toJson, "not an array".toJson, [3, 4].toJson].toJson;
  assert(isAllArray(arr, [0, 2]));
  assert(!isAllArray(arr, [0, 1]));
}
// #endregion all

// #region any
bool isAnyArray(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.isArray ? json.toArray.isAnyArray(indices) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray and isAnyArray for Json with indices");

  Json arr = [[1, 2].toJson, "not an array".toJson, [3, 4].toJson].toJson;
  assert(isAllArray(arr, [0, 2]));
  assert(!isAllArray(arr, [0, 1]));
  assert(isAnyArray(arr, [1, 2]));
  assert(!isAnyArray(arr, [3, 4]));
}
// #endregion any

// #region is
bool isArray(Json json, size_t index) {
  mixin(ShowFunction!());

  return json.length > index ? json[index].isArray : false;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json with index");

  Json arr = [[1, 2].toJson, "not an array".toJson, [3, 4].toJson].toJson;
  assert(isAllArray(arr, [0, 2]));
  assert(!isAllArray(arr, [0, 1]));
  assert(isAnyArray(arr, [1, 2]));
  assert(!isAnyArray(arr, [3, 4]));
  assert(isArray(arr, 0));
  assert(!isArray(arr, 1));
  assert(isArray(arr, 2));
}
// #endregion is
// #endregion indices

// #region path
// #region all
bool isAllArray(Json json, string[][] paths) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.isAllArray(paths) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray for Json with paths");

  Json json = parseJsonString(`{"data": { "test1": [ [1, 2], {"a": 1} ], "test2": [3, 4] }}`);

  assert(json.isArray(["data", "test1"]));
  assert(json.isArray(["data", "test2"]));

  assert(json.isAllArray([["data", "test1"], ["data", "test2"]]));
  assert(!json.isAllArray([["data", "test1"], ["data", "nonexistent"]]));
}
// #endregion all

// #region any
bool isAnyArray(Json json, string[][] paths) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.isAnyArray(paths) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray and isAnyArray for Json with paths");

  Json json = parseJsonString(`{"data": { "test1": [ [1, 2], {"a": 1} ], "test2": [3, 4] }}`);
  assert(isAnyArray(json, [["data", "test1"], ["data", "nonexistent"]]));
  assert(!isAnyArray(json, [["data", "nonexistent1"], ["data", "nonexistent2"]]));
}
// #endregion any

// #region is
bool isArray(Json json, string[] path) {
  mixin(ShowFunction!());

  return json.isObject && json.getValue(path).isArray;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json with path");

  Json json = parseJsonString(`{"data": { "test": [ [1, 2], {"a": 1}, [3, 4] ]}}`);
  assert(isArray(json, ["data", "test"]));
  assert(!isArray(json, ["data", "nonexistent"]));
}
// #endregion is
// #endregion path

// #region key
// #region all
bool isAllArray(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.isAllArray(keys) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray for Json with keys");

  Json obj = [
    "a": [1, 2].toJson,
    "b": "not an array".toJson,
    "c": [3, 4].toJson
  ].toJson;

  assert(obj.isAllArray(["a", "c"]));
  assert(!obj.isAllArray(["a", "b"]));
}
// #endregion all

// #region any
bool isAnyArray(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.isObject ? json.toMap.isAnyArray(keys) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json with keys");

  Json obj = [
    "a": [1, 2].toJson,
    "b": "not an array".toJson,
    "c": [3, 4].toJson
  ].toJson;
  assert(obj.isAllArray(["a", "c"]));
  assert(!obj.isAllArray(["a", "b"]));
  assert(isAnyArray(obj, ["b", "c"]));
  assert(!isAnyArray(obj, ["b", "d"]));
}
// #endregion any

// #region is
bool isArray(Json json, string key) {
  mixin(ShowFunction!());

  return json.isObject && json.getValue(key).isArray;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json with key");

  Json obj = [
    "a": [1, 2].toJson,
    "b": "not an array".toJson,
    "c": [3, 4].toJson
  ].toJson;
  assert(isArray(obj, "a"));
  assert(!isArray(obj, "b"));
  assert(isArray(obj, "c"));
}
// #endregion is
// #endregion key

// #region values
// #region all
bool isAllArray(Json json, Json[] values, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.isAllArray(values, isFunc);
  }
  if (json.isObject) {
    return json.toMap.isAllArray(values, isFunc);
  }
  return false;
}

bool isAllArray(Json json, Json[] values) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.isAllArray(values);
  }
  if (json.isObject) {
    return json.toMap.isAllArray(values);
  }
  return false;
}

bool isAllArray(Json json, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.isAllArray(isFunc);
  }
  if (json.isObject) {
    return json.toMap.isAllArray(isFunc);
  }
  return false;
}
// #endregion all

// #region any
bool isAnyArray(Json json, Json[] values, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.isAnyArray(values, isFunc);
  }
  if (json.isObject) {
    return json.toMap.isAnyArray(values, isFunc);
  }
  return false;
}

bool isAnyArray(Json json, Json[] values) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.isAnyArray(values);
  }
  if (json.isObject) {
    return json.toMap.isAnyArray(values);
  }
  return false;
}

bool isAnyArray(Json json, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    return json.toArray.isAnyArray(isFunc);
  }
  if (json.isObject) {
    return json.toMap.isAnyArray(isFunc);
  }
  return false;
}
// #endregion any

// #region is
bool isArray(Json json, Json value) {
  mixin(ShowFunction!());

  return json.toArray.canFind(value);
}
// #endregion is
// #endregion values
// #endregion Json 

// #region Json[string]
// #region paths
// #region all
bool isAllArray(Json[string] map, string[][] paths) {
  mixin(ShowFunction!());

  return map.length > 0 && paths.length > 0
    ? paths.all!(path => map.isArray(path)) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray for Json[string] with paths");

  Json[string] map = [
    "arr1": [1, 2, 3].toJson,
    "obj1": ["key": "value"].toJson,
    "arr2": [4, 5].toJson
  ];

  assert(map.isAllArray([["arr1"], ["arr2"]]));
  assert(!map.isAllArray([["arr1"], ["obj1"]]));
}
// #endregion all

// #region any
bool isAnyArray(Json[string] map, string[][] paths) {
  mixin(ShowFunction!());

  return map.length > 0 && paths.length > 0
    ? paths.any!(path => map.isArray(path)) : false;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray and isAnyArray for Json[string] with paths");

  Json[string] map = [
    "arr1": [1, 2, 3].toJson,
    "obj1": ["key": "value"].toJson,
    "arr2": [4, 5].toJson
  ];

  assert(map.isAnyArray([["obj1"], ["arr2"]]));
  assert(!map.isAnyArray([["nonexistent1"], ["nonexistent2"]]));
}
// #endregion any

// #region is
bool isArray(Json[string] map, string[] path) {
  mixin(ShowFunction!());

  return map.length > 0 && path.length > 0 ? map.getValue(path).isArray : false;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json[string] with path");

  Json[string] map = [
    "arr1": [1, 2, 3].toJson,
    "obj1": ["key": "value"].toJson,
    "arr2": [4, 5].toJson
  ];

  assert(map.isAllArray(["arr1", "arr2"]));
  assert(!map.isAllArray(["arr1", "obj1"]));
  assert(map.isAnyArray(["obj1", "arr2"]));
  assert(!map.isAnyArray(["nonexistent1", "nonexistent2"]));
  assert(map.isArray(["arr1"]));
  assert(!map.isArray(["obj1"]));
}
// #endregion is
// #endregion paths

// #region keys
// #region all
bool isAllArray(Json[string] map, string[] keys = null) {
  mixin(ShowFunction!());

  return keys.length == 0 
    ? map.getValues.all!(value => value.isArray)
    : map.getValues(keys).all!(value => value.isArray);
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray for Json[string] with keys");

  Json[string] map = [
    "arr1": [1, 2, 3].toJson,
    "obj1": ["key": "value"].toJson,
    "arr2": [4, 5].toJson
  ];

  assert(map.isAllArray(["arr1", "arr2"]));
  assert(!map.isAllArray(["arr1", "obj1"]));
}
// #endregion all

// #region any
bool isAnyArray(Json[string] map, string[] keys = null) {
  mixin(ShowFunction!());

  return keys.length == 0 
    ? map.getValues.any!(value => value.isArray)
    : map.getValues(keys).any!(value => value.isArray);
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray and isAnyArray for Json[string] with keys");

  Json[string] map = [
    "arr1": [1, 2, 3].toJson,
    "obj1": ["key": "value"].toJson,
    "arr2": [4, 5].toJson
  ];

  assert(map.isAnyArray(["obj1", "arr2"]));
  assert(!map.isAnyArray(["nonexistent1", "nonexistent2"]));
}
// #endregion any

// #region is
bool isArray(Json[string] map, string key) {
  mixin(ShowFunction!());

  return (key in map) ? map[key].isArray : false;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json[string]");

  Json[string] map = [
    "arr1": [1, 2, 3].toJson,
    "obj1": ["key": "value"].toJson,
    "arr2": [4, 5].toJson
  ];

  assert(map.isArray("arr1"));
  assert(!map.isArray("obj1"));
}
// #endregion is
// #endregion keys

// #region values
// #region all
bool isAllArray(Json[string] map, Json[] values, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return map.getValues.isAllArray(values, isFunc);
}

bool isAllArray(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.getValues.isAllArray(values);
}

bool isAllArray(Json[string] map, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return map.getValues.isAllArray(isFunc);
}
// #endregion all

// #region any
bool isAnyArray(Json[string] map, Json[] values, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return map.getValues.isAnyArray(values, isFunc);
}

bool isAnyArray(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.getValues.isAnyArray(values);
}

bool isAnyArray(Json[string] map, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return map.getValues.isAnyArray(isFunc);
}
// #endregion any

// #region is
bool isArray(Json[string] map, Json value) {
  mixin(ShowFunction!());

  return map.getValues.canFind(value);
}
// #endregion is
// #endregion values
// #endregion Json[string]

// #region Json[]
// #region indices
// #region all
bool isAllArray(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return false;
  }

  bool result = true;
  foreach (index, value; jsons) {
    if (indices.length == 0 || indices.canFind(index)) {
      result = result && value.isArray;
    }
  }
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray for Json[] with indices");

  Json[] jsons = [[1, 2].toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.isAllArray([0, 2]) == true);
  assert(jsons.isAnyArray([1, 2]) == true);
}
// #endregion all

// #region any
bool isAnyArray(Json[] jsons, size_t[] indices = null) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return false;
  }

  bool result = false;
  foreach (index, value; jsons) {
    if (indices.length == 0 || indices.canFind(index)) {
      result = result || value.isArray;
    }
  }
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing isAllArray and isAnyArray for Json[] with indices");

  Json[] jsons = [[1, 2].toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.isAllArray([0, 2]) == true);
  assert(jsons.isAnyArray([1, 2]) == true);
}
// #endregion any

// #region is
bool isArray(Json[] jsons, size_t index) {
  mixin(ShowFunction!());

  return jsons.length > index && jsons[index].isArray;
}
///
unittest {
  mixin(ShowTest!"Testing isArray for Json[]");

  Json[] jsons = [[1, 2].toJson, ["a": 1].toJson, [3, 4].toJson];
  assert(jsons.isAllArray == false);
  assert(jsons.isAnyArray == true);
  assert(jsons.isAllArray([0, 2]) == true);
  assert(jsons.isAnyArray([1, 2]) == true);
  assert(jsons.isArray(0) == true);
  assert(jsons.isArray(1) == false);
}
// #endregion is
// #endregion indices

// #region values
// #region all
bool isAllArray(Json[] jsons, Json[] values, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return jsons.isAllArray((Json value) => values.canFind(value) && isFunc(value));
}

bool isAllArray(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.isAllArray((Json value) => values.canFind(value));
}

bool isAllArray(Json[] jsons, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return jsons.length == 0 ? false : jsons.all!(value => value.isArray && isFunc(value));
}

bool isAllArray(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.length == 0 ? false : jsons.all!(value => value.isArray);
}
// #endregion all

// #region any
bool isAnyArray(Json[] jsons, Json[] values, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  return jsons.length == 0 ? false : jsons.any!(value => value.isArray);
}

bool isAnyArray(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return false;
  }

  return jsons.filter!(value => values.canFind(value))
    .any!(value => value.isArray);
}

bool isAnyArray(Json[] jsons, bool delegate(Json) @safe isFunc) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return false;
  }

  return jsons.any!(value => value.isArray && isFunc(value));
}

bool isAnyArray(Json[] jsons) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return false;
  }

  return jsons.any!(value => value.isArray);
}
// #endregion any

// #region is
bool isArray(Json[] jsons, Json value) {
  mixin(ShowFunction!());

  return jsons.canFind(value);
}
// #endregion is
// #endregion values
// #endregion Json[]

// #region base
bool isArray(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons is null ? false : true;
}

bool isArray(Json[string] map) {
  mixin(ShowFunction!());

  return false;
}

bool isArray(Json json) {
  mixin(ShowFunction!());

  return (json.type == Json.Type.array);
}
// #endregion base
