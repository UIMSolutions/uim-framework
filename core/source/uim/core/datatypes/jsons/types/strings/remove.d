/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.strings.remove;

import uim.core;

mixin(ShowModule!());

@safe:
 
// #region Json[]
// #region indices
Json[] removeStrings(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return jsons.removeIndices(indices, (size_t index) => jsons[index].isString && removeFunc(index));
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];
  size_t[] indices = [0, 2, 4];

  Json[] result = removeStrings(jsons, indices, (size_t index) => true);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));
  assert(result[2] == Json(null));

  result = removeStrings(jsons, indices, (size_t index) => false);
  assert(result.length == 5);

  result = removeStrings(jsons, indices, (size_t index) => index == 2);
  assert(result.length == 4);
  assert(result[0] == Json("string"));
  assert(result[1] == Json(123));
  assert(result[2] == Json(true));  
  assert(result[3] == Json(null));
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons, size_t[] indices)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];
  size_t[] indices = [0, 2, 4];

  Json[] result = removeStrings(jsons, indices);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));  
  assert(result[2] == Json(null));
}

Json[] removeStrings(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  return jsons.removeIndices(indices, (index) => jsons[index].isString);
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons, bool delegate(size_t) @safe removeFunc)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];

  Json[] result = removeStrings(jsons, (size_t index) => true);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));
  assert(result[2] == Json(null));

  result = removeStrings(jsons, (size_t index) => false);
  assert(result.length == 5);

  result = removeStrings(jsons, (size_t index) => index == 2);
  assert(result.length == 4);
  assert(result[0] == "string".toJson);
  assert(result[1] == Json(123));
  assert(result[2] == Json(true));  
  assert(result[3] == Json(null));
}

Json[] removeStrings(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeIndices((size_t index) => jsons[index].isString && removeFunc(index));
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];

  Json[] result = removeStrings(jsons);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));  
  assert(result[2] == Json(null));
}
// #endregion indices

// #region values
Json[] removeStrings(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isString && removeFunc(json));
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];
  Json[] values = ["string".toJson, Json(null)];

  Json[] result = removeStrings(jsons, values, (Json json) => true);
  assert(result.length == 4);
  assert(result[0] == Json(123));
  assert(result[1] == "another string".toJson);
  assert(result[2] == Json(true));
  assert(result[3] == Json(null));

  result = removeStrings(jsons, values, (Json json) => false);
  assert(result.length == 5);

  result = removeStrings(jsons, values, (Json json) => json == "another string".toJson);
  assert(result.length == 5);
}

Json[] removeStrings(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues(values, (Json json) => json.isString);
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons, bool delegate(Json) @safe removeFunc)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];

  Json[] result = removeStrings(jsons, (Json json) => true);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));
  assert(result[2] == Json(null));

  result = removeStrings(jsons, (Json json) => false);
  assert(result.length == 5);

  result = removeStrings(jsons, (Json json) => json == "another string".toJson);
  assert(result.length == 4);
  assert(result[0] == "string".toJson);
  assert(result[1] == Json(123));
  assert(result[2] == Json(true));  
}

Json[] removeStrings(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isString && removeFunc(json));
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];

  Json[] result = removeStrings(jsons);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));  
}
// #endregion values

// #region base
Json[] removeStrings(Json[] jsons) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json json) => json.isString);
}
///
unittest {
  mixin(ShowTest!("Json[] removeStrings(Json[] jsons)"));

  Json[] jsons = ["string".toJson, Json(123), "another string".toJson, Json(true), Json(null)];

  Json[] result = removeStrings(jsons);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));  
}
// #endregion base
// #endregion Json[]

// #region Json[string]
// #region keys
Json[string] removeStrings(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeStrings((string key) => map[key].isString && keys.canFind(key) && removeFunc(key));
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];
  string[] keys = ["first", "third"];

  Json[string] result = removeStrings(map, keys, (string key) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));

  result = removeStrings(map, keys, (string key) => false);
  assert(result.length == 4);

  result = removeStrings(map, keys, (string key) => key == "third");
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

Json[string] removeStrings(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  return map.removeKeys(keys, (string key) => map.getValue(key).isString);
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map, string[] keys)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];
  string[] keys = ["first", "third"]; 
  Json[string] result = removeStrings(map, keys);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

Json[string] removeStrings(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeKeys((string key) => map[key].isString && removeFunc(key));
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map, bool delegate(string) @safe removeFunc)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];

  Json[string] result = removeStrings(map, (string key) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));

  result = removeStrings(map, (string key) => false);
  assert(result.length == 4);

  result = removeStrings(map, (string key) => key == "third");
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}
// #endregion keys

// #region values
Json[string] removeStrings(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isString && removeFunc(json));
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];
  Json[] values = [Json("string1"), Json("string2")];

  Json[string] result = removeStrings(map, values, (Json json) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));

  result = removeStrings(map, values, (Json json) => false);
  assert(result.length == 4);

  result = removeStrings(map, values, (Json json) => json == Json("string2"));
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

Json[string] removeStrings(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  return map.removeValues(values, (Json json) => json.isString);
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map, Json[] values)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];
  Json[] values = [Json("string1"), Json("string2")];
  Json[string] result = removeStrings(map, values);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

Json[string] removeStrings(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isString && removeFunc(json));
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map, bool delegate(Json) @safe removeFunc)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];

  Json[string] result = removeStrings(map, (Json json) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));

  result = removeStrings(map, (Json json) => false);
  assert(result.length == 4);

  result = removeStrings(map, (Json json) => json == Json("string2"));
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

// #endregion values

// #region base
Json[string] removeStrings(Json[string] map) {
  mixin(ShowFunction!());
  
  return map.removeValues((Json json) => json.isString);
}
///
unittest {
  mixin(ShowTest!("Json[string] removeStrings(Json[string] map)"));

  Json[string] map = ["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)];
  Json[string] result = removeStrings(map);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}
// #endregion base
// #endregion Json[string]

// #region Json
// #region indices
Json removeStrings(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices(indices, (size_t index) => json.getValue(index)
      .isString && removeFunc(index));
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc)"));

  Json json = Json([Json("string1"), Json(123), Json("string2"), Json(true), Json(null)]);
  size_t[] indices = [0, 2, 4];

  Json result = removeStrings(json, indices, (size_t index) => true);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));

  result = removeStrings(json, indices, (size_t index) => false);
  assert(result.length == 5);

  result = removeStrings(json, indices, (size_t index) => index == 2);
  assert(result.length == 4);
  assert(result[0] == Json("string1"));
  assert(result[1] == Json(123));
  assert(result[2] == Json(true));  
}

Json removeStrings(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  return json.removeIndices(indices, (size_t index) => json[index].isString);
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, size_t[] indices)"));

  Json json = Json([Json("string1"), Json(123), Json("string2"), Json(true), Json(null)]);
  size_t[] indices = [0, 2, 4];

  Json result = removeStrings(json, indices);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));  
}

Json removeStrings(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeIndices((size_t index) => json.getValue(index).isString && removeFunc(index));
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, bool delegate(size_t) @safe removeFunc)"));

  Json json = Json([Json("string1"), Json(123), Json("string2"), Json(true), Json(null)]);

  Json result = removeStrings(json, (size_t index) => true);
  assert(result.length == 3);
  assert(result[0] == Json(123));
  assert(result[1] == Json(true));

  result = removeStrings(json, (size_t index) => false);
  assert(result.length == 5);

  result = removeStrings(json, (size_t index) => index == 2);
  assert(result.length == 4);
  assert(result[0] == Json("string1"));
  assert(result[1] == Json(123));
  assert(result[2] == Json(true));  
}
// #endregion indices

// #region keys
Json removeStrings(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys(keys, (string key) => json[key].isString && removeFunc(key));
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, string[] keys, bool delegate(string) @safe removeFunc)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);
  string[] keys = ["first", "third"];

  Json result = removeStrings(json, keys, (string key) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));

  result = removeStrings(json, keys, (string key) => false);
  assert(result.length == 4);

  result = removeStrings(json, keys, (string key) => key == "third");
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

Json removeStrings(Json json, string[] keys) {
  mixin(ShowFunction!());

  return json.removeKeys(keys, (string key) => json.getValue(key).isString);
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, string[] keys)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);
  string[] keys = ["first", "third"]; 
  Json result = removeStrings(json, keys);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));
}

Json removeStrings(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());
  
  return json.removeKeys((string key) => json.getValue(key).isString && removeFunc(key));
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, bool delegate(string) @safe removeFunc)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);  
  Json result = removeStrings(json, (string key) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123), "Expected 123");
  assert(result["fourth"] == Json(true), "Expected true");

  result = removeStrings(json, (string key) => false);
  assert(result.length == 4);

  result = removeStrings(json, (string key) => key == "third");
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}
// #endregion keys

// #region values
Json removeStrings(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isString && removeFunc(j));
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, Json[] values, bool delegate(Json) @safe removeFunc)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);
  Json[] values = [Json("string1"), Json("string2")];

  Json result = removeStrings(json, values, (Json j) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));

  result = removeStrings(json, values, (Json j) => false);
  assert(result.length == 4);

  result = removeStrings(json, values, (Json j) => j == Json("string2"));
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}

Json removeStrings(Json json, Json[] values) {
  mixin(ShowFunction!());

  return json.removeValues(values, (Json j) => j.isString);
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, Json[] values)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);
  Json[] values = [Json("string1"), Json("string2")];
  Json result = removeStrings(json, values);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
} 

Json removeStrings(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isString && removeFunc(j));
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json, bool delegate(Json) @safe removeFunc)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);  
  Json result = removeStrings(json, (Json j) => true);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true)); 
  result = removeStrings(json, (Json j) => false);
  assert(result.length == 4);
  result = removeStrings(json, (Json j) => j == Json("string2"));
  assert(result.length == 3);
  assert(result["first"] == Json("string1"));
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}
// #endregion values

// #region base
Json removeStrings(Json json) {
  mixin(ShowFunction!());

  return json.removeValues((Json j) => j.isString);
}
///
unittest {
  mixin(ShowTest!("Json removeStrings(Json json)"));

  Json json = Json(["first": Json("string1"), "second": Json(123), "third": Json("string2"), "fourth": Json(true)]);  
  Json result = removeStrings(json);
  assert(result.length == 2);
  assert(result["second"] == Json(123));
  assert(result["fourth"] == Json(true));  
}
// #endregion base
// #endregion Json


