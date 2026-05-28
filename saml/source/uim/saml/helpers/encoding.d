/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.saml.helpers.encoding;

import std.base64;

@safe:

// ---------------------------------------------------------------------------
// Base64 standard encoding (for HTTP-POST binding SAMLResponse)
// ---------------------------------------------------------------------------

/// Base64-encode a byte array (standard alphabet, with padding)
string samlBase64Encode(const(ubyte)[] data) {
  return Base64.encode(data);
}

/// Decode a standard base64 string to bytes
ubyte[] samlBase64Decode(string encoded) {
  try {
    return Base64.decode(encoded);
  } catch (Exception) {
    return null;
  }
}

/// Base64-encode a string (convenience overload for XML payloads)
string samlBase64EncodeString(string data) @trusted {
  return samlBase64Encode(cast(const(ubyte)[]) data);
}

/// Base64-decode to a string (convenience overload)
string samlBase64DecodeString(string encoded) {
  auto bytes = samlBase64Decode(encoded);
  if (bytes is null) return "";
  return cast(string) bytes.idup;
}

// ---------------------------------------------------------------------------
// Base64 URL-safe encoding (for HTTP-Redirect binding SAMLRequest)
// RFC 4648 §5: uses - and _ instead of + and /; no padding
// ---------------------------------------------------------------------------

/// Base64-URL-encode a byte array (no padding)
string samlBase64UrlEncode(const(ubyte)[] data) {
  return Base64URL.encode(data);
}

/// Base64-URL-decode a string to bytes
ubyte[] samlBase64UrlDecode(string encoded) {
  // Add padding if needed
  auto padded = _addBase64Padding(encoded);
  try {
    return Base64URL.decode(padded);
  } catch (Exception) {
    return null;
  }
}

private string _addBase64Padding(string s) @safe {
  auto rem = s.length % 4;
  if (rem == 0) return s;
  if (rem == 2) return s ~ "==";
  if (rem == 3) return s ~ "=";
  return s;
}

// ---------------------------------------------------------------------------
// DEFLATE / INFLATE for HTTP-Redirect binding (RFC 1951 raw DEFLATE)
//
// SAML HTTP-Redirect binding (section 3.4.4.1 of the SAML Bindings spec)
// requires raw DEFLATE (RFC 1951) without the zlib header/trailer.
//
// std.zlib.compress() produces zlib format (RFC 1950):
//   [2-byte header][raw DEFLATE data][4-byte Adler-32]
//
// We strip the 2-byte header and 4-byte trailer to get pure raw DEFLATE.
// For inflate, std.zlib.uncompress() supports winbits=-15 (raw inflate).
// ---------------------------------------------------------------------------

/// Compress data using raw DEFLATE (suitable for SAML HTTP-Redirect SAMLRequest)
ubyte[] samlDeflate(const(ubyte)[] data) @trusted {
  import std.zlib : compress;
  auto compressed = cast(ubyte[]) compress(cast(const(void)[]) data);
  // Strip 2-byte zlib header and 4-byte Adler-32 checksum
  if (compressed.length > 6) {
    return compressed[2 .. $ - 4].dup;
  }
  return [];
}

/// Decompress raw DEFLATE data (as received in SAML HTTP-Redirect SAMLRequest)
ubyte[] samlInflate(const(ubyte)[] rawData) @trusted {
  import std.zlib : uncompress;
  // winbits = -15 selects raw inflate in zlib
  try {
    auto decompressed = cast(ubyte[]) uncompress(cast(const(void)[]) rawData, 0, -15);
    return decompressed;
  } catch (Exception) {
    return null;
  }
}

/// Convenience: deflate a string and return raw DEFLATE bytes
ubyte[] samlDeflateString(string data) @trusted {
  return samlDeflate(cast(const(ubyte)[]) data);
}

/// Convenience: inflate raw DEFLATE bytes and return as string
string samlInflateString(const(ubyte)[] rawData) @trusted {
  auto result = samlInflate(rawData);
  if (result is null) return "";
  return cast(string) result.idup;
}

// ---------------------------------------------------------------------------
// URL-encoding helpers (for the HTTP-Redirect query string)
// ---------------------------------------------------------------------------

/// Percent-encode a string for use as a query parameter value (RFC 3986)
string samlUrlEncode(string value) @safe {
  import std.array : appender;
  auto buf = appender!string;
  buf.reserve(value.length + 16);
  foreach (ubyte b; cast(immutable(ubyte)[]) value) {
    if (_urlSafe(b)) {
      buf ~= cast(char) b;
    } else {
      import std.format : formattedWrite;
      buf ~= '%';
      immutable ubyte hi = (b >> 4) & 0x0F;
      immutable ubyte lo = b & 0x0F;
      buf ~= cast(char)(hi < 10 ? '0' + hi : 'A' + hi - 10);
      buf ~= cast(char)(lo < 10 ? '0' + lo : 'A' + lo - 10);
    }
  }
  return buf.data;
}

private bool _urlSafe(ubyte b) pure nothrow @safe {
  // Unreserved characters per RFC 3986 §2.3
  return (b >= 'A' && b <= 'Z') ||
         (b >= 'a' && b <= 'z') ||
         (b >= '0' && b <= '9') ||
         b == '-' || b == '_' || b == '.' || b == '~';
}

// ---------------------------------------------------------------------------
// Unit tests
// ---------------------------------------------------------------------------

unittest {
  // Base64 round-trip
  auto data   = cast(ubyte[]) "Hello SAML".dup;
  auto enc    = samlBase64Encode(data);
  auto dec    = samlBase64Decode(enc);
  assert(dec == data);

  // Base64URL round-trip (no padding)
  auto encUrl = samlBase64UrlEncode(data);
  assert(encUrl.length > 0);
  auto decUrl = samlBase64UrlDecode(encUrl);
  assert(decUrl == data);

  // Deflate / inflate round-trip
  string xml  = `<samlp:AuthnRequest ID="_abc123" Version="2.0"/>`;
  auto deflated = samlDeflateString(xml);
  assert(deflated.length > 0);
  auto inflated = samlInflateString(deflated);
  assert(inflated == xml);

  // URL encoding
  assert(samlUrlEncode("hello world+test") == "hello%20world%2Btest");
  assert(samlUrlEncode("abc123-_.~") == "abc123-_.~");
}
