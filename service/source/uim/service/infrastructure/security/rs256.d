/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
/// RS256 JWT verification with OpenSSL — for SAP XSUAA tokens. Use the
/// "verificationkey" of the XSUAA service binding:
///
/// ---
/// auto uaa = serviceCredentials(config, "xsuaa");
/// controller.verifier = new Rs256TokenVerifier(uaa["verificationkey"].get!string);
/// ---
///
/// Issuer/audience checks are not performed; pin them via expectedAudience if needed.
module uim.service.infrastructure.security.rs256;

import std.base64 : Base64, Base64URLNoPadding;
import deimos.openssl.evp;
import deimos.openssl.x509 : d2i_PUBKEY;
import uim.service;
import uim.service.infrastructure.security.context;

mixin(ShowModule!());

@safe:

class Rs256TokenVerifier : ITokenVerifier {
  protected EVP_PKEY* key;
  protected long leewaySeconds;

  /// Expected "aud" entry (e.g. the XSUAA xsappname); "" = not checked.
  string expectedAudience;

  /// pem: "-----BEGIN PUBLIC KEY-----" block (line breaks optional, as delivered by XSUAA).
  this(string pem, long leewaySeconds = 30) @trusted {
    this.leewaySeconds = leewaySeconds;
    auto body = pem.replace("-----BEGIN PUBLIC KEY-----", "").replace("-----END PUBLIC KEY-----", "")
      .filter!(c => c != '\n' && c != '\r' && c != ' ' && c != '\t').to!string;
    ubyte[] der;
    try
      der = Base64.decode(body);
    catch (Exception e)
      throw new Exception("Invalid PEM public key: " ~ e.msg);
    const(ubyte)* p = der.ptr;
    key = d2i_PUBKEY(null, &p, cast(int) der.length);
    enforce(key !is null, "Invalid PEM public key: not a SubjectPublicKeyInfo");
  }

  ~this() @trusted {
    if (key !is null)
      EVP_PKEY_free(key);
  }

  bool verify(string token, out Json claims) @trusted {
    auto parts = token.split(".");
    if (parts.length != 3)
      return false;
    try {
      auto header = parseJsonString(cast(string) Base64URLNoPadding.decode(parts[0].stripRight("=")));
      if (!header.isObject || "alg" !in header || header["alg"].get!string != "RS256")
        return false;
      auto signature = Base64URLNoPadding.decode(parts[2].stripRight("="));
      auto input = parts[0] ~ "." ~ parts[1];

      auto ctx = EVP_MD_CTX_new();
      if (ctx is null)
        return false;
      scope (exit)
        EVP_MD_CTX_free(ctx);
      if (EVP_DigestVerifyInit(ctx, null, EVP_sha256(), null, key) != 1)
        return false;
      if (EVP_DigestUpdate(ctx, input.ptr, input.length) != 1)
        return false;
      if (EVP_DigestVerifyFinal(ctx, signature.ptr, signature.length) != 1)
        return false;

      claims = decodeJwtPayload(token);
      if (claims.type != Json.Type.object)
        return false;
      auto now = Clock.currTime(UTC()).toUnixTime;
      if ("exp" in claims && claims["exp"].type == Json.Type.int_ && now > claims["exp"].get!long + leewaySeconds)
        return false;
      if ("nbf" in claims && claims["nbf"].type == Json.Type.int_ && now + leewaySeconds < claims["nbf"].get!long)
        return false;
      if (expectedAudience.length > 0) {
        auto aud = "aud" in claims ? claims["aud"] : Json(null);
        bool ok = aud.type == Json.Type.string ? aud.get!string == expectedAudience
          : aud.type == Json.Type.array && aud.get!(Json[]).any!(a => a.type == Json.Type.string && a.get!string == expectedAudience);
        if (!ok)
          return false;
      }
      return true;
    } catch (Exception) {
      return false;
    }
  }
}

///
unittest {
  mixin(ShowTest!("Rs256TokenVerifier"));

  enum pem = `
    -----BEGIN PUBLIC KEY-----
    MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwh1cUKzQmQzn5zOioe8+
    pnRvRdd+6ihJlb5d/PouzK2sqIlardFHQz65mWwlD6xEeMOJjH8SYwGBENbanwmH
    5b/Gb3+hqKHFDwwm0xCykMnlTvTHKavj3ao7RxYbr9Gj68Kw5YLI9C6btVi+BhHa
    amksQQhOmXyVLKjB+vl4kvH7T5HEVnfyLPYsWeLuXXjGam8WbfAAoJ9nYshAXwGD
    2a4GsmlpfwfC2uGNDv19EWf+j7UFB8OagF/3pWGTxGnehHR4aVspDCXTfJW+aetF
    vcKVG6KmsInq7eu3zPDfRleLLPBvRnDnnBfmFn7jHPPXNPqs0F651gIWK//+7KAj
    vwIDAQAB
    -----END PUBLIC KEY-----
`;
  enum token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJ6aWQiOiJ0LXJzIiwidXNlcl9pZCI6InUtcnMiLCJzY29wZSI6WyJjYXRhbG9nLlJlYWQiXX0.BpbNM4UeMYLimo0W8u06kZO4sXyGkG9zDwwFQSub-YxgSSBT7IRDPS7Bqgo8LB580A8OeIYQw1_XCRgGxbNhdswRsgCuTTO5GHih_gRUnudcfrfYxC6gBQC6q6o5xLmmv5He3whkGMGMen1l4u6ZDO70Eas9-FZ5KQTCAePEeQ-DeZ0z8bQO907lKtEEpBn7AxkgEWYYfkZMwUUKerZirp-WbwHgIcdldx6ZYVmdTTWdgvLLcDksvacwoe5DWlwAp6dO7kIftaEG4j9DyEPT9JneI8dzDaOfNQI-4-0MphR8vi0FvvWsAzdVSX1Iho1PgtFOun-UBvAI-OKWy3X4oA";

  auto verifier = new Rs256TokenVerifier(pem);
  Json claims;
  assert(verifier.verify(token, claims));
  assert(claims["zid"].get!string == "t-rs");

  auto ctx = resolveRequestContext("Bearer " ~ token, "", "", "default", verifier);
  assert(ctx.authenticated && ctx.tenantId == "t-rs" && ctx.hasScope("Read"));

  // tampered payload
  auto parts = token.split(".");
  auto forged = parts[0] ~ "." ~ Base64URLNoPadding.encode(cast(const(ubyte)[]) `{"zid":"evil","scope":["catalog.Write"]}`).idup ~ "." ~ parts[2];
  assert(!verifier.verify(forged, claims));

  verifier.expectedAudience = "someone-else";
  assert(!verifier.verify(token, claims));

  bool failed;
  try
    new Rs256TokenVerifier("not a key");
  catch (Exception)
    failed = true;
  assert(failed);
}
