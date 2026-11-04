/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.js.values;

import uim.web;

mixin(ShowModule!());

@safe:

/**
 * Escapes a string for use inside a single-quoted JavaScript string literal.
 *
 * The result is also safe inside an inline script element: closing tags and HTML comment
 * openers are broken up, and U+2028/U+2029 (line terminators in older engines) are escaped.
 */
string escapeJsString(string value) {
  auto sink = appender!string;
  size_t start;
  foreach (i, char c; value) {
    string replacement = jsEscapeAt(value, i);
    if (replacement !is null) {
      sink.put(value[start .. i]);
      sink.put(replacement);
      // the two trailing bytes of U+2028/U+2029 are part of the replacement
      start = i + (c == 0xE2 ? 3 : 1);
    }
  }
  if (start == 0) {
    return value;
  }
  if (start < value.length) {
    sink.put(value[start .. $]);
  }
  return sink.data;
}

// The escape sequence for the character at an index, null if it can stay as-is
private string jsEscapeAt(string value, size_t index) {
  char c = value[index];
  string rest = value[index + 1 .. $];
  switch (c) {
    case '\\': return `\\`;
    case '\'': return `\'`;
    case '\n': return `\n`;
    case '\r': return `\r`;
    case '\t': return `\t`;
    case '/': return index > 0 && value[index - 1] == '<' ? `\/` : null;
    case '<': return rest.startsWith("!--") ? `\x3C` : null;
    case 0xE2:
      if (rest.startsWith("\x80\xA8")) {
        return `\u2028`;
      }
      return rest.startsWith("\x80\xA9") ? `\u2029` : null;
    default:
      return c < 0x20 ? `\x%02X`.format(cast(uint)c) : null;
  }
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

/// JavaScript number literal from a double, with as many digits as it takes to read back the same value
string jsNumber(double value) {
  import std.exception : ifThrown;
  import std.math : isInfinity, isNaN;

  if (value.isNaN) {
    return "NaN";
  }
  if (value.isInfinity) {
    return value > 0 ? "Infinity" : "-Infinity";
  }
  foreach (precision; 15 .. 17) {
    string result = "%.*g".format(precision, value);
    // rounding near double.max can leave the range of double
    if (result.to!double.ifThrown(double.nan) == value) {
      return result;
    }
  }
  return "%.17g".format(value);
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

/// Checks whether a string can be written as an unquoted property name
bool isJsIdentifier(string value) {
  if (value.length == 0 || (value[0] >= '0' && value[0] <= '9')) {
    return false;
  }
  foreach (char c; value) {
    bool isWordChar = (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9');
    if (!isWordChar && c != '_' && c != '$') {
      return false;
    }
  }
  return true;
}

/// Property name of an object literal, quoted if necessary, e.g. jsKey("Content-Type") -> `'Content-Type'`
string jsKey(string name) {
  return isJsIdentifier(name) ? name : jsString(name);
}

/// JavaScript object literal from string values, e.g. jsObject(["a": "b"]) -> `{a: 'b'}`
string jsObject(string[string] values) {
  return "{%s}".format(
    values.keys.sort.map!(key => "%s: %s".format(jsKey(key), jsString(values[key]))).join(", "));
}

/// JavaScript object literal from raw JS expressions (values not quoted)
string jsObjectRaw(string[string] expressions) {
  return "{%s}".format(
    expressions.keys.sort.map!(key => "%s: %s".format(jsKey(key), expressions[key])).join(", "));
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
      return jsNumber(value.get!double);
    case Json.Type.bigInt:
      return value.toString;
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
      return "{%s}".format(pairs.sort.join(", "));
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

  // string literals survive inline scripts
  assert(escapeJsString("plain") == "plain");
  assert(escapeJsString("</SCRIPT>") == `<\/SCRIPT>`);
  assert(escapeJsString("<!--<script>") == `\x3C!--<script>`);
  assert(escapeJsString("a\u2028b\u2029c") == `a\u2028b\u2029c`);
  assert(escapeJsString("\u2028") == `\u2028`);
  assert(escapeJsString("a\x00b\x1Fc") == `a\x00b\x1Fc`);
  assert(escapeJsString("äöü€") == "äöü€");
  assert(escapeJsString("a/b < c") == "a/b < c");

  // numbers keep their full value
  assert(jsNumber(3.14159265358979) == "3.14159265358979");
  assert(jsNumber(0.1) == "0.1");
  assert(jsNumber(0.0000001) == "1e-07");
  assert(jsNumber(1e21) == "1e+21");
  assert(jsNumber(2.0) == "2");
  assert(jsNumber(double.max) == "1.7976931348623157e+308");
  assert(jsNumber(-double.max) == "-1.7976931348623157e+308");
  assert(jsNumber(double.nan) == "NaN");
  assert(jsNumber(double.infinity) == "Infinity");
  assert(jsNumber(-double.infinity) == "-Infinity");
  assert(jsValue(Json(3.14159265358979)) == "3.14159265358979");
  assert(jsNumber(0.1 + 0.2).to!double == 0.1 + 0.2);

  // property names
  assert(isJsIdentifier("a_1$"));
  assert(!isJsIdentifier(""));
  assert(!isJsIdentifier("1a"));
  assert(!isJsIdentifier("a-b"));
  assert(!isJsIdentifier("ä"));
  assert(jsKey("name") == "name");
  assert(jsKey("Content-Type") == `'Content-Type'`);
  assert(jsObject(["a-b": "c"]) == `{'a-b': 'c'}`);
  assert(jsObjectRaw(["a b": "1"]) == `{'a b': 1}`);

  // object keys render in a stable order
  auto ordered = Json.emptyObject;
  ordered["z"] = 1;
  ordered["a"] = 2;
  assert(jsValue(ordered) == `{'a': 2, 'z': 1}`);
}
