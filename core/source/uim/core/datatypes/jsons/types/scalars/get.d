module uim.core.datatypes.jsons.types.scalars.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json[]
Json getScalar(Json[] jsons, size_t index, Json defaultValue = Json(null)) {
  return jsons.getValue(index).isScalar() ? jsons[index] : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getScalar for Json[] with index");

  Json[] jsons = [123.toJson, 1.23.toJson, ["a":1].toJson];
  assert(jsons.getScalar(0) == 123.toJson);
  assert(jsons.getScalar(1) == 1.23.toJson);
  assert(jsons.getScalar(2) == Json(null));
}
// #endregion Json[]

// #region Json[string]
Json getScalar(Json[string] map, string[] path, Json defaultValue = Json(null)) {
  return map.getValue(path).isScalar ? map.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getScalar for Json[string] with path");

  Json[string] map = [
    "first": 123.toJson, "second": 1.23.toJson, "third": ["a":1].toJson
  ];
  assert(map.getScalar("first") == 123.toJson);
  assert(map.getScalar("second") == 1.23.toJson);
  assert(map.getScalar("third") == Json(null));
}

Json getScalar(Json[string] map, string key, Json defaultValue = Json(null)) {
  return map.getValue(key).isScalar ? map.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getScalar for Json[string] with key");

  Json[string] map = [
    "first": 123.toJson, "second": 1.23.toJson, "third": ["a":1].toJson
  ];
  assert(map.getScalar("first") == 123.toJson);
  assert(map.getScalar("second") == 1.23.toJson);
  assert(map.getScalar("third") == Json(null));
}
// #endregion Json[string]

// #region Json
Json getScalar(Json json, size_t index, Json defaultValue = Json(null)) {
  return json.isScalar(index) ? json.getValue(index) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getScalar for Json with index");

  Json json = [123.toJson, 1.23.toJson, ["a":1].toJson].toJson;
  assert(json.getScalar(0) == 123.toJson);
  assert(json.getScalar(1) == 1.23.toJson);
  assert(json.getScalar(2) == Json(null));
}

Json getScalar(Json json, string[] path, Json defaultValue = Json(null)) {
  return json.isScalar(path) ? json.getValue(path) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getScalar for Json with path");

  Json json = parseJsonString(`{"first": 123, "second": 1.23, "third": {"a":1}}`);
  assert(json.getScalar("first") == 123.toJson);
  assert(json.getScalar("second") == 1.23.toJson);
  assert(json.getScalar("third") == Json(null));
}

Json getScalar(Json json, string key, Json defaultValue = Json(null)) {
  return json.isScalar(key) ? json.getValue(key) : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getScalar for Json with key");

  Json json = parseJsonString(`{"first": 123, "second": 1.23, "third": {"a":1}}`);
  assert(json.getScalar("first") == 123.toJson);
  assert(json.getScalar("second") == 1.23.toJson);
  assert(json.getScalar("third") == Json(null));
}
// #endregion Json
