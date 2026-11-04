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
  return encode!isUnreserved(value);
}

/// Percent-encodes a path segment: keeps the characters RFC 3986 allows there, encodes '/'
string encodePathSegment(string value) {
  return encode!isPathChar(value);
}

/// Percent-encodes a fragment: keeps the characters RFC 3986 allows there, e.g. "/route?a=1"
string encodeFragment(string value) {
  return encode!(b => b.isPathChar || b == '/' || b == '?')(value);
}

private string encode(alias keep, bool spaceAsPlus = false)(string value) {
  auto bytes = value.representation;
  if (bytes.all!keep) {
    return value;
  }
  auto result = appender!string;
  result.reserve(value.length + value.length / 2);
  foreach (ubyte b; bytes) {
    if (keep(b)) {
      result.put(cast(char)b);
    } else if (spaceAsPlus && b == ' ') {
      result.put('+');
    } else {
      result.put('%');
      result.put(hexDigits[b >> 4]);
      result.put(hexDigits[b & 0xF]);
    }
  }
  return result.data;
}

/// Decodes a percent-encoded string, e.g. percentDecode("a%20b") -> "a b"
string percentDecode(string value) {
  if (!value.canFind('%')) {
    return value;
  }
  auto result = appender!string;
  result.reserve(value.length);
  size_t i;
  while (i < value.length) {
    if (value[i] == '%' && i + 2 < value.length) {
      int high = hexValue(value[i + 1]);
      int low = hexValue(value[i + 2]);
      if (high >= 0 && low >= 0) {
        result.put(cast(char)(high << 4 | low));
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
  return encode!(isUnreserved, true)(value);
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

private bool isPathChar(ubyte b) {
  return b.isUnreserved || "!$&'()*+,;=:@".representation.canFind(b);
}

private immutable hexDigits = "0123456789ABCDEF";

/// The value of a hex digit, -1 for any other character
private int hexValue(char c) {
  if (c >= '0' && c <= '9') {
    return c - '0';
  }
  if (c >= 'a' && c <= 'f') {
    return c - 'a' + 10;
  }
  return c >= 'A' && c <= 'F' ? c - 'A' + 10 : -1;
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

  // every byte survives a round trip
  string allBytes;
  foreach (b; 0 .. 256) {
    allBytes ~= cast(char)b;
  }
  assert(percentDecode(percentEncode(allBytes)) == allBytes);
  assert(formUrlDecode(formUrlEncode(allBytes)) == allBytes);

  // components
  assert(encodePathSegment("a b/c:d@e") == "a%20b%2Fc:d@e");
  assert(encodePathSegment("x;y=1,2") == "x;y=1,2");
  assert(encodeFragment("/route?a=1&b") == "/route?a=1&b");
  assert(encodeFragment("a b#c") == "a%20b%23c");
}
