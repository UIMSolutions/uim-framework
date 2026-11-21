/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// Resolution of the RequestContext from HTTP headers.
///
/// Behind the SAP approuter every request carries an XSUAA JWT
/// ("Authorization: Bearer <jwt>"). Tenant (zid) and user are taken from the
/// token; scopes are only trusted if an ITokenVerifier verified the
/// signature. Without a verifier the token is decoded for identification
/// only (authenticated = false, no scopes) — enable scope enforcement only
/// together with a verifier.
module uim.service.infrastructure.security.context;

import std.base64 : Base64URLNoPadding;
import std.digest.hmac : HMAC;
import std.digest.sha : SHA256;
import uim.service;
import uim.service.ports.services.context;

mixin(ShowModule!());

@safe:

/// Verifies a compact JWS and returns its claims.
interface ITokenVerifier {
  /// True if the token is valid (signature, expiry); claims receives the payload.
  bool verify(string token, out Json claims);
}

/// Decode the payload of a compact JWT without verifying it. Json(null) if malformed.
Json decodeJwtPayload(string token) @trusted {
  auto parts = token.split(".");
  if (parts.length != 3)
    return Json(null);
  try {
    auto payload = cast(string) Base64URLNoPadding.decode(parts[1].stripRight("="));
    auto claims = parseJsonString(payload);
    return claims.isObject ? claims : Json(null);
  } catch (Exception) {
    return Json(null);
  }
}

/// HS256 verifier (shared secret) with expiry/not-before checks — for
/// service-to-service tokens and tests. XSUAA (RS256) tokens need an
/// RSA verifier implementing ITokenVerifier.
class Hs256TokenVerifier : ITokenVerifier {
  protected immutable(ubyte)[] secret;
  protected long leewaySeconds;

  this(string secret, long leewaySeconds = 30) {
    this.secret = cast(immutable(ubyte)[]) secret.idup;
    this.leewaySeconds = leewaySeconds;
  }

  bool verify(string token, out Json claims) @trusted {
    auto parts = token.split(".");
    if (parts.length != 3)
      return false;
    try {
      auto header = parseJsonString(cast(string) Base64URLNoPadding.decode(parts[0].stripRight("=")));
      if (!header.isObject || "alg" !in header || header["alg"].get!string != "HS256")
        return false;
      auto signature = Base64URLNoPadding.decode(parts[2].stripRight("="));
      auto expected = HMAC!SHA256(secret).put(cast(const(ubyte)[])(parts[0] ~ "." ~ parts[1])).finish();
      if (!constantTimeEquals(signature, expected[]))
        return false;
      claims = decodeJwtPayload(token);
      if (claims.type != Json.Type.object)
        return false;
      auto now = Clock.currTime(UTC()).toUnixTime;
      if ("exp" in claims && claims["exp"].type == Json.Type.int_ && now > claims["exp"].get!long + leewaySeconds)
        return false;
      if ("nbf" in claims && claims["nbf"].type == Json.Type.int_ && now + leewaySeconds < claims["nbf"].get!long)
        return false;
      return true;
    } catch (Exception) {
      return false;
    }
  }

  /// Sign claims (for tests and internal callers).
  string sign(Json claims) @trusted {
    auto header = Base64URLNoPadding.encode(cast(const(ubyte)[]) `{"alg":"HS256","typ":"JWT"}`);
    auto payload = Base64URLNoPadding.encode(cast(const(ubyte)[]) claims.toString);
    auto input = (header ~ "." ~ payload).idup;
    auto sig = HMAC!SHA256(secret).put(cast(const(ubyte)[]) input).finish();
    return input ~ "." ~ Base64URLNoPadding.encode(sig[]).idup;
  }
}

private bool constantTimeEquals(const(ubyte)[] a, const(ubyte)[] b) pure nothrow {
  if (a.length != b.length)
    return false;
  ubyte diff;
  foreach (i; 0 .. a.length)
    diff |= a[i] ^ b[i];
  return diff == 0;
}

private string claimString(Json claims, string[] names...) {
  foreach (n; names)
    if (n in claims && claims[n].type == Json.Type.string && claims[n].get!string.length > 0)
      return claims[n].get!string;
  return "";
}

/// Build the RequestContext of an HTTP request.
///   authorization  "Authorization" header ("Bearer <jwt>" or "")
///   tenantHeader   "X-Tenant-Id" header (used if no token tenant)
///   userHeader     "X-User-Id" header (used if no token user)
///   verifier       optional token verifier (null = decode only)
RequestContext resolveRequestContext(string authorization, string tenantHeader, string userHeader,
    string defaultTenant, ITokenVerifier verifier = null) {
  RequestContext ctx;
  ctx.channel = "http";

  auto auth = authorization.strip;
  if (auth.length > 7 && auth[0 .. 7].toLower == "bearer ") {
    auto token = auth[7 .. $].strip;
    Json claims;
    if (verifier !is null && verifier.verify(token, claims)) {
      ctx.authenticated = true;
      if ("scope" in claims && claims["scope"].type == Json.Type.array)
        foreach (s; claims["scope"].get!(Json[]))
          if (s.type == Json.Type.string)
            ctx.scopes ~= s.get!string;
    } else if (verifier is null) {
      claims = decodeJwtPayload(token);
    }
    if (claims.isObject) {
      ctx.tenantId = claimString(claims, "zid", "zone_uuid", "tenant", "tenantId");
      ctx.userId = claimString(claims, "user_id", "sub", "user_name", "client_id");
      ctx.userName = claimString(claims, "user_name", "email", "given_name");
    }
  }

  if (ctx.tenantId.length == 0)
    ctx.tenantId = tenantHeader.strip.length > 0 ? tenantHeader.strip : defaultTenant;
  if (ctx.userId.length == 0)
    ctx.userId = userHeader.strip;
  if (ctx.userName.length == 0)
    ctx.userName = ctx.userId;
  return ctx;
}

///
unittest {
  mixin(ShowTest!("resolveRequestContext"));

  auto payload = Base64URLNoPadding.encode(cast(const(ubyte)[]) `{"zid":"tenant-a","user_name":"jane","scope":["app.Read"]}`);
  auto unsigned = "eyJhbGciOiJub25lIn0." ~ payload.idup ~ ".sig";

  // decode only: identity yes, scopes no
  auto decoded = resolveRequestContext("Bearer " ~ unsigned, "", "", "default");
  assert(decoded.tenantId == "tenant-a" && decoded.userName == "jane");
  assert(!decoded.authenticated && decoded.scopes.length == 0);

  // verified HS256 token: scopes are trusted
  auto verifier = new Hs256TokenVerifier("s3cret");
  auto claims = parseJsonString(`{"zid":"t9","user_id":"u1","scope":["app.Read","app.Write"]}`);
  auto token = verifier.sign(claims);
  auto verified = resolveRequestContext("Bearer " ~ token, "", "", "default", verifier);
  assert(verified.authenticated && verified.tenantId == "t9" && verified.hasScope("Write"));

  // tampered / wrong secret / unsigned token with a verifier → anonymous
  auto other = new Hs256TokenVerifier("other");
  assert(!resolveRequestContext("Bearer " ~ token, "", "", "d", other).authenticated);
  assert(resolveRequestContext("Bearer " ~ unsigned, "", "", "d", verifier).tenantId == "d");

  // expired
  auto expired = verifier.sign(parseJsonString(`{"zid":"t","exp":1000}`));
  Json ignored;
  assert(!verifier.verify(expired, ignored));

  // headers fallback
  auto fromHeader = resolveRequestContext("", "t2", "bob", "default");
  assert(fromHeader.tenantId == "t2" && fromHeader.userId == "bob");
  assert(resolveRequestContext("", "", "", "default").tenantId == "default");
}
