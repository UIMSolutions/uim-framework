/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.http.cookies;

import std.exception : assertThrown, enforce;

import uim.web;

mixin(ShowModule!());

@safe:

/// A cookie sent by the server: renders as the value of a Set-Cookie header.
class HttpCookie {
  /// The value is percent-encoded when rendered. Throws if the name is invalid.
  this(string name, string value = null) {
    enforce(isHeaderName(name), "Invalid cookie name: " ~ name);
    _name = name;
    _value = value;
  }

  /// The cookie name
  string name() const {
    return _name;
  }

  /// The decoded cookie value
  string value() const {
    return _value;
  }

  /// Sets the Path attribute (fluent interface)
  auto path(string value) {
    _path = sanitizeAttribute(value);
    return this;
  }

  /// Sets the Domain attribute (fluent interface)
  auto domain(string value) {
    _domain = sanitizeAttribute(value);
    return this;
  }

  /// Sets the Max-Age attribute in seconds, 0 or less expires the cookie at once (fluent interface)
  auto maxAge(long seconds) {
    _maxAge = seconds;
    _hasMaxAge = true;
    return this;
  }

  /// Sets the Secure attribute (fluent interface)
  auto secure(bool enabled = true) {
    _secure = enabled;
    return this;
  }

  /// Sets the HttpOnly attribute (fluent interface)
  auto httpOnly(bool enabled = true) {
    _httpOnly = enabled;
    return this;
  }

  /// Sets the SameSite attribute: "Strict", "Lax" or "None" (fluent interface). "None" implies Secure.
  auto sameSite(string value) {
    enforce(["Strict", "Lax", "None"].canFind(value), "Invalid SameSite value: " ~ value);
    _sameSite = value;
    return this;
  }

  /// Renders the Set-Cookie value, e.g. "id=1; Path=/; HttpOnly"
  override string toString() const {
    auto result = appender!string;
    result.put(_name);
    result.put('=');
    result.put(percentEncode(_value));
    if (_path.length > 0) {
      result.put("; Path=" ~ _path);
    }
    if (_domain.length > 0) {
      result.put("; Domain=" ~ _domain);
    }
    if (_hasMaxAge) {
      result.put("; Max-Age=" ~ _maxAge.to!string);
    }
    if (_secure || _sameSite == "None") {
      result.put("; Secure");
    }
    if (_httpOnly) {
      result.put("; HttpOnly");
    }
    if (_sameSite.length > 0) {
      result.put("; SameSite=" ~ _sameSite);
    }
    return result.data;
  }

  /// Renders the complete header line
  string toHeader() const {
    return "Set-Cookie: " ~ toString;
  }

  // A semicolon would start a new attribute
  private static string sanitizeAttribute(string value) {
    return sanitizeHeaderValue(value).filter!(c => c != ';').to!string;
  }

  private string _name;
  private string _value;
  private string _path;
  private string _domain;
  private long _maxAge;
  private bool _hasMaxAge;
  private bool _secure;
  private bool _httpOnly;
  private string _sameSite;
}

/// Creates a cookie, e.g. httpCookie("session", id).path("/").secure.httpOnly.sameSite("Lax")
HttpCookie httpCookie(string name, string value = null) {
  return new HttpCookie(name, value);
}

/// Creates a cookie telling the client to delete a cookie. Path and domain must match the original.
HttpCookie expiredCookie(string name, string path = "/") {
  return new HttpCookie(name).path(path).maxAge(0);
}

/// Parses a Cookie request header into decoded name/value pairs. The first value of a name wins.
string[string] parseCookies(string header) {
  string[string] cookies;
  foreach (pair; header.splitter(';')) {
    auto eqIndex = pair.indexOf('=');
    if (eqIndex <= 0) {
      continue;
    }
    string name = pair[0 .. eqIndex].strip;
    string value = pair[eqIndex + 1 .. $].strip;
    if (value.length >= 2 && value[0] == '"' && value[$ - 1] == '"') {
      value = value[1 .. $ - 1];
    }
    if (name.length > 0 && name !in cookies) {
      cookies[name] = percentDecode(value);
    }
  }
  return cookies;
}

///
unittest {
  // attributes
  assert(httpCookie("id", "1").toString == "id=1");
  assert(httpCookie("id").toString == "id=");
  assert(httpCookie("id", "1").path("/").domain("x.io").maxAge(60).secure.httpOnly.sameSite("Lax").toString
    == "id=1; Path=/; Domain=x.io; Max-Age=60; Secure; HttpOnly; SameSite=Lax");
  assert(httpCookie("id", "1").secure.secure(false).toString == "id=1");
  assert(httpCookie("id", "1").toHeader == "Set-Cookie: id=1");
  assert(httpCookie("id", "1").name == "id");
  assert(httpCookie("id", "a b").value == "a b");

  // SameSite=None requires Secure
  assert(httpCookie("id", "1").sameSite("None").toString == "id=1; Secure; SameSite=None");
  assertThrown(httpCookie("id", "1").sameSite("lax"));

  // deletion
  assert(expiredCookie("id").toString == "id=; Path=/; Max-Age=0");

  // nothing can add attributes or header lines
  assert(httpCookie("id", "a; Domain=evil\r\nX: 1").toString == "id=a%3B%20Domain%3Devil%0D%0AX%3A%201");
  assert(httpCookie("id").path("/; Domain=evil\r\n").toString == "id=; Path=/ Domain=evil");
  assertThrown(httpCookie("a;b"));
  assertThrown(httpCookie(""));

  // works with the header collection
  auto headers = httpHeaders()
    .add("Set-Cookie", httpCookie("a", "1").toString)
    .add("Set-Cookie", httpCookie("b", "2").toString);
  assert(headers.toString == "Set-Cookie: a=1\r\nSet-Cookie: b=2");

  // request parsing
  auto cookies = parseCookies(`a=1; b="2"; c=x%20y; d=; broken; =skip; a=ignored`);
  assert(cookies["a"] == "1");
  assert(cookies["b"] == "2");
  assert(cookies["c"] == "x y");
  assert(cookies["d"] == "");
  assert(cookies.length == 4);
  assert(parseCookies("").length == 0);

  // round trip
  assert(parseCookies(httpCookie("v", "Hällo; Wörld").toString)["v"] == "Hällo; Wörld");
}
