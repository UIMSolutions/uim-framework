/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.js.values;

import uim.web;

mixin(ShowModule!());

@safe:

/// Escapes a string for use inside a single-quoted JavaScript string literal
string escapeJsString(string value) {
  return value
    .replace("\\", "\\\\")
    .replace("'", "\\'")
    .replace("\n", "\\n")
    .replace("\r", "\\r")
    .replace("\t", "\\t")
    .replace("</", "<\\/");
}

/// JavaScript string literal, e.g. jsString("it's") -> `'it\'s'`
string jsString(string value) {
  return "'%s'".format(escapeJsString(value));
}

/// JavaScript boolean literal, e.g. jsBool(true) -> "true"
string jsBool(bool value) {
  return value ? "true" : "false";
}

/// JavaScript number literal from an int
string jsNumber(int value) {
  return value.to!string;
}

/// JavaScript number literal from a double
string jsNumber(double value) {
  return trimNumber(value);
}

/// JavaScript null literal
string jsNull() {
  return "null";
}

/// JavaScript undefined literal
string jsUndefined() {
  return "undefined";
}

/// JavaScript array literal from strings, e.g. jsArray(["a", "b"]) -> `['a', 'b']`
string jsArray(string[] values) {
  return "[%s]".format(values.map!(v => jsString(v)).join(", "));
}

/// JavaScript array literal from ints, e.g. jsArray([1, 2]) -> "[1, 2]"
string jsArray(int[] values) {
  return "[%s]".format(values.map!(v => v.to!string).join(", "));
}

/// JavaScript array literal from raw JS expressions (not quoted)
string jsArrayRaw(string[] expressions) {
  return "[%s]".format(expressions.join(", "));
}

/// JavaScript object literal from string values, e.g. jsObject(["a": "b"]) -> `{a: 'b'}`
string jsObject(string[string] values) {
  return "{%s}".format(
    values.keys.sort.map!(key => "%s: %s".format(key, jsString(values[key]))).join(", "));
}

/// JavaScript object literal from raw JS expressions (values not quoted)
string jsObjectRaw(string[string] expressions) {
  return "{%s}".format(
    expressions.keys.sort.map!(key => "%s: %s".format(key, expressions[key])).join(", "));
}

/// Converts a vibe Json value to a JavaScript literal
// @trusted: Json.opApply is declared @system in vibe.data.json but is memory-safe here
@trusted string jsValue(Json value) {
  switch (value.type) {
    case Json.Type.undefined:
      return jsUndefined;
    case Json.Type.null_:
      return jsNull;
    case Json.Type.bool_:
      return jsBool(value.get!bool);
    case Json.Type.int_:
      return value.get!long.to!string;
    case Json.Type.float_:
      return trimNumber(value.get!double);
    case Json.Type.string:
      return jsString(value.get!string);
    case Json.Type.array:
      string[] items;
      foreach (item; value) {
        items ~= jsValue(item);
      }
      return "[%s]".format(items.join(", "));
    case Json.Type.object:
      string[] pairs;
      foreach (string key, Json item; value) {
        pairs ~= "%s: %s".format(jsString(key), jsValue(item));
      }
      return "{%s}".format(pairs.join(", "));
    default:
      return jsUndefined;
  }
}

///
unittest {
  // escaping
  assert(escapeJsString("it's") == `it\'s`);
  assert(escapeJsString("a\\b") == `a\\b`);
  assert(escapeJsString("a\nb") == `a\nb`);
  assert(escapeJsString("</script>") == `<\/script>`);

  // literals
  assert(jsString("hi") == `'hi'`);
  assert(jsBool(true) == "true");
  assert(jsBool(false) == "false");
  assert(jsNumber(42) == "42");
  assert(jsNumber(1.5) == "1.5");
  assert(jsNull == "null");
  assert(jsUndefined == "undefined");

  // arrays
  assert(jsArray(["a", "b"]) == `['a', 'b']`);
  assert(jsArray([1, 2, 3]) == "[1, 2, 3]");
  assert(jsArrayRaw(["x", "y.z"]) == "[x, y.z]");
  assert(jsArray(cast(string[])[]) == "[]");

  // objects
  assert(jsObject(["name": "uim"]) == `{name: 'uim'}`);
  assert(jsObjectRaw(["x": "1 + 2"]) == `{x: 1 + 2}`);
  assert(jsObject(cast(string[string])null) == "{}");

  // Json conversion
  assert(jsValue(Json("text")) == `'text'`);
  assert(jsValue(Json(42)) == "42");
  assert(jsValue(Json(true)) == "true");
  assert(jsValue(Json(null)) == "null");
  assert(jsValue(Json.emptyObject) == "{}");
  assert(jsValue(Json.emptyArray) == "[]");

  auto obj = Json.emptyObject;
  obj["name"] = "uim";
  obj["count"] = 2;
  string objResult = jsValue(obj);
  assert(objResult.startsWith("{"));
  assert(objResult.endsWith("}"));
  assert(objResult.canFind("'name': 'uim'"));
  assert(objResult.canFind("'count': 2"));

  auto arr = Json.emptyArray;
  arr ~= Json(1);
  arr ~= Json("two");
  assert(jsValue(arr) == `[1, 'two']`);
}
