/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.security.crypto;

import std.array : appender;
import std.base64 : Base64URLNoPadding;
import std.conv : to;
import std.digest.hmac : hmac;
import std.digest.sha : SHA256;
import std.exception : enforce;
import std.format : formattedWrite;
import std.random : Random, unpredictableSeed, uniform;
import std.string : split;

// @safe version: we mark functions as @trusted where needed

/// Generates a random salt encoded as base64url.
string randomSalt(size_t length = 16) @trusted {
  enforce(length > 0, "Salt length must be positive");
  auto rng = Random(unpredictableSeed);
  auto bytes = new ubyte[length];
  foreach (i; 0 .. length) {
    bytes[i] = cast(ubyte) uniform(0, 256, rng);
  }
  return Base64URLNoPadding.encode(bytes);
}

/// Derives a key using PBKDF2-HMAC-SHA256.
ubyte[] pbkdf2HmacSha256(string password, string salt, uint iterations = 20_000, size_t dkLen = 32) @trusted {
  enforce(iterations > 0, "Iterations must be positive");
  enforce(dkLen > 0, "Derived key length must be positive");

  immutable(ubyte)[] pwd = cast(immutable ubyte[]) password;
  immutable(ubyte)[] saltBytes = cast(immutable ubyte[]) Base64URLNoPadding.decode(salt);

  enum size_t hLen = 32;
  auto blocks = (dkLen + hLen - 1) / hLen;
  auto output = new ubyte[blocks * hLen];

  foreach (bi; 0 .. blocks) {
    ubyte[4] counter;
    counter[0] = cast(ubyte)((bi + 1) >> 24);
    counter[1] = cast(ubyte)((bi + 1) >> 16);
    counter[2] = cast(ubyte)((bi + 1) >> 8);
    counter[3] = cast(ubyte)((bi + 1));

    auto saltBlock = new ubyte[saltBytes.length + 4];
    saltBlock[0 .. saltBytes.length] = saltBytes[];
    saltBlock[saltBytes.length .. $] = counter[];

    auto uTemp = hmac!SHA256(pwd, saltBlock);
    auto block = uTemp[];
    auto accum = block.dup;

    foreach (iter; 1 .. iterations) {
      uTemp = hmac!SHA256(pwd, block);
      block = uTemp[];
      foreach (i; 0 .. hLen) {
        accum[i] ^= block[i];
      }
    }

    output[bi * hLen .. (bi + 1) * hLen] = accum[];
  }

  return output[0 .. dkLen].dup;
}

/// Creates a password hash string in the form "pbkdf2$ITER$SALT$HASH".
string hashPassword(string password, string salt = randomSalt(), uint iterations = 20_000, size_t keyLength = 32) @trusted {
  auto derived = pbkdf2HmacSha256(password, salt, iterations, keyLength);
  return "pbkdf2$" ~ to!string(iterations) ~ "$" ~ salt ~ "$" ~ (cast(string) Base64URLNoPadding.encode(derived));
}
/// Verifies a password against a stored hash produced by `hashPassword`.
bool verifyPassword(string password, string stored) @trusted {
  auto parts = stored.split("$");
  enforce(parts.length == 4 && parts[0] == "pbkdf2", "Stored hash format invalid");

  uint iterations = to!uint(parts[1]);
  auto salt = parts[2];
  auto expected = parts[3];

  auto derived = pbkdf2HmacSha256(password, salt, iterations, Base64URLNoPadding.decode(expected).length);
  auto actualEncoded = cast(string) Base64URLNoPadding.encode(derived);

  return constantTimeEquals(actualEncoded, expected);
}

/// Constant-time comparison to mitigate timing side channels.
bool constantTimeEquals(string a, string b) @safe nothrow pure {
  size_t maxLen = a.length > b.length ? a.length : b.length;
  ubyte diff = cast(ubyte)(a.length ^ b.length);
  foreach (i; 0 .. maxLen) {
    auto ca = i < a.length ? cast(ubyte) a[i] : cast(ubyte)0;
    auto cb = i < b.length ? cast(ubyte) b[i] : cast(ubyte)0;
    diff |= ca ^ cb;
  }
  return diff == 0;
}

/// Encodes bytes as lowercase hex.
string toHex(const ubyte[] data) {
  auto app = appender!string();
  foreach (b; data) {
    formattedWrite(app, "%02x", b);
  }
  return app.data;
}
