module uim.core.vibe.http.request;

import uim.core;

mixin(ShowModule!());

@safe:

string idFromRequest(scope HTTPServerRequest req) {
    return req.requestPath.to!string.extractIdFromPath;
}

Json bodyFromRequest(scope HTTPServerRequest req) {
    return req.json;
}

// Extract the last path segment (used as an ID)
string extractIdFromPath(HTTPServerRequest req) {
  return req.requestPath.to!string.extractIdFromPath;
}

// Extract the last path segment from a URI (for wildcard routes).
string extractIdFromPath(string uri) {
  // Strip query string
  // import std.string : indexOf;
  auto qpos = uri.indexOf('?');
  string path = qpos >= 0 ? uri[0 .. qpos] : uri;

  // Strip trailing slash
  if (path.length > 0 && path[$ - 1] == '/')
    path = path[0 .. $ - 1];

  // Find last slash
  auto spos = path.lastIndexOf('/');
  if (spos >= 0 && spos + 1 < path.length)
    return path[spos + 1 .. $];
  return path;
}
///
unittest {
  assert(extractIdFromPath("/v1/tenants/abc123") == "abc123");
  assert(extractIdFromPath("/v1/tenants/abc123/") == "abc123");
  assert(extractIdFromPath("/v1/tenants/abc123?foo=bar") == "abc123");
  assert(extractIdFromPath("single") == "single");
}