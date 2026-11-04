/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.url.url;

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

  /// The path, e.g. "/users/1"
  string path() const {
    return "/" ~ _segments.join("/");
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

  /// Sets the path from a string (fluent interface)
  auto setPath(string value) {
    _segments = value.split("/").filter!(segment => segment.length > 0).array;
    return this;
  }

  /// Appends a path segment (fluent interface)
  auto addSegment(string segment) {
    _segments ~= segment;
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

  /// Renders the complete URL
  override string toString() const {
    auto result = appender!string;
    if (_scheme.length > 0) {
      result.put(_scheme ~ "://");
    }
    result.put(_host);
    if (_port > 0 && _port != defaultPort) {
      result.put(":%s".format(_port));
    }
    if (_segments.length > 0) {
      result.put("/" ~ _segments.map!(segment => percentEncode(segment)).join("/"));
    }
    string queryString = _query.toString;
    if (queryString.length > 0) {
      result.put("?" ~ queryString);
    }
    if (_fragment.length > 0) {
      result.put("#" ~ percentEncode(_fragment));
    }
    return result.data;
  }

  private void parse(string url) {
    string rest = url;

    // fragment
    auto hashIndex = rest.countUntil('#');
    if (hashIndex >= 0) {
      _fragment = percentDecode(rest[hashIndex + 1 .. $]);
      rest = rest[0 .. hashIndex];
    }

    // query
    auto queryIndex = rest.countUntil('?');
    if (queryIndex >= 0) {
      _query = parseQuery(rest[queryIndex + 1 .. $]);
      rest = rest[0 .. queryIndex];
    }

    // scheme
    auto schemeIndex = rest.countUntil("://");
    if (schemeIndex >= 0) {
      _scheme = rest[0 .. schemeIndex].toLower;
      rest = rest[schemeIndex + 3 .. $];
    }

    // host and port (up to the first '/')
    auto pathIndex = rest.countUntil('/');
    string authority = pathIndex >= 0 ? rest[0 .. pathIndex] : rest;
    string pathPart = pathIndex >= 0 ? rest[pathIndex .. $] : null;

    auto colonIndex = authority.countUntil(':');
    if (colonIndex >= 0) {
      _host = authority[0 .. colonIndex];
      _port = authority[colonIndex + 1 .. $].to!int;
    } else {
      _host = authority;
    }

    setPath(pathPart);
  }

  private string _scheme;
  private string _host;
  private int _port;
  private string[] _segments;
  private QueryParams _query;
  private string _fragment;
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
  foreach (segment; segments) {
    result.addSegment(segment);
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
}
