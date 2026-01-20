/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.remove;

import uim.core;

mixin(ShowModule!());

@safe:

// #region Json
// #region indices
// #region indices with func
Json removeIndices(Json json, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  if (!json.isArray || indices.length == 0) {
    return json;
  }

  Json result = Json.emptyArray;
  foreach (index, value; json.toArray) {
    if (!indices.canFind(index) || !removeFunc(index)) {
      result ~= value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeIndices with indices and func");

  Json json = parseJsonString(`[
    "apple",
    "banana",
    "cherry",
    "date",
    "elderberry"
  ]`);

  auto result = removeIndices(json, [1, 3], (size_t index) @safe => index == 3);
  assert(result.length == 4);
  assert(result[0] == Json("apple"));
  assert(result[1] == Json("banana"));
  assert(result[2] == Json("cherry"));
  assert(result[3] == Json("elderberry"));
}
// #endregion indices with func

// #region indices
Json removeIndices(Json json, size_t[] indices) {
  mixin(ShowFunction!());

  if (!json.isArray || indices.length == 0) {
    return json;
  }

  Json result = Json.emptyArray;
  foreach (index, value; json.toArray) {
    if (!indices.canFind(index)) {
      result ~= value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeIndices with indices");

  Json json = parseJsonString(`[
    "apple",
    "banana",
    "cherry",
    "date",
    "elderberry"
  ]`);

  auto result = removeIndices(json, [1, 3]);
  assert(result.length == 3);
  assert(result[0] == Json("apple"));
  assert(result[1] == Json("cherry"));
  assert(result[2] == Json("elderberry"));
}
// #endregion indices

// #region func
Json removeIndices(Json json, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  if (!json.isArray) {
    return json;
  }

  Json result = Json.emptyArray;
  foreach (index, value; json.toArray) {
    if (!removeFunc(index)) {
      result ~= value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeIndices with func");

  Json json = parseJsonString(`[
    "apple",
    "banana",
    "cherry",
    "date",
    "elderberry"
  ]`);

  auto result = removeIndices(json, (size_t index) @safe => index == 1 || index == 3);
  assert(result.length == 3);
  assert(result[0] == "apple");
  assert(result[1] == "cherry");
  assert(result[2] == "elderberry");
}
// #endregion func
// #endregion indices

// #region paths
Json removePaths(Json json, string[][] paths, bool delegate(string[] path) @safe removeFunc) {
  mixin(ShowFunction!()); 

  // TODO: Implement 
  return Json(null);
}

Json removePaths(Json map, string[][] paths) {
  mixin(ShowFunction!()); 

  // TODO: Implement 
  return Json(null);
}
// #endregion paths

// #region keys
// #region keys with func
Json removeKeys(Json json, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  if (!json.isObject || keys.length == 0) {
    return json;
  }

  Json result = Json.emptyObject;
  foreach (key, value; json.toMap) {
    if (!keys.canFind(key) || !removeFunc(key)) {
      result[key] = value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeKeys with keys and func");

  Json json = parseJsonString(`{
    "name": "John",
    "age": 30,
    "city": "New York",
    "country": "USA"
  }`);

  auto result = json.removeKeys(["age", "city"], (string key) @safe => key == "city");
  assert(result.length == 3);
  assert(result["name"] == "John");
  assert(result["age"] == 30);
  assert(result["country"] == "USA");
}
// #endregion keys with func

// #region keys
Json removeKeys(Json json, string[] keys) {
  mixin(ShowFunction!());

  if (!json.isObject || keys.length == 0) {
    return json;
  }

  Json result = Json.emptyObject;
  foreach (key, value; json.toMap) {
    if (!keys.canFind(key)) {
      result[key] = value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeKeys with keys");

  Json json = parseJsonString(`{
    "name": "John",
    "age": 30,
    "city": "New York",
    "country": "USA"
  }`);

  auto result = json.removeKeys(["age", "city"]);
  assert(result.length == 2);
  assert(result["name"] == "John");
  assert(result["country"] == "USA");
}
// #endregion keys

// #region func(key)
Json removeKeys(Json json, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  if (!json.isObject) {
    return json;
  }

  Json result = Json.emptyObject;
  foreach (key, value; json.toMap) {
    if (!removeFunc(key)) {
      result[key] = value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeKeys with func");

  Json json = parseJsonString(`{
    "name": "John",
    "age": 30,
    "city": "New York",
    "country": "USA"
  }`);

  auto result = json.removeKeys((string key) @safe => key == "age" || key == "city");
  assert(result.length == 2);
  assert(result["name"] == "John");
  assert(result["country"] == "USA");
}
// #endregion func(key)
// #endregion keys

// #region values
// #region values with func
Json removeValues(Json json, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  if (values.length == 0) {
    return json;
  }

  if (json.isArray) {
    Json result = Json.emptyArray;
    foreach (value; json.toArray) {
      if (!values.canFind(value) || !removeFunc(value)) {
        result ~= value;
      }
    }
    return result;
  }
  if (json.isObject) {
    Json result = Json.emptyObject;
    foreach (key, value; json.toMap) {
      if (!values.canFind(value) || !removeFunc(value)) {
        result[key] = value;
      }
    }
    return result;
  }

  return json;
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with values and func");

  Json json = parseJsonString(`{
    "name": "John",
    "age": 30,
    "city": "New York",
    "country": "USA"
  }`);

  auto result = removeValues(json, [Json(30), Json("New York")],
    (Json value) @safe => value == Json("New York"));
  assert(result.length == 3);
  assert(result["name"] == "John");
  assert(result["age"] == 30);
  assert(result["country"] == "USA");
}
// #endregion values with func

// #region values
Json removeValues(Json json, Json[] values) {
  mixin(ShowFunction!());

  if (values.length == 0) {
    return json;
  }

  if (json.isArray) {
    Json result = Json.emptyArray;
    foreach (value; json.toArray) {
      if (!values.canFind(value)) {
        result ~= value;
      }
    }

    return result;
  }
  if (json.isObject) {
    Json result = Json.emptyObject;
    foreach (key, value; json.toMap) {
      if (!values.canFind(value)) {
        result[key] = value;
      }
    }
    return result;
  }

  return json;
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with values");

  Json json = parseJsonString(`{
    "name": "John",
    "age": 30,
    "city": "New York",
    "country": "USA"
  }`);

  auto result = removeValues(json, [Json(30), Json("New York")]);
  assert(result.length == 2);
  assert(result["name"] == "John");
  assert(result["country"] == "USA");
}
// #endregion values

// #region func(value)
Json removeValues(Json json, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  if (json.isArray) {
    Json result = Json.emptyArray;
    foreach (value; json.toArray) {
      if (!removeFunc(value)) {
        result ~= value;
      }
    }
    return result;
  }

  if (json.isObject) {
    Json result = Json.emptyObject;
    foreach (key, value; json.toMap) {
      if (!removeFunc(value)) {
        result[key] = value;
      }
    }
    return result;
  }

  return json;
}
// #endregion func(value)
// #endregion values
// #endregion Json

// #region Json[]
// #region indices
// #region indices with func
Json[] removeIndices(Json[] jsons, size_t[] indices, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  if (jsons.length == 0 || indices.length == 0) { // Nothing to remove
    return jsons;
  }

  Json[] result;
  foreach (index, value; jsons) {
    if (!indices.canFind(index) || !removeFunc(index)) {
      result ~= value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeIndices with indices and func");

  Json[] jsons = [
    "apple".toJson,
    "banana".toJson,
    "cherry".toJson,
    "date".toJson,
    "elderberry".toJson
  ];

  auto result = removeIndices(jsons, [1, 3], (size_t index) @safe => index == 3);
  assert(result.length == 4);
  assert(result[0] == Json("apple"));
  assert(result[1] == Json("banana"));
  assert(result[2] == Json("cherry"));
  assert(result[3] == Json("elderberry"));
}
// #endregion indices with func

// #region indices
Json[] removeIndices(Json[] jsons, size_t[] indices) {
  mixin(ShowFunction!());

  if (jsons.length == 0 || indices.length == 0) {
    return jsons;
  }

  Json[] result;
  foreach (index, value; jsons) {
    if (!indices.canFind(index)) {
      result ~= value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeIndices with indices");

  Json[] jsons = [
    "apple".toJson,
    "banana".toJson,
    "cherry".toJson,
    "date".toJson,
    "elderberry".toJson
  ];

  auto result = removeIndices(jsons, [1, 3]);
  assert(result.length == 3);
  assert(result[0] == Json("apple"));
  assert(result[1] == Json("cherry"));
  assert(result[2] == Json("elderberry"));
}
// #endregion indices

// #region func
Json[] removeIndices(Json[] jsons, bool delegate(size_t) @safe removeFunc) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return jsons;
  }

  Json[] result;
  foreach (index, value; jsons) {
    if (!removeFunc(index)) {
      result ~= value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeIndices with func");

  Json[] jsons = [
    "apple".toJson,
    "banana".toJson,
    "cherry".toJson,
    "date".toJson,
    "elderberry".toJson
  ];

  auto result = removeIndices(jsons, (size_t index) @safe => index == 1 || index == 3);
  assert(result.length == 3);
  assert(result[0] == Json("apple"));
  assert(result[1] == Json("cherry"));
  assert(result[2] == Json("elderberry"));
}
// #endregion func
// #endregion indices

// #region values
// #region values with func
Json[] removeValues(Json[] jsons, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json value) => values.canFind(value) && removeFunc(value));
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with values and func");

  Json[] json = [
    Json("John"),
    Json(30),
    Json("New York"),
    Json("USA")
  ];

  auto result = removeValues(json, [Json(30), Json("New York")],
    (Json value) => value == Json("New York"));

  assert(result.length == 3);
  assert(result[0] == Json("John"));
  assert(result[1] == Json(30));
  assert(result[2] == Json("USA"));
}
// #endregion values with func

// #region values
Json[] removeValues(Json[] jsons, Json[] values) {
  mixin(ShowFunction!());

  return jsons.removeValues((Json value) => values.canFind(value));
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with values");

  Json[] json = [
    Json("John"),
    Json(30),
    Json("New York"),
    Json("USA")
  ];

  auto result = removeValues(json, [Json(30), Json("New York")]);
  assert(result.length == 2);
  assert(result[0] == Json("John"));
  assert(result[1] == Json("USA"));
}
// #endregion values

// #region func(value)
Json[] removeValues(Json[] jsons, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  if (jsons.length == 0) {
    return jsons;
  }

  Json[] results;
  foreach (value; jsons) {
    if (!removeFunc(value)) {
      results ~= value;
    }
  }

  return results;
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with func");

  Json[] json = [
    Json("John"),
    Json(30),
    Json("New York"),
    Json("USA")
  ];

  auto result = removeValues(json, (Json value) @safe => value == Json(30) || value == Json(
      "New York"));
  assert(result.length == 2);
  assert(result[0] == Json("John"));
  assert(result[1] == Json("USA"));
}
// #endregion func (value)
// #endregion values
// #endregion Json[]

// #region Json[string]
// #region paths
Json[string] removePaths(Json[string] map, string[][] paths, bool delegate(string[] path) @safe removeFunc) {
  mixin(ShowFunction!()); 

  // TODO: Implement 
  return null;
}

Json[string] removePaths(Json[string] map, string[][] paths) {
  mixin(ShowFunction!()); 

  // TODO: Implement 
  return null;
}
// #endregion paths

// #region keys
// #region keys with func
Json[string] removeKeys(Json[string] map, string[] keys, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  if (keys.length == 0) {
    return map;
  }

  Json[string] result;

  foreach (key, value; map) {
    if (!keys.canFind(key) || !removeFunc(key)) {
      result[key] = value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeKeys with keys and func");

  Json[string] json = [
    "name": Json("John"),
    "age": Json(30),
    "city": Json("New York"),
    "country": Json("USA")
  ];
  auto result = json.removeKeys(["age", "city"], (string key) @safe => key == "city");
  assert(result.length == 3);
  assert(result["name"] == Json("John"));
  assert(result["age"] == Json(30));
  assert(result["country"] == Json("USA"));
}
// #endregion keys with func

// #region keys
Json[string] removeKeys(Json[string] map, string[] keys) {
  mixin(ShowFunction!());

  if (keys.length == 0) {
    return map;
  }

  return map.removeKeys((string key) => keys.canFind(key));
}
///
unittest {
  mixin(ShowTest!"Testing removeKeys with keys");

  Json[string] json = [
    "name": Json("John"),
    "age": Json(30),
    "city": Json("New York"),
    "country": Json("USA")
  ];
  auto result = json.removeKeys(["age", "city"]);
  assert(result.length == 2);
  assert(result["name"] == Json("John"));
  assert(result["country"] == Json("USA"));
}
// #endregion keys

// #region func(key)
Json[string] removeKeys(Json[string] map, bool delegate(string) @safe removeFunc) {
  mixin(ShowFunction!());

  Json[string] result;

  foreach (key, value; map) {
    if (!removeFunc(key)) {
      result[key] = value;
    }
  }

  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeKeys with func");

  Json[string] json = [
    "name": Json("John"),
    "age": Json(30),
    "city": Json("New York"),
    "country": Json("USA")
  ];
  auto result = json.removeKeys((string key) @safe => key == "age" || key == "city");
  assert(result.length == 2);
  assert(result["name"] == Json("John"));
  assert(result["country"] == Json("USA"));
}
// #endregion func(key)
// #endregion keys

// #region values
// #region values with func
Json[string] removeValues(Json[string] map, Json[] values, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  return map.removeValues((Json value) => values.canFind(value) && removeFunc(value));
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with values and func");

  Json[string] json = [
    "name": Json("John"),
    "age": Json(30),
    "city": Json("New York"),
    "country": Json("USA")
  ];

  auto result = removeValues(json, [Json(30), Json("New York")],
    (Json value) @safe => value == Json("New York"));
  assert(result.length == 3);
  assert(result["name"] == Json("John"));
  assert(result["age"] == Json(30));
  assert(result["country"] == Json("USA"));
}
// #endregion values with func

// #region values
Json[string] removeValues(Json[string] map, Json[] values) {
  mixin(ShowFunction!());

  if (values.length == 0) {
    return map;
  }

  Json[string] result;
  foreach (key, value; map) {
    if (!values.canFind(value)) {
      result[key] = value;
    }
  }
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with values");

  Json[string] json = [
    "name": Json("John"),
    "age": Json(30),
    "city": Json("New York"),
    "country": Json("USA")
  ];

  auto result = removeValues(json, [Json(30), Json("New York")]);
  assert(result.length == 2);
  assert(result["name"] == "John");
  assert(result["country"] == "USA");
}
// #endregion values

// #region func(value)
Json[string] removeValues(Json[string] map, bool delegate(Json) @safe removeFunc) {
  mixin(ShowFunction!());

  Json[string] result;
  foreach (key, value; map) {
    if (!removeFunc(value)) {
      result[key] = value;
    }
  }
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing removeValues with func");

  Json[string] json = [
    "name": Json("John"),
    "age": Json(30),
    "city": Json("New York"),
    "country": Json("USA")
  ];

  auto result = removeValues(json, (Json value) @safe => value == Json(30) || value == Json(
      "New York"));
  assert(result.length == 2);
  assert(result["name"] == "John");
  assert(result["country"] == "USA");
}
// #endregion func(value)
// #endregion values
// #endregion Json[string]
