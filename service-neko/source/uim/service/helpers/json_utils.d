/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.json_utils;

import uim.service;

mixin(ShowModule!());

@safe:
/// Extract an integer field from a Json object.
long jsonLong(Json j, string key, long defaultValue = 0) {
  if (!j.isObject)
    return defaultValue;

  if (key !in j)
    return defaultValue;

  auto v = j[key];
  return v.isInteger ? v.get!long : defaultValue;
}
// double getDouble(Json j, string key) {
//   if (!j.hasKey(key))
//     return 0.0;
//   auto v = j[key];
//   if (v.isFloat)
//     return v.get!double;
//   if (v.isInteger)
//     return cast(double)v.get!long;
//   return 0.0;
// }

string[][] jsonPairArray(Json j, string key) {
  if (!j.isObject)
    return null;
  auto v = j[key];
  if (!v.isArray)
    return null;
  auto arr = v.toArray;
  auto result = appender!(string[][]);
  result.reserve(arr.length);
  foreach (elem; arr) {
    if (elem.isObject) {
      auto k = "key" in elem;
      auto val = "value" in elem;
      if (k !is null && val !is null) {
        result ~= [(k).get!string, (val).get!string];
      }
    } else if (elem.isArray) {
      auto items = elem.toArray;
      auto pair = appender!(string[]);
      pair.reserve(items.length);
      foreach (item; items) {
        if (item.isString)
          pair ~= item.get!string;
      }
      if (pair[].length >= 2)
        result ~= pair[];
    }
  }
  return result[];
}

string[][] jsonMessageArray(Json j, string key) {
  if (!j.isObject)
    return null;
  auto v = j[key];
  if (!v.isArray)
    return null;

  auto arr = v.toArray;
  auto result = appender!(string[][]);
  result.reserve(arr.length);
  foreach (elem; arr) {
    if (elem.isObject) {
      auto role = "role" in elem;
      auto content = "content" in elem;
      if (role !is null && content !is null) {
        result ~= [(role).get!string, (content).get!string];
      }
    }
  }
  return result[];
}
///
unittest {
  assert(getString(parseJsonString(`{"name": "test"}`), "name") == "test");
  assert(getString(parseJsonString(`{"name": "test"}`), "missing") == "");

  assert(getStrings(parseJsonString(`{"tags": ["a", "b"]}`), "tags") == [
      "a", "b"
    ]);
  // assert(getStrings(parseJsonString(`{}`), "tags").isNull);
}
/// Read a string array from JSON.
string[] getStrings(Json j, string key, string[] defaultArray = null) {
  if (!j.isObject)
    return defaultArray;

  if (key !in j)
    return defaultArray;

  auto val = j[key];
  if (!val.isArray)
    return defaultArray;

  return val.toArray
    .filter!(item => item.isString)
    .map!(item => item.get!string)
    .array;
}

string[string] jsonStrMap(Json j, string key) {
  if (!j.isObject)
    return null;

  auto v = j[key];
  if (!v.isObject)
    return null;

  string[string] result;
  foreach (string k, val; v.toMap) {
    if (val.isString)
      result[k] = val.get!string;
  }
  return result;
}

/*
 string extractId(scope HTTPServerRequest req) {
  
  // import std.string : split;
  auto path = req.requestURI;
  auto parts = path.split("/");
  // /api/v1/dashboards/{id}...
  foreach (i, part; parts) {
    if (part == "dashboards" && i + 1 < parts.length) {
      auto candidate = parts[i + 1];
      // Skip sub-resource keywords
      if (candidate != "publish" && candidate != "pages" && candidate.length > 0)
        return candidate;
    }
  }
  return "";
}
*/
/// Extract a query parameter from the URI.
string queryParam(scope HTTPServerRequest req, string key) {
  auto val = req.headers.get("X-Query-" ~ key, "");
  if (val.length > 0)
    return val;

  // Parse from query string
  auto uri = req.requestURI;
  // import std.string : indexOf;
  auto qpos = uri.indexOf('?');
  if (qpos < 0)
    return "";

  auto qs = uri[qpos + 1 .. $];
  foreach (pair; splitBy(qs, '&')) {
    auto epos = pair.indexOf('=');
    if (epos > 0 && pair[0 .. epos] == key)
      return pair[epos + 1 .. $];
  }
  return "";
}

string[] splitBy(string s, char delim) {
  string[] result;
  size_t start = 0;
  foreach (i, ch; s) {
    if (ch == delim) {
      result ~= s[start .. i];
      start = i + 1;
    }
  }
  if (start <= s.length)
    result ~= s[start .. $];
  return result;
}
/// Serialize a struct to JSON.
Json toJsonValue(T)(T val) {
  auto j = Json.emptyObject;
  static foreach (i, field; T.tupleof) {
    {
      enum name = __traits(identifier, T.tupleof[i]);
      alias FT = typeof(field);
      static if (is(FT == string))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == bool))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == long) || is(FT == int) || is(FT == size_t) || is(FT == ulong))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == string[])) {
        auto arr = Json.emptyArray;
        foreach (s; val.tupleof[i])
          arr ~= Json(s);
        j[name] = arr;
      } else static if (is(FT == enum)) {

        j[name] = Json(val.tupleof[i].to!string);
      } else static if (is(FT == string[string])) {
        auto obj = Json.emptyObject;
        foreach (k, v; val.tupleof[i])
          obj[k] = Json(v);
        j[name] = obj;
      } else static if (isArray!FT && !is(FT == string)) {
        auto arr = Json.emptyArray;
        foreach (item; val.tupleof[i])
          arr ~= toJsonValue(item);
        j[name] = arr;
      }
    }
  }
  return j;
}
/// Read a size_t field from JSON.
size_t jsonUint(Json j, string key, size_t default_ = 0) {
  return cast(size_t)jsonLong(j, key, default_);
}
/// Read an int field from JSON.
/// Parse an enum from a JSON string field.
T jsonEnum(T)(Json j, string key, T default_ = T.init) {
  auto str = data.getString(key);
  if (str.length == 0)
    return default_;

  try
    return str.to!T;
  catch (Exception)
    return default_;
}
/// Write a standard JSON error response.
void writeApiError(scope HTTPServerResponse res, int status, string detail) {
  auto response = Json.emptyObject;
  response["error"] = Json(detail);
  response["status"] = Json(status);
  res.writeJsonBody(response, status);
}
/// Serialize a struct to JSON.
Json toJsonValue(T)(T val) {
  auto j = Json.emptyObject;
  static foreach (i, field; T.tupleof) {
    {
      enum name = __traits(identifier, T.tupleof[i]);
      alias FT = typeof(field);
      static if (is(FT == string))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == bool))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == long) || is(FT == int) || is(FT == size_t) || is(FT == ulong))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == string[])) {
        auto arr = Json.emptyArray;
        foreach (s; val.tupleof[i])
          arr ~= Json(s);
        j[name] = arr;
      } else static if (is(FT == enum)) {

        j[name] = Json(val.tupleof[i].to!string);
      } else static if (is(FT == string[string])) {
        auto obj = Json.emptyObject;
        foreach (k, v; val.tupleof[i])
          obj[k] = Json(v);
        j[name] = obj;
      } else static if (isArray!FT && !is(FT == string)) {
        auto arr = Json.emptyArray;
        foreach (item; val.tupleof[i])
          arr ~= toJsonValue(item);
        j[name] = arr;
      }
    }
  }
  return j;
}
/// Parse array of [key, value] pairs from JSON array of objects with "key"/"value" fields
string[][] jsonKeyValuePairs(Json j, string key) {
  if (!j.isObject)
    return null;

  if (key !in j)
    return null;

  auto v = j[key];
  if (!v.isArray)
    return null;

  string[][] result;
  foreach (item; v.toArray) {
    if (item.isObject) {
      auto k = item.getString("key");
      auto val = item.getString("value");
      if (k.length > 0)
        result ~= [k, val];
    }
  }
  return result;
}

Json toJsonArray(string[] arr) {
  return arr.map!(s => Json(s)).array.toJson;
}
/// Serialize a struct to a Json value.
Json toJsonValue(T)(T obj) if (is(T == struct)) {
  return serializeToJson(obj);
}
/// Helper: standard JSON error response body.
Json errorJson(string message, int code = 400) {
  return Json.emptyObject
    .set("error", message)
    .set("code", code);
}

/// Helper: envelope a result with metadata.
Json envelopeJson(string key, Json data) {
  auto j = Json.emptyObject;
  j[key] = data;
  return j;
}
/// Extract a string[][] (array of string arrays) from a Json object.
string[][] getStringsArray(Json j, string key) {
  if (!j.isObject)
    return null;

  if (key !in j)
    return null;

  auto v = j[key];
  if (!v.isArray)
    return null;

  string[][] result;
  foreach (item; v.toArray) {
    if (item.isArray) {
      string[] inner;
      foreach (sub; item.toArray)
        if (sub.isString)
          inner ~= sub.get!string;
      result ~= inner;
    }
  }
  return result;
}

long lastIndexOfChar(string s, char c) {
  for (long i = s.length - 1; i >= 0; --i)
    if (s[cast(size_t)i] == c)
      return i;
  return -1;
}

Json stringsToJsonArray(string[] arr) {
  return arr.map!(s => Json(s)).array.toJson;
}
/// Convert a string array to a Json array.
/// Convert a string[string] map to a Json object.
// Json toJsonObject(const(string[string]) map) {
//   auto jobj = Json.emptyObject;
//   foreach (k, v; map)
//     jobj[k] = Json(v);
//   return jobj;
// }

string[][] jsonFieldArray(Json j, string key) {
  if (!j.isObject)
    return null;

  if (key in j)
    return null;

  auto v = j[key];
  if (!v.isArray)
    return null;

  string[][] result;
  foreach (item; v.toArray) {
    if (item.isObject) {
      auto name = item.getString("name");
      auto label = item.getString("label");
      auto type = item.getString("type");
      auto req = getBoolean(item, "required") ? "true" : "false";
      if (name.length > 0)
        result ~= [name, label, type, req];
    }
  }
  return result;
}

string[][] jsonRegionArray(Json j, string key) {

  if (!j.isObject)
    return null;

  if (key !in j)
    return null;

  auto v = j[key];
  if (!v.isArray)
    return null;

  string[][] result;
  foreach (item; v.toArray) {
    if (item.isObject) {
      auto fieldName = item.getString("fieldName");
      auto page = jsonInt(item, "page").to!string;
      auto x = getDouble(item, "x").to!string;
      auto y = getDouble(item, "y").to!string;
      auto width = getDouble(item, "width").to!string;
      auto height = getDouble(item, "height").to!string;
      if (fieldName.length > 0)
        result ~= [fieldName, page, x, y, width, height];
    }
  }
  return result;
}
/// Serialize a struct to JSON.
Json toJsonValue(T)(T val) {
  auto j = Json.emptyObject;
  static foreach (i, field; T.tupleof) {
    {
      enum name = __traits(identifier, T.tupleof[i]);
      alias FT = typeof(field);
      static if (is(FT == string))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == bool))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == long) || is(FT == int) || is(FT == size_t) || is(FT == ulong))
        j[name] = Json(val.tupleof[i]);
      else static if (is(FT == string[])) {
        auto arr = Json.emptyArray;
        foreach (s; val.tupleof[i])
          arr ~= Json(s);
        j[name] = arr;
      } else static if (is(FT == enum)) {

        j[name] = Json(val.tupleof[i].to!string);
      }
    }
  }
  return j;
}
// /// Serialize a string array to Json array.
// Json serializeStrArray(string[] arr) {
//   auto result = Json.emptyArray;
//   foreach (s; arr)
//     result ~= Json(s);
//   return result;
// }
// /// Serialize a string[string] map to Json object.
// Json serializeStrMap(string[string] map) {
//   auto result = Json.emptyObject;
//   foreach (k, v; map)
//     result[k] = Json(v);
//   return result;
// }
/// Extract a string[string] map from a Json object.
/// Convert a string array to a Json array.
/// Convert a string[string] map to a Json object.
Json toJsonObject(const(string[string]) map) {
  auto jobj = Json.emptyObject;
  foreach (k, v; map)
    jobj[k] = Json(v);
  return jobj;
}
// /// Serialize a string-to-string map to Json.
// Json serializeStrMap(string[string] map) {
//   auto j = Json.emptyObject;
//   foreach (k, v; map)
//     j[k] = Json(v);
//   return j;
// }
// /// Serialize a string array to Json.
// Json serializeStrArray(string[] arr) {
//   auto j = Json.emptyArray;
//   foreach (s; arr)
//     j ~= Json(s);
//   return j;
// }
/// Extract a ushort field from a Json object.
ushort getUshort(Json j, string key, ushort default_ = 0) {
  return cast(ushort)jsonLong(j, key, default_);
}


// --- Enum parsers ---

/*
string getString(Json j, string key) {
    if (!j.isObject)
        return "";
    auto v = key in j;
    if (v.isNull)
        return "";
    if ((v).isString)
        return (v).get!string;
    return "";
}

bool getBoolean(Json j, string key, bool default_ = false) {
    if (!j.isObject)
        return default_;
    auto v = key in j;
    if (v.isNull)
        return default_;
    if ((v).isBoolean)
        return (v).get!bool;
    return default_;
}


long jsonLong(Json j, string key, long default_ = 0) {
    if (!j.isObject)
        return default_;
    auto v = key in j;
    if (v.isNull)
        return default_;
    if ((v).isInteger)
        return (v).get!long;
    return default_;
}
*/
// long jsonLong(Json j, string key, long default_ = 0) {
//     if (!j.isObject)
//         return default_;
//     auto v = key in j;
//     if (v.isNull)
//         return default_;
//     if ((v).isInteger)
//         return (v).get!long;
//     return default_;
// string extractSegmentFromPath(string path, int segmentIndex) {
//     import std.string : split;
//     auto parts = path.split("/");
//     // Filter empty segments
//     string[] segments;
//     foreach (p; parts) {
//         if (p.length > 0)
//             segments ~= p;
//     }
//     if (segmentIndex < segments.length)
//         return segments[segmentIndex];
//     return "";
// }
/// Serialize a string array to Json array.
Json serializeStrArray(string[] arr) {
  auto result = Json.emptyArray;
  foreach (s; arr)
    result ~= Json(s);
  return result;
}
/// Serialize a string[string] map to Json object.
Json serializeStrMap(string[string] map) {
  auto result = Json.emptyObject;
  foreach (k, v; map)
    result[k] = Json(v);
  return result;
}
/// Extract a Json array of objects (generic).
Json[] jsonObjArray(Json j, string key) {
  if (!j.isObject)
    return null;

  if (key !in j)
    return null;

  auto v = j[key];
  if (!v.isArray)
    return null;

  Json[] result;
  foreach (item; v.toArray) {
    if (item.isObject)
      result ~= item;
  }
  return result;
}

int jsonInt(Json j, string key, int default_ = 0) {
  if (!j.isObject)
    return default_;

  if (key !in j)
    return default_;

  auto v = j[key];
  if (!v.isInteger)
    return default_;

  return cast(int)v.get!long;
}

bool safeBool(Json obj, string key) {
  if ((key in obj) !is null && obj.isBoolean(key))
    return obj[key].get!bool;

  return false;
}

E safeEnum(E)(Json obj, string key, E default_) {
  if ((key in obj) !is null && obj[key].isString) {
    try {
      return obj[key].get!string
        .to!E;
    } catch (Exception) {
    }
  }
  return default_;
}
