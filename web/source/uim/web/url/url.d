/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.url.url;

import std.ascii : isAlpha, isAlphaNum, isDigit;
import std.exception : assertThrown, enforce;

import uim.web;

mixin(ShowModule!());

@safe:

/// A URL composed of scheme, host, port, path segments, query parameters and fragment.
class Url {
  this(string url) {
    this();
    parse(url);
  }

  private this() {
    // initialized per instance: field initializers would share one QueryParams object
    _query = new QueryParams;
  }

  /// The scheme without "://", e.g. "https"
  string scheme() const {
    return _scheme;
  }

  /// The host, e.g. "example.com"
  string host() const {
    return _host;
  }

  /// The port (0 = default port of the scheme)
  int port() const {
    return _port;
  }

  /// The user information of the authority, e.g. "user:secret", as it appears in the URL
  string userInfo() const {
    return _userInfo;
  }

  /// The scheme-specific part of a URL without authority, e.g. "a@b.c" of "mailto:a@b.c"
  string opaque() const {
    return _opaque;
  }

  /// The decoded path, e.g. "/users/1"
  string path() const {
    string joined = "/" ~ _segments.join("/");
    return _trailingSlash && _segments.length > 0 ? joined ~ "/" : joined;
  }

  /// The path segments
  string[] segments() const {
    return _segments.dup;
  }

  /// The query parameters
  QueryParams query() {
    return _query;
  }

  /// The fragment without '#'
  string fragment() const {
    return _fragment;
  }

  /// Sets the scheme (fluent interface)
  auto setScheme(string value) {
    _scheme = value;
    return this;
  }

  /// Sets the host (fluent interface)
  auto setHost(string value) {
    _host = value;
    return this;
  }

  /// Sets the port (fluent interface)
  auto setPort(int value) {
    _port = value;
    return this;
  }

  /// Sets the user information, which must already be percent-encoded (fluent interface)
  auto setUserInfo(string value) {
    _userInfo = value;
    return this;
  }

  /// Sets the path from a decoded string (fluent interface)
  auto setPath(string value) {
    _trailingSlash = value.endsWith("/");
    string[] parts = value.split("/");
    if (parts.length > 0 && value.startsWith("/")) {
      parts = parts[1 .. $];
    }
    if (parts.length > 0 && _trailingSlash) {
      parts = parts[0 .. $ - 1];
    }
    _segments = parts;
    return this;
  }

  /// Appends a decoded path segment (fluent interface)
  auto addSegment(string segment) {
    _segments ~= segment;
    _trailingSlash = false;
    return this;
  }

  /// Sets a query parameter (fluent interface)
  auto param(string key, string value) {
    _query.set(key, value);
    return this;
  }

  /// Sets the fragment (fluent interface)
  auto setFragment(string value) {
    _fragment = value.startsWith("#") ? value[1 .. $] : value;
    return this;
  }

  /// Checks whether the URL uses a secure scheme (https/wss)
  bool isSecure() const {
    return _scheme == "https" || _scheme == "wss";
  }

  /// The default port of the scheme (0 if unknown)
  int defaultPort() const {
    switch (_scheme) {
      case "http": return 80;
      case "https": return 443;
      case "ftp": return 21;
      case "ws": return 80;
      case "wss": return 443;
      default: return 0;
    }
  }

  /// The origin of the URL, e.g. "https://example.com:8080"
  string origin() const {
    auto result = appender!string;
    putOrigin(result);
    return result.data;
  }

  /// Renders the complete URL
  override string toString() const {
    auto result = appender!string;
    if (_opaque.length > 0) {
      result.put(_scheme);
      result.put(':');
      result.put(_opaque);
    } else {
      putOrigin(result, true);
      foreach (segment; _segments) {
        result.put('/');
        result.put(encodePathSegment(segment));
      }
      if (_trailingSlash) {
        result.put('/');
      }
    }
    string queryString = _query.toString;
    if (queryString.length > 0) {
      result.put('?');
      result.put(queryString);
    }
    if (_fragment.length > 0) {
      result.put('#');
      result.put(encodeFragment(_fragment));
    }
    return result.data;
  }

  private void putOrigin(ref Appender!string result, bool withUserInfo = false) const {
    if (_scheme.length > 0) {
      result.put(_scheme);
      result.put("://");
    } else if (_protocolRelative) {
      result.put("//");
    }
    if (withUserInfo && _userInfo.length > 0) {
      result.put(_userInfo);
      result.put('@');
    }
    result.put(_host);
    if (_port > 0 && _port != defaultPort) {
      result.put(':');
      result.put(_port.to!string);
    }
  }

  private void parse(string url) {
    string rest = url;

    // fragment
    auto hashIndex = rest.indexOf('#');
    if (hashIndex >= 0) {
      _fragment = percentDecode(rest[hashIndex + 1 .. $]);
      rest = rest[0 .. hashIndex];
    }

    // query
    auto queryIndex = rest.indexOf('?');
    if (queryIndex >= 0) {
      _query = parseQuery(rest[queryIndex + 1 .. $]);
      rest = rest[0 .. queryIndex];
    }

    // scheme
    auto schemeIndex = rest.indexOf("://");
    auto colonIndex = rest.indexOf(':');
    if (schemeIndex > 0 && isScheme(rest[0 .. schemeIndex])) {
      _scheme = rest[0 .. schemeIndex].toLower;
      rest = rest[schemeIndex + 3 .. $];
    } else if (rest.startsWith("//")) {
      _protocolRelative = true;
      rest = rest[2 .. $];
    } else if (colonIndex > 0 && isScheme(rest[0 .. colonIndex]) && !isPortThenPath(rest[colonIndex + 1 .. $])) {
      // no authority, e.g. mailto:a@b.c (host:port without a scheme stays a host)
      _scheme = rest[0 .. colonIndex].toLower;
      _opaque = rest[colonIndex + 1 .. $];
      return;
    }

    // authority (up to the first '/') and path
    auto pathIndex = rest.indexOf('/');
    parseAuthority(pathIndex >= 0 ? rest[0 .. pathIndex] : rest);
    if (pathIndex >= 0) {
      // decode per segment: an encoded slash belongs to its segment
      setPath(rest[pathIndex .. $]);
      _segments = _segments.map!(segment => percentDecode(segment)).array;
    }
  }

  private void parseAuthority(string authority) {
    auto atIndex = authority.lastIndexOf('@');
    if (atIndex >= 0) {
      _userInfo = authority[0 .. atIndex];
      authority = authority[atIndex + 1 .. $];
    }

    // an IPv6 host contains colons of its own: [::1]:8080
    auto hostEnd = authority.startsWith("[") ? authority.indexOf(']') + 1 : 0;
    auto colonIndex = authority[hostEnd .. $].indexOf(':');
    if (colonIndex >= 0) {
      colonIndex += hostEnd;
      _host = authority[0 .. colonIndex].toLower;
      _port = parsePort(authority[colonIndex + 1 .. $]);
    } else {
      _host = authority.toLower;
    }
  }

  private string _scheme;
  private string _userInfo;
  private string _host;
  private int _port;
  private string _opaque;
  private bool _protocolRelative;
  private string[] _segments;
  private bool _trailingSlash;
  private QueryParams _query;
  private string _fragment;
}

/// RFC 3986 scheme: a letter followed by letters, digits, '+', '-' or '.'
private bool isScheme(string value) {
  return value.length > 0 && value[0].isAlpha
    && value.representation.all!(b => (cast(char)b).isAlphaNum || b == '+' || b == '-' || b == '.');
}

// Whether the text after the first colon reads as a port, as in localhost:8080/path
private bool isPortThenPath(string value) {
  auto pathIndex = value.indexOf('/');
  string port = pathIndex >= 0 ? value[0 .. pathIndex] : value;
  return port.representation.all!(b => (cast(char)b).isDigit);
}

private int parsePort(string value) {
  if (value.length == 0) {
    return 0; // "host:" means the default port
  }
  enforce(value.length <= 5 && value.representation.all!(b => (cast(char)b).isDigit)
      && value.to!int <= 65_535, "Invalid port: " ~ value);
  return value.to!int;
}

/// Schemes isSafeUrl accepts by default
immutable string[] safeUrlSchemes = ["http", "https", "mailto", "tel"];

/**
 * Checks whether a URL from an untrusted source is safe to use in href or src.
 *
 * Relative URLs and the allowed schemes pass; javascript:, data:, vbscript: and any other
 * scheme do not. Whitespace and control characters are ignored first, as browsers ignore them.
 */
bool isSafeUrl(string value, const(string)[] allowedSchemes = safeUrlSchemes) {
  import std.string : indexOfAny;

  auto cleaned = appender!string;
  foreach (char c; value) {
    if (c > ' ' && c != 0x7F) {
      cleaned.put(c);
    }
  }
  string candidate = cleaned.data;
  auto schemeEnd = candidate.indexOfAny(":/?#");
  if (schemeEnd <= 0 || candidate[schemeEnd] != ':') {
    return true;
  }
  return allowedSchemes.canFind(candidate[0 .. schemeEnd].toLower);
}

/// Returns a URL from an untrusted source if it is safe, a fallback otherwise
string safeUrl(string value, string fallback = "#") {
  return isSafeUrl(value) ? value : fallback;
}

/// Creates a URL by parsing a string, e.g. url("https://example.com/path")
Url url(string value) {
  return new Url(value);
}

/// Creates an empty URL builder
Url urlBuilder(string scheme, string host) {
  auto result = new Url("").setScheme(scheme).setHost(host);
  return result;
}

/// Joins a base URL with path segments, e.g. urlJoin("https://api.example.com", "users", "1")
string urlJoin(string base, string[] segments...) {
  auto result = new Url(base);
  foreach (segment; segments.map!(path => path.split("/")).joiner) {
    if (segment.length > 0) {
      result.addSegment(segment);
    }
  }
  return result.toString;
}

///
unittest {
  // parsing
  auto parsed = new Url("https://example.com:8080/users/1?tab=profile&tag=a&tag=b#details");
  assert(parsed.scheme == "https");
  assert(parsed.host == "example.com");
  assert(parsed.port == 8080);
  assert(parsed.path == "/users/1");
  assert(parsed.segments == ["users", "1"]);
  assert(parsed.query.get("tab") == "profile");
  assert(parsed.query.getAll("tag") == ["a", "b"]);
  assert(parsed.fragment == "details");
  assert(parsed.isSecure);

  // simple URL
  auto simple = url("http://example.com");
  assert(simple.scheme == "http");
  assert(simple.host == "example.com");
  assert(simple.port == 0);
  assert(simple.path == "/");
  assert(!simple.isSecure);
  assert(simple.toString == "http://example.com");

  // default ports are not rendered
  assert(url("https://example.com:443/x").toString == "https://example.com/x");
  assert(url("http://example.com:80").toString == "http://example.com");
  assert(url("http://example.com:8080").toString == "http://example.com:8080");

  // round trip
  auto roundTrip = url("https://example.com:8080/users/1?tab=profile#top");
  assert(roundTrip.toString == "https://example.com:8080/users/1?tab=profile#top");

  // building
  auto built = urlBuilder("https", "api.example.com")
    .addSegment("v1")
    .addSegment("users")
    .param("limit", "10")
    .setFragment("top");
  assert(built.toString == "https://api.example.com/v1/users?limit=10#top");
  assert(built.isSecure);
  assert(built.defaultPort == 443);

  built.setPath("/v2/items").setPort(8443);
  assert(built.path == "/v2/items");
  assert(built.toString == "https://api.example.com:8443/v2/items?limit=10#top");

  // segments are encoded
  auto encoded = urlBuilder("https", "example.com").addSegment("a b");
  assert(encoded.toString == "https://example.com/a%20b");

  // join helper
  assert(urlJoin("https://api.example.com", "users", "1") == "https://api.example.com/users/1");
  assert(urlJoin("https://api.example.com/base", "sub") == "https://api.example.com/base/sub");

  // default ports
  assert(url("ftp://host").defaultPort == 21);
  assert(url("ws://host").defaultPort == 80);
  assert(url("wss://host").isSecure);
  assert(url("custom://host").defaultPort == 0);

  // percent-encoded segments are decoded once and encoded once
  assert(url("https://x.io/a%20b").segments == ["a b"]);
  assert(url("https://x.io/a%20b").path == "/a b");
  assert(url("https://x.io/a%20b").toString == "https://x.io/a%20b");
  assert(url("https://x.io/a%2Fb/c").segments == ["a/b", "c"]);
  assert(url("https://x.io/a%2Fb/c").toString == "https://x.io/a%2Fb/c");

  // paths round-trip
  foreach (value; ["https://x.io/", "https://x.io/a/", "https://x.io/a//b", "https://x.io/a;v=1,2/b:c",
      "https://x.io/#/route?a=1", "/relative/path", "/", "file:///etc/hosts", "//cdn.x.io/a.js",
      "https://u:p@x.io:8080/a", "http://[::1]:8080/a", "http://[::1]/a", "mailto:a@b.c",
      "tel:+49123", "mailto:a@b.c?subject=hi", "urn:isbn:123", "example.com:8080/a", "localhost:8080"]) {
    assert(url(value).toString == value, value);
  }
  assert(url("https://x.io/a/").path == "/a/");
  assert(url("https://x.io/a/").addSegment("b").toString == "https://x.io/a/b");
  assert(url("https://x.io").setPath("/").toString == "https://x.io/");

  // authority
  auto full = url("https://u:p@EXAMPLE.com:8080/a");
  assert(full.userInfo == "u:p");
  assert(full.host == "example.com");
  assert(full.port == 8080);
  assert(full.origin == "https://example.com:8080");
  assert(url("https://x.io:443/a").origin == "https://x.io");
  assert(url("https://x.io").setUserInfo("u").toString == "https://u@x.io");
  assert(url("http://u@p@x.io").userInfo == "u@p");

  auto ipv6 = url("http://[::1]:8080/a");
  assert(ipv6.host == "[::1]");
  assert(ipv6.port == 8080);
  assert(url("http://[::1]").port == 0);
  assert(url("http://x.io:/a").port == 0);

  auto protocolRelative = url("//x.io/a");
  assert(protocolRelative.host == "x.io");
  assert(protocolRelative.scheme is null);
  assert(protocolRelative.segments == ["a"]);

  // no authority
  auto mail = url("mailto:a@b.c?subject=hi");
  assert(mail.scheme == "mailto");
  assert(mail.opaque == "a@b.c");
  assert(mail.host is null);
  assert(mail.query.get("subject") == "hi");

  // host and port without a scheme
  assert(url("localhost:8080/a").host == "localhost");
  assert(url("localhost:8080/a").port == 8080);

  // invalid ports are reported
  assertThrown(url("http://x.io:abc/"));
  assertThrown(url("http://x.io:99999/"));

  // non-ASCII input is split at the right byte
  auto unicode = url("https://x.io/ä/ö?ü=1#ß");
  assert(unicode.segments == ["ä", "ö"]);
  assert(unicode.query.get("ü") == "1");
  assert(unicode.fragment == "ß");
  assert(url("https://bücher.de:8080/a").port == 8080);

  // join helper
  assert(urlJoin("https://x.io/", "/a/", "b/c") == "https://x.io/a/b/c");
  assert(urlJoin("https://x.io/base/", "c") == "https://x.io/base/c");

  // untrusted URLs
  foreach (safe; ["https://x.io", "HTTP://x.io", "/a", "a/b:c", "?a=b:c", "#a:b", "//x.io", "mailto:a@b.c", "tel:+49", ""]) {
    assert(isSafeUrl(safe), safe);
  }
  foreach (unsafe; ["javascript:alert(1)", "JaVaScRiPt:alert(1)", " javascript:alert(1)", "java\tscript:alert(1)",
      "java\nscript:alert(1)", "\x01javascript:alert(1)", "data:text/html,x", "vbscript:x", "file:///etc/passwd"]) {
    assert(!isSafeUrl(unsafe), unsafe);
  }
  assert(isSafeUrl("data:image/png;base64,x", ["data"]));
  assert(safeUrl("/a") == "/a");
  assert(safeUrl("javascript:x") == "#");
  assert(safeUrl("javascript:x", "/") == "/");
}
