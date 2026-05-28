/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ldap.helpers.encoding;

import std.conv  : to;
import std.array : appender;

@safe:

// ---------------------------------------------------------------------------
// BER length encoding / decoding helpers (used for ASN.1/BER framing in
// LDAP protocol messages — RFC 4511 uses BER-encoded ASN.1)
// ---------------------------------------------------------------------------

/// Encode a length value into BER definite form
ubyte[] berEncodeLength(size_t length) {
  if (length < 0x80) {
    return [cast(ubyte) length];
  }

  ubyte[] result;
  // determine how many bytes are needed
  size_t tmp = length;
  ubyte count = 0;
  while (tmp > 0) {
    result = [cast(ubyte)(tmp & 0xFF)] ~ result;
    tmp >>= 8;
    count++;
  }
  return [cast(ubyte)(0x80 | count)] ~ result;
}

/// Decode a BER-encoded length from a buffer; returns bytes consumed via `consumed`
size_t berDecodeLength(const(ubyte)[] buf, out size_t consumed) {
  consumed = 0;
  if (buf.length == 0) {
    return 0;
  }

  if ((buf[0] & 0x80) == 0) {
    consumed = 1;
    return buf[0];
  }

  ubyte numBytes = buf[0] & 0x7F;
  if (numBytes == 0 || numBytes > 4 || buf.length < 1 + numBytes) {
    consumed = 0;
    return 0;
  }

  size_t length = 0;
  foreach (i; 0 .. numBytes) {
    length = (length << 8) | buf[1 + i];
  }
  consumed = 1 + numBytes;
  return length;
}

// ---------------------------------------------------------------------------
// Hexadecimal helpers (for debugging / logging LDAP binary data)
// ---------------------------------------------------------------------------

/// Encode a byte array as a lowercase hex string
string toHexString(const(ubyte)[] data) {
  auto buf = appender!string;
  buf.reserve(data.length * 2);
  foreach (b; data) {
    immutable ubyte hi = (b >> 4) & 0x0F;
    immutable ubyte lo = b & 0x0F;
    buf ~= cast(char)(hi < 10 ? '0' + hi : 'a' + hi - 10);
    buf ~= cast(char)(lo < 10 ? '0' + lo : 'a' + lo - 10);
  }
  return buf.data;
}

/// Decode a hex string to bytes (returns empty on invalid input)
ubyte[] fromHexString(string hex) {
  if (hex.length % 2 != 0) {
    return null;
  }

  auto result = appender!(ubyte[])();
  result.reserve(hex.length / 2);
  foreach (i; 0 .. hex.length / 2) {
    auto hi = hexNibble(hex[i * 2]);
    auto lo = hexNibble(hex[i * 2 + 1]);
    if (hi < 0 || lo < 0) {
      return null;
    }
    result ~= cast(ubyte)((hi << 4) | lo);
  }
  return result.data;
}

private int hexNibble(char c) pure nothrow @safe {
  if (c >= '0' && c <= '9') { return c - '0'; }
  if (c >= 'a' && c <= 'f') { return c - 'a' + 10; }
  if (c >= 'A' && c <= 'F') { return c - 'A' + 10; }
  return -1;
}

unittest {
  // BER length encoding
  assert(berEncodeLength(0)   == [0x00]);
  assert(berEncodeLength(127) == [0x7f]);
  assert(berEncodeLength(128) == [0x81, 0x80]);
  assert(berEncodeLength(256) == [0x82, 0x01, 0x00]);

  // BER length decoding
  size_t consumed;
  assert(berDecodeLength([0x7f], consumed) == 127 && consumed == 1);
  assert(berDecodeLength([0x81, 0x80], consumed) == 128 && consumed == 2);
  assert(berDecodeLength([0x82, 0x01, 0x00], consumed) == 256 && consumed == 3);

  // Hex helpers
  assert(toHexString([0xDE, 0xAD, 0xBE, 0xEF]) == "deadbeef");
  assert(fromHexString("deadbeef") == [0xDE, 0xAD, 0xBE, 0xEF]);
  assert(fromHexString("xyz") is null);
}
