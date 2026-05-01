module uim.core.datatypes.jsons.types.objects.get;

import uim.core;

mixin(ShowModule!());

@safe:

// #region getObject(Json, string)
/**
  * Retrieves the Json value associated with the specified key in the Json object if it is an object, otherwise returns the default value.
  *
  * Params:
  *   json = The Json object to retrieve from.
  *   key = The key of the Json value to retrieve.
  *   defaultValue = The value to return if the retrieved Json value is not an object (default is null).
  *
  * Returns:
  *   The Json value associated with the specified key if it is an object, otherwise the default value.
  */
Json[string] getObject(Json json, string key, Json[string] defaultValue = null) {
  return json.getValue(key).isObject ? json.getValue(key).toMap : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json with key");

  Json json = parseJsonString(`{"first": {"a":1}, "second": [1,2], "third": {"b":2}}`);
  assert(json.getObject("first") == ["a":1.toJson]);
  assert(json.getObject("second", null) == null);
  assert(json.getObject("third") == ["b":2.toJson]);
}
// #endregion getObject(Json, string)
  
// #region getObject(Json, size_t)
/** 
  * Retrieves the Json value at the specified index in the Json array if it is an object, otherwise returns the default value.
  *
  * Params:
  *   json = The Json array to retrieve from.
  *   index = The index of the Json value to retrieve.
  *   defaultValue = The value to return if the retrieved Json value is not an object (default is an empty object).
  *
  * Returns:
  *   The Json value at the specified index if it is an object, otherwise the default value.
  */
Json[string] getObject(Json json, size_t index, Json[string] defaultValue = null) {
  return json[index].isObject ? json.getValue(index).toMap : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json with index");

  Json json = [ ["a":1].toJson, [1,2].toJson, ["b":2].toJson ].toJson;
  assert(json.getObject(0) == ["a":1.toJson]);
  assert(json.getObject(1, null) == null);
  assert(json.getObject(2) == ["b":2.toJson]);}

Json[string] getObject(Json json, string[] path, Json[string] defaultValue = null) {
  return json.getValue(path).isObject ? json.getValue(path).toMap : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json with path");

  Json json = parseJsonString(`{"first": {"a":1}, "second": [1,2], "third": {"b":2}}`);
  assert(json.getObject(["first"]) == ["a":1.toJson]);
  assert(json.getObject(["second"], null) == null);
  assert(json.getObject(["third"]) == ["b":2.toJson]);
}

// #endregion Json

// #region Json[]
Json[string] getObject(Json[] jsons, size_t index, Json[string] defaultValue = null) {
  return jsons.getValue(index).isObject() ? jsons[index].toMap : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json[] with index");

  Json[] jsons = [ ["a":1].toJson, [1,2].toJson, ["b":2].toJson ];
  assert(jsons.getObject(0) == ["a":1.toJson]);
  assert(jsons.getObject(1, null) == null);
  assert(jsons.getObject(2) == ["b":2.toJson]);
}
// #endregion Json[]

// #region Json[string]
Json[string] getObject(Json[string] map, string[] path, Json[string] defaultValue = null) {
  return map.getValue(path).isObject ? map.getValue(path).toMap : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json[string] with path");

  Json[string] map = [
    "first": ["a":1].toJson, "second": [1,2].toJson, "third": ["b":2].toJson
  ];
  assert(map.getObject("first") == ["a":1.toJson]);
  assert(map.getObject("second", null) == null);
  assert(map.getObject("third") == ["b":2.toJson]);
}

Json[string] getObject(Json[string] map, string key, Json[string] defaultValue = null)   {
  return map.getValue(key).isObject ? map.getValue(key).toMap : defaultValue;
}
/// 
unittest {
  mixin(ShowTest!"Testing getObject for Json[string] with key");

  Json[string] map = [
    "first": ["a":1].toJson, "second": [1,2].toJson, "third": ["b":2].toJson
  ];
  assert(map.getObject("first") == ["a":1.toJson]);
  assert(map.getObject("second", ["x":100.toJson]) == ["x":100.toJson]);
  assert(map.getObject("third") == ["b":2.toJson]);
}
// #endregion Json[string]

