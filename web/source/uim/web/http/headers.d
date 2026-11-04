/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.http.headers;

import uim.web;

mixin(ShowModule!());

@safe:

// #region common header names
/// Common HTTP header names
enum HttpHeader {
  accept = "Accept",
  acceptEncoding = "Accept-Encoding",
  acceptLanguage = "Accept-Language",
  authorization = "Authorization",
  cacheControl = "Cache-Control",
  contentDisposition = "Content-Disposition",
  contentEncoding = "Content-Encoding",
  contentLength = "Content-Length",
  contentSecurityPolicy = "Content-Security-Policy",
  contentType = "Content-Type",
  cookie = "Cookie",
  etag = "ETag",
  expires = "Expires",
  host = "Host",
  ifModifiedSince = "If-Modified-Since",
  ifNoneMatch = "If-None-Match",
  lastModified = "Last-Modified",
  location = "Location",
  origin = "Origin",
  referer = "Referer",
  server = "Server",
  setCookie = "Set-Cookie",
  strictTransportSecurity = "Strict-Transport-Security",
  userAgent = "User-Agent",
  wwwAuthenticate = "WWW-Authenticate",
  xContentTypeOptions = "X-Content-Type-Options",
  xFrameOptions = "X-Frame-Options",
  xRequestedWith = "X-Requested-With"
}
// #endregion common header names

/// A collection of HTTP headers preserving insertion order.
class HttpHeaders {
  /// Sets a header (fluent interface)
  auto set(string name, string value) {
    if (name !in _headers) {
      _order ~= name;
    }
    _headers[name] = value;
    return this;
  }

  /// Adds another value to an existing header (comma-separated, fluent interface)
  auto add(string name, string value) {
    auto existing = get(name);
    return existing is null
      ? set(name, value)
      : set(name, existing ~ ", " ~ value);
  }

  /// Removes a header (fluent interface)
  auto remove(string name) {
    _headers.remove(name);
    _order = _order.filter!(n => n != name).array;
    return this;
  }

  /// Checks whether a header is set (case-insensitive)
  bool has(string name) const {
    return _headers.keys.any!(key => key.toLower == name.toLower);
  }

  /// Returns the value of a header (case-insensitive)
  string get(string name) const {
    foreach (key, value; _headers) {
      if (key.toLower == name.toLower) {
        return value;
      }
    }
    return null;
  }

  /// All header names in insertion order
  string[] names() const {
    return _order.dup;
  }

  /// Number of headers
  size_t length() const {
    return _headers.length;
  }

  /// Renders the headers as "Name: Value" lines separated by CRLF
  override string toString() const {
    return _order
      .filter!(name => name in _headers)
      .map!(name => "%s: %s".format(name, _headers[name]))
      .join("\r\n");
  }

  private string[string] _headers;
  private string[] _order;
}

/// Creates an empty header collection
HttpHeaders httpHeaders() {
  return new HttpHeaders;
}

/// Creates a header collection from an associative array
HttpHeaders httpHeaders(string[string] values) {
  auto headers = new HttpHeaders;
  foreach (name, value; values) {
    headers.set(name, value);
  }
  return headers;
}

// #region well-known header values
/// Content-Type header value for JSON
string contentTypeJson() {
  return "Content-Type: application/json";
}

/// Content-Type header value for HTML
string contentTypeHtml() {
  return "Content-Type: text/html; charset=utf-8";
}

/// Content-Type header value for plain text
string contentTypeText() {
  return "Content-Type: text/plain; charset=utf-8";
}

/// Content-Type header value for form submissions
string contentTypeForm() {
  return "Content-Type: application/x-www-form-urlencoded";
}

/// Authorization header value with a bearer token
string bearerAuth(string token) {
  return "Authorization: Bearer %s".format(token);
}

/// Authorization header value with basic credentials
string basicAuth(string username, string password) {
  import std.base64 : Base64;

  string credentials = "%s:%s".format(username, password);
  return "Authorization: Basic %s".format(Base64.encode(cast(ubyte[])credentials.dup));
}

/// Cache-Control header value disabling caches
string noCache() {
  return "Cache-Control: no-cache, no-store, must-revalidate";
}

/// Cache-Control header value with a max-age in seconds
string cacheMaxAge(int seconds) {
  return "Cache-Control: max-age=%s".format(seconds);
}

/// Location header value for redirects
string locationHeader(string url) {
  return "Location: %s".format(url);
}
// #endregion well-known header values

/// A builder for Content-Security-Policy header values.
class CspBuilder {
  /// Adds a directive with sources (fluent interface), e.g. directive("default-src", ["'self'"])
  auto directive(string name, string[] sources...) {
    _directives[name] = sources.dup;
    if (!_order.canFind(name)) {
      _order ~= name;
    }
    return this;
  }

  /// default-src directive (fluent interface)
  auto defaultSrc(string[] sources...) {
    return directive("default-src", sources);
  }

  /// script-src directive (fluent interface)
  auto scriptSrc(string[] sources...) {
    return directive("script-src", sources);
  }

  /// style-src directive (fluent interface)
  auto styleSrc(string[] sources...) {
    return directive("style-src", sources);
  }

  /// img-src directive (fluent interface)
  auto imgSrc(string[] sources...) {
    return directive("img-src", sources);
  }

  /// connect-src directive (fluent interface)
  auto connectSrc(string[] sources...) {
    return directive("connect-src", sources);
  }

  /// font-src directive (fluent interface)
  auto fontSrc(string[] sources...) {
    return directive("font-src", sources);
  }

  /// frame-ancestors directive (fluent interface)
  auto frameAncestors(string[] sources...) {
    return directive("frame-ancestors", sources);
  }

  /// Renders the CSP header value, e.g. "default-src 'self'; script-src 'none'"
  override string toString() const {
    return _order
      .filter!(name => name in _directives)
      .map!(name => ([name] ~ _directives[name]).join(" "))
      .join("; ");
  }

  /// Renders the complete CSP header line
  string toHeader() const {
    // cast to string: %s would format the enum member name instead of its value
    return "%s: %s".format(cast(string)HttpHeader.contentSecurityPolicy, toString);
  }

  private string[][string] _directives;
  private string[] _order;
}

/// Creates a CSP builder
CspBuilder csp() {
  return new CspBuilder;
}

///
unittest {
  // header name constants
  assert(HttpHeader.contentType == "Content-Type");
  assert(HttpHeader.authorization == "Authorization");

  // collection
  auto headers = new HttpHeaders;
  assert(headers.length == 0);

  headers.set("Content-Type", "application/json").set("Accept", "text/html");
  assert(headers.length == 2);
  assert(headers.has("content-type")); // case-insensitive
  assert(headers.get("ACCEPT") == "text/html");
  assert(headers.get("missing") is null);
  assert(headers.names == ["Content-Type", "Accept"]);
  assert(headers.toString == "Content-Type: application/json\r\nAccept: text/html");

  headers.add("Accept", "application/json");
  assert(headers.get("Accept") == "text/html, application/json");

  headers.set("Content-Type", "text/html"); // replace keeps position
  assert(headers.names == ["Content-Type", "Accept"]);

  headers.remove("Accept");
  assert(!headers.has("Accept"));
  assert(headers.names == ["Content-Type"]);

  auto fromMap = httpHeaders(["A": "1", "B": "2"]);
  assert(fromMap.length == 2);

  // well-known values
  assert(contentTypeJson == "Content-Type: application/json");
  assert(contentTypeHtml == "Content-Type: text/html; charset=utf-8");
  assert(contentTypeText == "Content-Type: text/plain; charset=utf-8");
  assert(contentTypeForm == "Content-Type: application/x-www-form-urlencoded");
  assert(bearerAuth("tok") == "Authorization: Bearer tok");
  assert(basicAuth("user", "pass") == "Authorization: Basic dXNlcjpwYXNz");
  assert(noCache == "Cache-Control: no-cache, no-store, must-revalidate");
  assert(cacheMaxAge(3600) == "Cache-Control: max-age=3600");
  assert(locationHeader("/home") == "Location: /home");

  // CSP builder
  auto policy = csp()
    .defaultSrc("'self'")
    .scriptSrc("'self'", "https://cdn.example.com")
    .imgSrc("'self'", "data:");
  assert(policy.toString == "default-src 'self'; script-src 'self' https://cdn.example.com; img-src 'self' data:");
  assert(policy.toHeader == "Content-Security-Policy: " ~ policy.toString);

  assert(csp().frameAncestors("'none'").toString == "frame-ancestors 'none'");
  assert(csp().styleSrc("'self'").connectSrc("https://api.example.com").fontSrc("'self'").toString
    == "style-src 'self'; connect-src https://api.example.com; font-src 'self'");
}
