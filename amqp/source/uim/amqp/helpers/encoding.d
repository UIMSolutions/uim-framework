/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.amqp.helpers.encoding;

import std.bitmanip : nativeToBigEndian, bigEndianToNative;
import std.conv     : to;

@safe:

// ---------------------------------------------------------------------------
// Low-level AMQP wire encoding helpers (big-endian primitives + shortstr/longstr)
// ---------------------------------------------------------------------------

void amqpWriteU8(ref ubyte[] out_, ubyte v) {
  out_ ~= v;
}

void amqpWriteU16(ref ubyte[] out_, ushort v) {
  auto be = nativeToBigEndian(v);
  out_ ~= (cast(ubyte*)&be)[0 .. ushort.sizeof];
}

void amqpWriteU32(ref ubyte[] out_, uint v) {
  auto be = nativeToBigEndian(v);
  out_ ~= (cast(ubyte*)&be)[0 .. uint.sizeof];
}

void amqpWriteU64(ref ubyte[] out_, ulong v) {
  auto be = nativeToBigEndian(v);
  out_ ~= (cast(ubyte*)&be)[0 .. ulong.sizeof];
}

void amqpWriteBytes(ref ubyte[] out_, const(ubyte)[] bytes) {
  out_ ~= bytes;
}

void amqpWriteShortStr(ref ubyte[] out_, string s) {
  auto len = s.length > 255 ? 255 : s.length;
  out_ ~= cast(ubyte) len;
  if (len) out_ ~= cast(const(ubyte)[]) s[0 .. len];
}

void amqpWriteLongStr(ref ubyte[] out_, const(ubyte)[] bytes) {
  amqpWriteU32(out_, cast(uint) bytes.length);
  out_ ~= bytes;
}

void amqpWriteLongStr(ref ubyte[] out_, string s) {
  auto bytes = cast(const(ubyte)[]) s;
  amqpWriteLongStr(out_, bytes);
}

// AMQP field table encoding is intentionally minimal in this module:
// we encode only string values ('S' longstr) for headers used in this library.
void amqpWriteFieldTableStringMap(ref ubyte[] out_, string[string] table) {
  ubyte[] payload;
  foreach (k, v; table) {
    amqpWriteShortStr(payload, k);
    amqpWriteU8(payload, cast(ubyte) 'S'); // field-value type tag = long string
    amqpWriteLongStr(payload, v);
  }
  amqpWriteU32(out_, cast(uint) payload.length);
  out_ ~= payload;
}

bool amqpReadU8(const(ubyte)[] data, ref size_t pos, out ubyte v) {
  if (pos + 1 > data.length) { v = 0; return false; }
  v = data[pos];
  pos += 1;
  return true;
}

bool amqpReadU16(const(ubyte)[] data, ref size_t pos, out ushort v) {
  if (pos + 2 > data.length) { v = 0; return false; }
  ushort be;
  (cast(ubyte*)&be)[0 .. ushort.sizeof] = data[pos .. pos + 2];
  v = bigEndianToNative(be);
  pos += 2;
  return true;
}

bool amqpReadU32(const(ubyte)[] data, ref size_t pos, out uint v) {
  if (pos + 4 > data.length) { v = 0; return false; }
  uint be;
  (cast(ubyte*)&be)[0 .. uint.sizeof] = data[pos .. pos + 4];
  v = bigEndianToNative(be);
  pos += 4;
  return true;
}

bool amqpReadU64(const(ubyte)[] data, ref size_t pos, out ulong v) {
  if (pos + 8 > data.length) { v = 0; return false; }
  ulong be;
  (cast(ubyte*)&be)[0 .. ulong.sizeof] = data[pos .. pos + 8];
  v = bigEndianToNative(be);
  pos += 8;
  return true;
}

bool amqpReadShortStr(const(ubyte)[] data, ref size_t pos, out string s) {
  ubyte len;
  if (!amqpReadU8(data, pos, len)) { s = ""; return false; }
  if (pos + len > data.length) { s = ""; return false; }
  s = cast(string) data[pos .. pos + len].idup;
  pos += len;
  return true;
}

bool amqpReadLongStr(const(ubyte)[] data, ref size_t pos, out ubyte[] bytes) {
  uint len;
  if (!amqpReadU32(data, pos, len)) { bytes = null; return false; }
  if (pos + len > data.length) { bytes = null; return false; }
  bytes = data[pos .. pos + len].dup;
  pos += len;
  return true;
}

bool amqpReadLongStr(const(ubyte)[] data, ref size_t pos, out string s) {
  ubyte[] bytes;
  if (!amqpReadLongStr(data, pos, bytes)) { s = ""; return false; }
  s = cast(string) bytes.idup;
  return true;
}

// Read a field table with only string ('S') values; unsupported value tags are skipped.
bool amqpReadFieldTableStringMap(const(ubyte)[] data, ref size_t pos, out string[string] table) {
  table = null;
  uint tblLen;
  if (!amqpReadU32(data, pos, tblLen)) return false;
  if (pos + tblLen > data.length) return false;

  size_t end = pos + tblLen;
  while (pos < end) {
    string key;
    if (!amqpReadShortStr(data, pos, key)) return false;

    ubyte tag;
    if (!amqpReadU8(data, pos, tag)) return false;

    final switch (cast(char) tag) {
      case 'S':
        string val;
        if (!amqpReadLongStr(data, pos, val)) return false;
        table[key] = val;
        break;
      default:
        // For unsupported tags, fail fast (keeps parser strict/safe)
        return false;
    }
  }
  return true;
}

// ---------------------------------------------------------------------------
// Frame-level helpers
// ---------------------------------------------------------------------------

/// Build a complete AMQP frame from type, channel, payload
ubyte[] amqpBuildFrame(ubyte frameType, ushort channel, const(ubyte)[] payload, ubyte frameEnd = 0xCE) {
  ubyte[] out_;
  amqpWriteU8(out_, frameType);
  amqpWriteU16(out_, channel);
  amqpWriteU32(out_, cast(uint) payload.length);
  out_ ~= payload;
  amqpWriteU8(out_, frameEnd);
  return out_;
}

// ---------------------------------------------------------------------------
// Unit tests
// ---------------------------------------------------------------------------

unittest {
  ubyte[] b;
  amqpWriteU8(b, 0x12);
  amqpWriteU16(b, 0x3456);
  amqpWriteU32(b, 0x789ABCDE);
  amqpWriteU64(b, 0x0123456789ABCDEFUL);

  size_t p = 0;
  ubyte u8;
  ushort u16;
  uint u32;
  ulong u64;
  assert(amqpReadU8(b, p, u8) && u8 == 0x12);
  assert(amqpReadU16(b, p, u16) && u16 == 0x3456);
  assert(amqpReadU32(b, p, u32) && u32 == 0x789ABCDE);
  assert(amqpReadU64(b, p, u64) && u64 == 0x0123456789ABCDEFUL);

  ubyte[] ss;
  amqpWriteShortStr(ss, "hello");
  p = 0;
  string s;
  assert(amqpReadShortStr(ss, p, s));
  assert(s == "hello");

  ubyte[] ls;
  amqpWriteLongStr(ls, "world");
  p = 0;
  assert(amqpReadLongStr(ls, p, s));
  assert(s == "world");

  string[string] headers;
  headers["x-request-id"] = "abc-123";
  headers["x-type"] = "demo";

  ubyte[] tbl;
  amqpWriteFieldTableStringMap(tbl, headers);
  p = 0;
  string[string] headers2;
  assert(amqpReadFieldTableStringMap(tbl, p, headers2));
  assert(headers2["x-request-id"] == "abc-123");
  assert(headers2["x-type"] == "demo");

  auto frame = amqpBuildFrame(1, 5, [cast(ubyte) 0xAA, cast(ubyte) 0xBB]);
  assert(frame.length == 1 + 2 + 4 + 2 + 1);
  assert(frame[0] == 1);
  assert(frame[$ - 1] == 0xCE);
}
