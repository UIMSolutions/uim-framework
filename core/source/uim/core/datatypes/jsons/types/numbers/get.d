module uim.core.datatypes.jsons.types.numbers.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
Json getNumber(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  return jsons.getValue(index).isNumber() ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getNumber for Json[] with index");

  Json[] jsons = [123.toJson, 1.23.toJson, ["a":1].toJson];
  assert(jsons.getNumber(0) == 123.toJson);
  assert(jsons.getNumber(1) == 1.23.toJson);
  assert(jsons.getNumber(2) == Json(null));
}
// #endregion Json[]

// #region Json[string]
Json getNumber(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  return map.getValue(path).isNumber ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getNumber for Json[string] with path");

  Json[string] map = [
    "first": 123.toJson, "second": 1.23.toJson, "third": ["a":1].toJson
  ];
  assert(map.getNumber("first") == 123.toJson);
  assert(map.getNumber("second") == 1.23.toJson);
  assert(map.getNumber("third") == Json(null));
}

Json getNumber(Json[string] map, string key, Json defaultValue = Json(null)) {
  return map.getValue(key).isNumber ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getNumber for Json[string] with key");

  Json[string] map = [
    "first": 123.toJson, "second": 1.23.toJson, "third": ["a":1].toJson
  ];
  assert(map.getNumber("first") == 123.toJson);
  assert(map.getNumber("second") == 1.23.toJson);
  assert(map.getNumber("third") == Json(null));
}
// #endregion Json[string]

// #region Json
Json getNumber(Json json, size_t index, Json defaultValue = Json(null)) {
  return json.isNumber(index) ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getNumber for Json with index");

  Json json = [123.toJson, 1.23.toJson, ["a":1].toJson].toJson;
  assert(json.getNumber(0) == 123.toJson);
  assert(json.getNumber(1) == 1.23.toJson);
  assert(json.getNumber(2) == Json(null));
}

Json getNumber(Json json, string[] path, Json defaultValue = Json(null)) {
  return json.isNumber(path) ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getNumber for Json with path");

  Json json = parseJsonString(`{"first": 123, "second": 1.23, "third": {"a":1}}`);
  assert(json.getNumber("first") == 123.toJson);
  assert(json.getNumber("second") == 1.23.toJson);
  assert(json.getNumber("third") == Json(null));
}

Json getNumber(Json json, string key, Json defaultValue = Json(null)) {
  return json.isNumber(key) ? json.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getNumber for Json with key");

  Json json = parseJsonString(`{"first": 123, "second": 1.23, "third": {"a":1}}`);
  assert(json.getNumber("first") == 123.toJson);
  assert(json.getNumber("second") == 1.23.toJson);
  assert(json.getNumber("third") == Json(null));
}
// #endregion Json
