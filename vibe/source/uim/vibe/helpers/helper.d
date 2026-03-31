module uim.vibe.helpers.helper;

import uim.vibe;

@safe:
/// CORS middleware - adds cross-origin headers for browser access.
void corsMiddleware(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    res.headers["Access-Control-Allow-Origin"] = "*";
    res.headers["Access-Control-Allow-Methods"] = "GET, POST, PUT, DELETE, OPTIONS";
    res.headers["Access-Control-Allow-Headers"] = "Content-Type, Authorization, X-Request-Id";
}

/// Request logging middleware.
void requestLogger(scope HTTPServerRequest req, scope HTTPServerResponse res) {
    import std.conv : to;
    logInfo("%s %s", req.method.to!string, req.requestURI);
}
