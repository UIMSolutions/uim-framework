/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.security.jwt;

import std.base64 : Base64URLNoPadding;
import std.datetime : Clock, Duration, SysTime, seconds;
import std.digest.hmac : hmac;
import std.digest.sha : SHA256;
import std.exception : enforce;
import std.json : JSONValue, JSONType, parseJSON;
import std.string : split;

import uim.security.crypto : constantTimeEquals;

@safe:

/// Signs a JSON payload into a JWT using HS256. Adds `exp` if missing using the provided ttl.
string signJWT(JSONValue claims, string secret, Duration ttl) {
  enforce(claims.type == JSONType.object, "JWT claims must be a JSON object");

  auto header = JSONValue([
    "alg": JSONValue("HS256"),
    "typ": JSONValue("JWT")
  ]);

  auto payload = claims;
  if (!("exp" in payload.object)) {
    auto expires = Clock.currTime() + ttl;
    payload.object["exp"] = JSONValue(expires.toUnixTime());
  }

  auto headerPart = base64Json(header);
  auto payloadPart = base64Json(payload);

  auto signingInput = headerPart ~ "." ~ payloadPart;
  auto signature = hmac!SHA256(cast(const ubyte[]) secret, cast(const ubyte[]) signingInput);
  auto sigPart = Base64URLNoPadding.encode(signature);

  return signingInput ~ "." ~ sigPart;
}

/// Verifies a JWT and returns the claims. Throws on invalid signature or expiry.
JSONValue verifyJWT(string token, string secret) {
  auto parts = token.split(".");
  enforce(parts.length == 3, "JWT must contain three sections");

  auto signingInput = parts[0] ~ "." ~ parts[1];
  auto expectedSig = Base64URLNoPadding.encode(hmac!SHA256(cast(const ubyte[]) secret, cast(const ubyte[]) signingInput));
  enforce(constantTimeEquals(expectedSig, parts[2]), "JWT signature mismatch");

  auto payloadBytes = Base64URLNoPadding.decode(parts[1]);
  auto payload = parseJSON(cast(string) payloadBytes);
  enforce(payload.type == JSONType.object, "JWT payload must be an object");

  if (auto expNode = "exp" in payload.object) {
    auto now = Clock.currTime().toUnixTime();
    enforce(expNode.type == JSONType.integer || expNode.type == JSONType.uinteger, "exp must be numeric");
    long expVal = expNode.type == JSONType.integer ? expNode.integer : cast(long) expNode.uinteger;
    enforce(now <= expVal, "JWT expired");
  }

  return payload;
}

private string base64Json(JSONValue value) {
  auto json = value.toString();
  return Base64URLNoPadding.encode(cast(const ubyte[]) json);
}
