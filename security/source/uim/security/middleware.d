/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.security.middleware;

import std.exception : enforce;
import std.json : Json, JsonType;

import vibe.http.server : HTTPServerRequest, HTTPServerResponse;

import uim.security.auth;
import uim.security.jwt;
import uim.security.rate_limit;

// Note: vibe.d HTTP handlers involve @system types, so we mark as @trusted where needed

/// Validates an API key from a header. Returns true if accepted and writes 401 otherwise.
bool authenticateApiKey(scope HTTPServerRequest req, scope HTTPServerResponse res, string headerName, ApiKey[] allowed) @trusted {
  auto id = req.headers.get(headerName ~ "-Id", "");
  auto secret = req.headers.get(headerName ~ "-Secret", "");

  if (validateApiKey(allowed, id, secret)) {
    return true;
  }

  res.statusCode = 401;
  res.headers["Content-Type"] = "application/json";
  res.writeBody("{\"error\":\"invalid api key\"}");
  return false;
}

/// Validates a Bearer JWT from the Authorization header. Returns false and writes 401 on failure.
bool authenticateBearerJWT(scope HTTPServerRequest req, scope HTTPServerResponse res, string secret, out Json claims) @trusted {
  auto authHeader = req.headers.get("Authorization", "");
  enum prefix = "Bearer ";
  if (authHeader.length <= prefix.length || authHeader[0 .. prefix.length] != prefix) {
    res.statusCode = 401;
    res.headers["Content-Type"] = "application/json";
    res.writeBody("{\"error\":\"missing bearer token\"}");
    return false;
  }

  auto token = authHeader[prefix.length .. $];
  try {
    claims = verifyJWT(token, secret);
    return true;
  } catch (Exception e) {
    res.statusCode = 401;
    res.headers["Content-Type"] = "application/json";
    res.writeBody("{\"error\":\"" ~ e.msg ~ "\"}");
    return false;
  }
}

/// Enforces a token bucket rate limit. Returns false and writes 429 on rejection.
bool enforceRateLimit(TokenBucketRateLimiter limiter, string clientId, scope HTTPServerResponse res) @trusted {
  if (limiter.allow(clientId)) {
    return true;
  }
  res.statusCode = 429;
  res.headers["Content-Type"] = "application/json";
  res.writeBody("{\"error\":\"rate limit exceeded\"}");
  return false;
}
