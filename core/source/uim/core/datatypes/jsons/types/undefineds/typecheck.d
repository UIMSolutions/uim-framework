/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.undefineds.typecheck;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
bool isAllUndefined(Json[] jsons, size_t[] indices = null) {
  if (jsons.length == 0) return false;

  return indices.length == 0
    ? jsons.length > 0 && jsons.all!(value => value.isUndefined)
    : indices.all!(index => jsons.isUndefined(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllUndefined for Json[]");
    
  Json[] jsons = [Json.undefined, Json.undefined, Json.undefined];
  assert(isAllUndefined(jsons));
  assert(isAllUndefined(jsons, [0, 1]));
  assert(!isAllUndefined(jsons, [0, 1, 2, 3]));
  
  jsons = [Json.undefined, Json(5), Json.undefined];
  assert(!isAllUndefined(jsons));
  assert(!isAllUndefined(jsons, [0, 1]));
  assert(isAllUndefined(jsons, [0, 2]));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyUndefined for Json[]");
    
  Json[] jsons = [Json(1), Json(2), Json(3)];
  assert(!isAnyUndefined(jsons));
  assert(!isAnyUndefined(jsons, [0, 1]));
  
  jsons = [Json(1), Json.undefined, Json(3)];
  assert(isAnyUndefined(jsons));
  assert(isAnyUndefined(jsons, [0, 1]));
  assert(!isAnyUndefined(jsons, [0]));
}

bool isAnyUndefined(Json[] jsons, size_t[] indices = null) {
  if (jsons.length == 0) return false;

  return indices.length == 0
    ? jsons.length > 0 && jsons.any!(value => value.isUndefined)
    : indices.any!(index => jsons.isUndefined(index));
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json[]");
    
  Json[] jsons = [Json(1), Json.undefined, Json(3)];
  assert(isUndefined(jsons, 1));
  assert(!isUndefined(jsons, 0));
  assert(!isUndefined(jsons, 3));
}

bool isUndefined(Json[] jsons, size_t index) {
  if (jsons.length <= index) return false;

  return jsons.getValue(index).isUndefined;
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json[]");

  Json[] jsons = [Json(1), Json.undefined, Json(3)];
  assert(isUndefined(jsons, 1));
  assert(!isUndefined(jsons, 0));
  assert(!isUndefined(jsons, 3));
}
// #endregion Json[]

// #region Json[string]
bool isAllUndefined(Json[string] map, string[] keys = null) {
  if (map.length == 0) return false;

  return keys.length > 0 
    ? keys.all!(key => map.getValue(key).isUndefined) 
    : map.getValues.all!(value => value.isUndefined);
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllUndefined for Json[string]");
    
  Json[string] map = [
    "a": Json.undefined,
    "b": Json.undefined,
    "c": Json.undefined
  ];
  assert(isAllUndefined(map));
  assert(isAllUndefined(map, ["a", "b"]));
  assert(!isAllUndefined(map, ["a", "b", "c", "d"]));
  
  map = [
    "a": Json.undefined,
    "b": Json(5),
    "c": Json.undefined
  ];
  assert(!isAllUndefined(map));
  assert(!isAllUndefined(map, ["a", "b"]));
  assert(isAllUndefined(map, ["a", "c"]));
}

bool isAnyUndefined(Json[string] map, string[] keys = null) {
  if (map.length == 0) return false;

  return keys.length > 0 
    ? keys.any!(key => map.getValue(key).isUndefined) 
    : map.getValues.any!(value => value.isUndefined);
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyUndefined for Json[string]");
    
  Json[string] map = [
    "a": Json(1),
    "b": Json(2),
    "c": Json(3)
  ];
  assert(!isAnyUndefined(map));
  assert(!isAnyUndefined(map, ["a", "b"]));
  
  map = [
    "a": Json(1),
    "b": Json.undefined,
    "c": Json(3)
  ];
  assert(isAnyUndefined(map));
  assert(isAnyUndefined(map, ["a", "b"]));
  assert(!isAnyUndefined(map, ["a"]));
}

bool isUndefined(Json[string] map, string key) {
  return map.getValue(key).isUndefined;
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json[string]");
    
  Json[string] map = [
    "a": Json(1),
    "b": Json.undefined,
    "c": Json(3)
  ];
  assert(isUndefined(map, "b"));
  assert(!isUndefined(map, "a"));
  assert(!isUndefined(map, "d"));
}
// #endregion Json[string]

// #region Json
// #region path
bool isAllUndefined(Json json, string[][] paths) {
  if (!json.isObject) return false;

  return paths.all!(path => json.isUndefined(path));
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllUndefined for Json with paths");
    
  Json json = parseJsonString(`{"a": "undefined", "b": {"c": "undefined"}}`);
  json["a"] = Json.undefined;
  json["b"]["c"] = Json.undefined;

  /* No longer valid since Json(undefined) is not possible */
}

bool isAnyUndefined(Json json, string[][] paths) {
  return json.isUndefined && paths.length > 0
    ? paths.any!(path => json.isUndefined(path)) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyUndefined for Json with paths");
    
  Json json = [
    "a": Json(1),
    "b": [
      "c": Json.undefined
    ].toJson
  ].toJson;

  /* No longer valid since Json(undefined) is not possible */
}

bool isUndefined(Json json, string[] path) {
  return json.isObject && json.getValue(path).isUndefined;
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json with path");
    
  Json json = [
    "a": Json(1),
    "b": [
      "c": Json.undefined
    ].toJson
  ].toJson;

  /* No longer valid since Json(undefined) is not possible */

}
// #endregion path

// #region key
bool isAllUndefined(Json json, string[] keys) {
  if (!json.isObject) return false;
  if (keys.length == 0) return false;

  return json.isUndefined && keys.length > 0
    ? keys.all!(key => json.isUndefined(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllUndefined for Json with keys");

  Json json = [
    "a": Json.undefined,
    "b": Json.undefined,
    "c": Json(3)
  ].toJson;

  /* No longer valid since Json(undefined) is not possible */

}

bool isAnyUndefined(Json json, string[] keys) {
  if (!json.isObject) return false;
  if (keys.length == 0) return false;

  return json.isUndefined && keys.length > 0
    ? keys.any!(key => json.isUndefined(key)) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyUndefined for Json with keys");

  Json json = [
    "a": Json(1),
    "b": Json.undefined,
    "c": Json(3)
  ].toJson;

  /* No longer valid since Json(undefined) is not possible */

}

bool isUndefined(Json json, string key) {
  if (!json.isObject) return false;
  if (!json.hasKey(key)) return false;

  return json.getValue(key).isUndefined;
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json with key");

  Json json = [
    "a": Json(1),
    "b": Json.undefined,
    "c": Json(3)
  ].toJson;

  /* No longer valid since Json(undefined) is not possible */

}
// #region key

// #region index
bool isAllUndefined(Json json, size_t[] indices) {
  if (!json.isArray || indices.length == 0) return false;

  return json.isUndefined && indices.length > 0
    ? indices.all!(index => json.isUndefined(index)) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAllUndefined for Json with indices");
    
  Json json = [Json.undefined, Json.undefined, Json(3)].toJson;

  /* No longer valid since Json(undefined) is not possible */

}

bool isAnyUndefined(Json json, size_t[] indices) {
  if (!json.isArray || indices.length == 0) return false;

  return json.isUndefined && indices.length > 0
    ? indices.any!(index => json.isUndefined(index)) : false;
}
/// 
unittest {
  mixin(ShowTest!"Testing isAnyUndefined for Json with indices");
    
  /* No longer valid since Json(undefined) is not possible */
}


bool isUndefined(Json json, size_t index) {
  if (!json.isArray) return false;
  if (json.length <= index) return false;

  return json.getValue(index).isUndefined;
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json with index");
    
  /* No longer valid since Json(undefined) is not possible */
}

// #endregion index

bool isUndefined(Json json) {
  return json.type == Json.Type.undefined; 
}
/// 
unittest {
  mixin(ShowTest!"Testing isUndefined for Json");

  /* No longer valid since Json(undefined) is not possible */
}

// #endregion Json