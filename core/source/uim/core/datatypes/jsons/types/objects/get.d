module uim.core.datatypes.jsons.types.objects.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
Json getObject(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  return jsons.getValue(index).isObject() ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json[] with index");

  Json[] jsons = [ ["a":1].toJson, [1,2].toJson, ["b":2].toJson ];
  assert(jsons.getObject(0) == ["a":1].toJson);
  assert(jsons.getObject(1, Json("default")) == Json("default"));
  assert(jsons.getObject(2) == ["b":2].toJson);
}
// #endregion Json[]

// #region Json[string]
Json getObject(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  return map.getValue(path).isObject ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json[string] with path");

  Json[string] map = [
    "first": ["a":1].toJson, "second": [1,2].toJson, "third": ["b":2].toJson
  ];
  assert(map.getObject("first") == ["a":1].toJson);
  assert(map.getObject("second", Json("default")) == Json("default"));
  assert(map.getObject("third") == ["b":2].toJson);
}

Json getObject(Json[string] map, string key, Json defaultValue = Json(null)) {
  return map.getValue(key).isObject ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json[string] with key");

  Json[string] map = [
    "first": ["a":1].toJson, "second": [1,2].toJson, "third": ["b":2].toJson
  ];
  assert(map.getObject("first") == ["a":1].toJson);
  assert(map.getObject("second", Json("default")) == Json("default"));
  assert(map.getObject("third") == ["b":2].toJson);
}
// #endregion Json[string]

// #region Json
Json getObject(Json json, size_t index, Json defaultValue = Json(null)) {
  return json[index].isObject ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json with index");

  Json json = [ ["a":1].toJson, [1,2].toJson, ["b":2].toJson ].toJson;
  assert(json.getObject(0) == ["a":1].toJson);
  assert(json.getObject(1, Json("default")) == Json("default"));
  assert(json.getObject(2) == ["b":2].toJson);
}

Json getObject(Json json, string[] path, Json defaultValue = Json(null)) {
  return json.getValue(path).isObject ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json with path");

  Json json = parseJsonString(`{"first": {"a":1}, "second": [1,2], "third": {"b":2}}`);
  assert(json.getObject("first") == ["a":1].toJson);
  assert(json.getObject("second", Json("default")) == Json("default"));
  assert(json.getObject("third") == ["b":2].toJson);
}

Json getObject(Json json, string key, Json defaultValue = Json(null)) {
  return json.getValue(key).isObject ? json.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json with key");

  Json json = parseJsonString(`{"first": {"a":1}, "second": [1,2], "third": {"b":2}}`);
  assert(json.getObject("first") == ["a":1].toJson);
  assert(json.getObject("second", Json("default")) == Json("default"));
  assert(json.getObject("third") == ["b":2].toJson);
}
// #endregion Json
