/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.url.encoding;

import uim.web;

mixin(ShowModule!());

@safe:

/// Percent-encodes a string for use in a URL (unreserved characters stay as-is)
string percentEncode(string value) {
  auto result = appender!string;
  foreach (ubyte b; value.representation) {
    if (b.isUnreserved) {
      result.put(cast(char)b);
    } else {
      result.put("%%%02X".format(b));
    }
  }
  return result.data;
}

/// Decodes a percent-encoded string, e.g. percentDecode("a%20b") -> "a b"
string percentDecode(string value) {
  auto result = appender!string;
  size_t i;
  while (i < value.length) {
    if (value[i] == '%' && i + 2 < value.length) {
      auto hexPart = value[i + 1 .. i + 3];
      if (hexPart.all!(c => c.isHexDigit)) {
        result.put(cast(char)hexPart.to!ubyte(16));
        i += 3;
        continue;
      }
    }
    result.put(value[i]);
    i++;
  }
  return result.data;
}

/// Form-encodes a string (application/x-www-form-urlencoded): spaces become '+'
string formUrlEncode(string value) {
  auto result = appender!string;
  foreach (ubyte b; value.representation) {
    if (b.isUnreserved) {
      result.put(cast(char)b);
    } else if (b == ' ') {
      result.put('+');
    } else {
      result.put("%%%02X".format(b));
    }
  }
  return result.data;
}

/// Decodes a form-encoded string: '+' becomes a space
string formUrlDecode(string value) {
  return percentDecode(value.replace("+", " "));
}

private bool isUnreserved(ubyte b) {
  return (b >= 'A' && b <= 'Z')
    || (b >= 'a' && b <= 'z')
    || (b >= '0' && b <= '9')
    || b == '-' || b == '_' || b == '.' || b == '~';
}

private bool isHexDigit(dchar c) {
  return (c >= '0' && c <= '9') || (c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F');
}

///
unittest {
  // url encoding
  assert(percentEncode("abc") == "abc");
  assert(percentEncode("a b") == "a%20b");
  assert(percentEncode("a&b=c") == "a%26b%3Dc");
  assert(percentEncode("ü") == "%C3%BC");
  assert(percentEncode("100%") == "100%25");
  assert(percentEncode("a/b?c") == "a%2Fb%3Fc");
  assert(percentEncode("") == "");

  // url decoding
  assert(percentDecode("abc") == "abc");
  assert(percentDecode("a%20b") == "a b");
  assert(percentDecode("a%26b%3Dc") == "a&b=c");
  assert(percentDecode("%C3%BC") == "ü");
  assert(percentDecode("100%25") == "100%");
  assert(percentDecode("%") == "%"); // incomplete sequences stay as-is
  assert(percentDecode("%2") == "%2");
  assert(percentDecode("%zz") == "%zz");

  // round trip
  assert(percentDecode(percentEncode("Hällo Wörld & Co!")) == "Hällo Wörld & Co!");

  // form encoding
  assert(formUrlEncode("a b") == "a+b");
  assert(formUrlEncode("a&b") == "a%26b");
  assert(formUrlDecode("a+b") == "a b");
  assert(formUrlDecode("a%20b") == "a b");
  assert(formUrlDecode(formUrlEncode("a b&c")) == "a b&c");
}
