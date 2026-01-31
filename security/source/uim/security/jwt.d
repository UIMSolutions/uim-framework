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
import std.json : Json, JsonType, parseJson;
import std.string : split;

import uim.security.crypto : constantTimeEquals;

// Note: Json object property access is @system, so we mark functions @trusted where needed

/// Signs a Json payload into a JWT using HS256. Adds `exp` if missing using the provided ttl.
string signJWT(Json claims, string secret, Duration ttl) @trusted {
  enforce(claims.type == JsonType.object, "JWT claims must be a Json object");

  auto header = Json([
    "alg": Json("HS256"),
    "typ": Json("JWT")
  ]);

  auto payload = claims;
  if (!("exp" in payload.object)) {
    auto expires = Clock.currTime() + ttl;
    payload.object["exp"] = Json(expires.toUnixTime());
  }

  auto headerPart = base64Json(header);
  auto payloadPart = base64Json(payload);

  auto signingInput = headerPart ~ "." ~ payloadPart;
  auto signature = hmac!SHA256(cast(const ubyte[]) secret, cast(const ubyte[]) signingInput);
  auto sigPart = cast(string) Base64URLNoPadding.encode(signature);

  return signingInput ~ "." ~ sigPart;
}

/// Verifies a JWT and returns the claims. Throws on invalid signature or expiry.
Json verifyJWT(string token, string secret) @trusted {
  auto parts = token.split(".");
  enforce(parts.length == 3, "JWT must contain three sections");

  auto signingInput = parts[0] ~ "." ~ parts[1];
  auto expectedSig = cast(string) Base64URLNoPadding.encode(hmac!SHA256(cast(const ubyte[]) secret, cast(const ubyte[]) signingInput));
  enforce(constantTimeEquals(expectedSig, parts[2]), "JWT signature mismatch");

  auto payloadBytes = Base64URLNoPadding.decode(parts[1]);
  // Safe to cast: we know these bytes are UTF-8 encoded Json from what we created
  auto payload = parseJson(cast(string) payloadBytes);
  enforce(payload.type == JsonType.object, "JWT payload must be an object");

  if (auto expNode = "exp" in payload.object) {
    auto now = Clock.currTime().toUnixTime();
    enforce(expNode.type == JsonType.integer || expNode.type == JsonType.uinteger, "exp must be numeric");
    long expVal = expNode.type == JsonType.integer ? expNode.integer : cast(long) expNode.uinteger;
    enforce(now <= expVal, "JWT expired");
  }

  return payload;
}

private string base64Json(Json value) @trusted {
  auto json = value.toString();
  return cast(string) Base64URLNoPadding.encode(cast(const ubyte[]) json);
}
