/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.http.headers;

import std.exception : assertThrown, enforce;

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
  permissionsPolicy = "Permissions-Policy",
  referer = "Referer",
  referrerPolicy = "Referrer-Policy",
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

/// Checks whether a string is a valid header name (RFC 9110 token)
bool isHeaderName(string name) {
  return name.length > 0 && name.representation.all!(b => (b >= 'a' && b <= 'z') || (b >= 'A' && b <= 'Z')
      || (b >= '0' && b <= '9') || "!#$%&'*+-.^_`|~".representation.canFind(b));
}

/// Removes the characters that would end a header line, so a value cannot inject further headers
string sanitizeHeaderValue(string value) {
  if (!value.any!(c => c == '\r' || c == '\n' || c == '\0')) {
    return value;
  }
  return value.filter!(c => c != '\r' && c != '\n' && c != '\0').to!string;
}

/**
 * A collection of HTTP headers preserving insertion order.
 *
 * Names are case-insensitive. Values are sanitized against header injection.
 */
class HttpHeaders {
  /// Sets a header, replacing existing values (fluent interface). Throws if the name is invalid.
  auto set(string name, string value) {
    enforce(isHeaderName(name), "Invalid header name: " ~ name);
    auto key = name.toLower;
    if (key !in _headers) {
      _order ~= key;
    }
    _headers[key] = Header(name, [sanitizeHeaderValue(value)]);
    return this;
  }

  /// Adds another value: comma-separated, or a line of its own for Set-Cookie, which cannot be combined (fluent interface)
  auto add(string name, string value) {
    auto key = name.toLower;
    auto header = key in _headers;
    if (header is null) {
      return set(name, value);
    }
    if (key == "set-cookie") {
      header.values ~= sanitizeHeaderValue(value);
    } else {
      header.values[0] ~= ", " ~ sanitizeHeaderValue(value);
    }
    return this;
  }

  /// Removes a header (case-insensitive, fluent interface)
  auto remove(string name) {
    auto key = name.toLower;
    _headers.remove(key);
    _order = _order.filter!(k => k != key).array;
    return this;
  }

  /// Checks whether a header is set (case-insensitive)
  bool has(string name) const {
    return (name.toLower in _headers) !is null;
  }

  /// Returns the value of a header (case-insensitive)
  string get(string name) const {
    auto header = name.toLower in _headers;
    return header is null ? null : header.values[0];
  }

  /// Returns all values of a header (case-insensitive)
  string[] getAll(string name) const {
    auto header = name.toLower in _headers;
    return header is null ? null : header.values.dup;
  }

  /// All header names in insertion order
  string[] names() const {
    string[] result;
    foreach (key; _order) {
      result ~= _headers[key].name;
    }
    return result;
  }

  /// Number of headers
  size_t length() const {
    return _headers.length;
  }

  /// Renders the headers as "Name: Value" lines separated by CRLF
  override string toString() const {
    auto result = appender!string;
    foreach (key; _order) {
      auto header = key in _headers;
      foreach (value; header.values) {
        if (result.data.length > 0) {
          result.put("\r\n");
        }
        result.put(header.name);
        result.put(": ");
        result.put(value);
      }
    }
    return result.data;
  }

  private static struct Header {
    string name;
    string[] values;
  }

  private Header[string] _headers; // by lowercase name
  private string[] _order;
}

/// Creates an empty header collection
HttpHeaders httpHeaders() {
  return new HttpHeaders;
}

/// Creates a header collection from an associative array, sorted by name
HttpHeaders httpHeaders(string[string] values) {
  auto headers = new HttpHeaders;
  foreach (name; values.keys.sort) {
    headers.set(name, values[name]);
  }
  return headers;
}

/**
 * Creates a header collection with defensive defaults for HTML responses.
 *
 * Params:
 *   hstsMaxAge = Enables Strict-Transport-Security for that many seconds. Only use it on sites served entirely over HTTPS.
 */
HttpHeaders securityHeaders(int hstsMaxAge = 0) {
  auto headers = httpHeaders()
    .set(HttpHeader.xContentTypeOptions, "nosniff")
    .set(HttpHeader.xFrameOptions, "DENY")
    .set(HttpHeader.referrerPolicy, "strict-origin-when-cross-origin");
  if (hstsMaxAge > 0) {
    headers.set(HttpHeader.strictTransportSecurity, "max-age=%s; includeSubDomains".format(hstsMaxAge));
  }
  return headers;
}

// #region well-known header lines
/// Content-Type header line for JSON
string contentTypeJson() {
  return "Content-Type: application/json";
}

/// Content-Type header line for HTML
string contentTypeHtml() {
  return "Content-Type: text/html; charset=utf-8";
}

/// Content-Type header line for plain text
string contentTypeText() {
  return "Content-Type: text/plain; charset=utf-8";
}

/// Content-Type header line for form submissions
string contentTypeForm() {
  return "Content-Type: application/x-www-form-urlencoded";
}

/// Authorization header line with a bearer token
string bearerAuth(string token) {
  return "Authorization: Bearer %s".format(sanitizeHeaderValue(token));
}

/// Authorization header line with basic credentials
string basicAuth(string username, string password) {
  import std.base64 : Base64;

  string credentials = "%s:%s".format(username, password);
  return "Authorization: Basic %s".format(Base64.encode(cast(ubyte[])credentials.dup));
}

/// Cache-Control header line disabling caches
string noCache() {
  return "Cache-Control: no-cache, no-store, must-revalidate";
}

/// Cache-Control header line with a max-age in seconds
string cacheMaxAge(int seconds) {
  return "Cache-Control: max-age=%s".format(seconds);
}

/// Location header line for redirects
string locationHeader(string url) {
  return "Location: %s".format(sanitizeHeaderValue(url));
}
// #endregion well-known header lines

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

  /// media-src directive (fluent interface)
  auto mediaSrc(string[] sources...) {
    return directive("media-src", sources);
  }

  /// object-src directive (fluent interface)
  auto objectSrc(string[] sources...) {
    return directive("object-src", sources);
  }

  /// frame-src directive (fluent interface)
  auto frameSrc(string[] sources...) {
    return directive("frame-src", sources);
  }

  /// base-uri directive (fluent interface)
  auto baseUri(string[] sources...) {
    return directive("base-uri", sources);
  }

  /// form-action directive (fluent interface)
  auto formAction(string[] sources...) {
    return directive("form-action", sources);
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

/// CSP source for a nonce, e.g. cspNonce("abc") -> `'nonce-abc'`. Pass the same nonce to scriptTag or styleTag.
string cspNonce(string nonce) {
  return "'nonce-%s'".format(nonce);
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

  assert(csp().objectSrc("'none'").baseUri("'self'").formAction("'self'").mediaSrc("'self'").frameSrc("'none'").toString
    == "object-src 'none'; base-uri 'self'; form-action 'self'; media-src 'self'; frame-src 'none'");
  assert(csp().scriptSrc(cspNonce("abc")).toString == "script-src 'nonce-abc'");

  // names are case-insensitive for every operation
  auto mixedCase = httpHeaders().set("Content-Type", "a").set("content-type", "b");
  assert(mixedCase.length == 1);
  assert(mixedCase.get("CONTENT-TYPE") == "b");
  assert(mixedCase.toString == "content-type: b");
  assert(!httpHeaders().set("A", "1").remove("a").has("A"));
  assert(httpHeaders().set("A", "1").add("a", "2").toString == "A: 1, 2");

  // stable order from maps
  assert(httpHeaders(["B": "2", "A": "1"]).names == ["A", "B"]);

  // values cannot inject further headers
  assert(httpHeaders().set("X", "a\r\nSet-Cookie: x=1").toString == "X: aSet-Cookie: x=1");
  assert(httpHeaders().set("X", "a").add("X", "b\nc").get("X") == "a, bc");
  assert(locationHeader("/a\r\nX: 1") == "Location: /aX: 1");
  assert(bearerAuth("a\nb") == "Authorization: Bearer ab");
  string cleanValue = "clean";
  assert(sanitizeHeaderValue(cleanValue) is cleanValue);

  // invalid names are rejected
  assert(isHeaderName("X-Custom_1"));
  assert(!isHeaderName(""));
  assert(!isHeaderName("A B"));
  assert(!isHeaderName("A:B"));
  assert(!isHeaderName("A\r\nB"));
  assertThrown(httpHeaders().set("A:B", "c"));

  // Set-Cookie lines are never combined
  auto cookies = httpHeaders().add("Set-Cookie", "a=1").add("set-cookie", "b=2");
  assert(cookies.toString == "Set-Cookie: a=1\r\nSet-Cookie: b=2");
  assert(cookies.getAll("Set-Cookie") == ["a=1", "b=2"]);
  assert(cookies.getAll("missing") is null);
  assert(cookies.get("Set-Cookie") == "a=1");

  // security defaults
  auto secure = securityHeaders();
  assert(secure.get("X-Content-Type-Options") == "nosniff");
  assert(secure.get("X-Frame-Options") == "DENY");
  assert(secure.get("Referrer-Policy") == "strict-origin-when-cross-origin");
  assert(!secure.has("Strict-Transport-Security"));
  assert(securityHeaders(31_536_000).get("Strict-Transport-Security") == "max-age=31536000; includeSubDomains");
}
