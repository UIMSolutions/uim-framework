module uim.services.presentation.http.helpers.http.request;

import uim.core;

mixin(ShowModule!());

@safe:

Json bodyFromRequest(scope HTTPServerRequest req) {
    return req.json;
}

// Extract the last path segment (used as an ID)
string extractId(HTTPServerRequest req) {
  return req.requestPath.to!string.extractId;
}

// Extract the last path segment from a URI (for wildcard routes).
string extractId(string uri) {
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
  assert(extractId("/v1/tenants/abc123") == "abc123");
  assert(extractId("/v1/tenants/abc123/") == "abc123");
  assert(extractId("/v1/tenants/abc123?foo=bar") == "abc123");
  assert(extractId("single") == "single");
}