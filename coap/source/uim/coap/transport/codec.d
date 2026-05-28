/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.transport.codec;

import std.algorithm : sort;
import std.array : appender, array;
import std.conv : to;

import uim.coap;

mixin(ShowModule!());

@safe:

ICoAPMessage coapDecodeMessage(const(ubyte)[] packet) {
  if (packet.length < 4) {
    throw new Exception("CoAP packet too short");
  }

  const header = packet[0];
  const protocolVersion = (header >> 6) & 0x03;
  if (protocolVersion != 1) {
    throw new Exception("Unsupported CoAP version: " ~ protocolVersion.to!string);
  }

  const tokenLength = header & 0x0F;
  if (packet.length < 4 + tokenLength) {
    throw new Exception("Invalid CoAP token length");
  }

  auto message = new UIMCoAPMessage();
  message.type(cast(CoAPType)((header >> 4) & 0x03));
  message.code(cast(CoAPCode) packet[1]);
  message.messageId(cast(ushort)((packet[2] << 8) | packet[3]));

  size_t index = 4;
  if (tokenLength > 0) {
    message.token(packet[index .. index + tokenLength]);
    index += tokenLength;
  }

  ushort currentOptionNumber = 0;
  CoAPOption[] parsedOptions;

  while (index < packet.length && packet[index] != 0xFF) {
    auto optionHeader = packet[index++];

    ushort delta = decodeNibble(optionHeader >> 4, packet, index);
    ushort length = decodeNibble(optionHeader & 0x0F, packet, index);

    currentOptionNumber += delta;

    if (index + length > packet.length) {
      throw new Exception("Malformed CoAP option value");
    }

    parsedOptions ~= CoAPOption(currentOptionNumber, packet[index .. index + length].dup);
    index += length;
  }

  message.options(parsedOptions);

  string reconstructedPath;
  foreach (opt; parsedOptions) {
    if (opt.number == 11) {
      if (reconstructedPath.length == 0) {
        reconstructedPath = "/";
      } else {
        reconstructedPath ~= "/";
      }
      reconstructedPath ~= coapBytesToString(opt.value);
    }
  }
  message.path(reconstructedPath.length == 0 ? "/" : reconstructedPath);

  if (index < packet.length && packet[index] == 0xFF) {
    index++;
    if (index < packet.length) {
      message.payload(packet[index .. $]);
    }
  }

  return message;
}

ubyte[] coapEncodeMessage(ICoAPMessage message) {
  auto bytesOut = appender!(ubyte[])();

  auto token = message.token();
  if (token.length > 8) {
    throw new Exception("CoAP token length must be <= 8");
  }

  auto firstByte = cast(ubyte)((1 << 6) | (cast(ubyte) message.type() << 4) | (token.length & 0x0F));
  bytesOut.put(firstByte);
  bytesOut.put(cast(ubyte) message.code());

  const messageId = message.messageId();
  bytesOut.put(cast(ubyte)((messageId >> 8) & 0xFF));
  bytesOut.put(cast(ubyte)(messageId & 0xFF));

  bytesOut.put(token);

  CoAPOption[] options = message.options();
  foreach (segment; normalizeCoAPPath(message.path())) {
    options ~= CoAPOption(11, coapStringToBytes(segment));
  }

  options = options.sort!((a, b) => a.number < b.number).array;

  ushort previousNumber = 0;
  foreach (option; options) {
    const delta = cast(ushort)(option.number - previousNumber);
    const length = cast(ushort) option.value.length;

    auto optionHeader = cast(ubyte)((encodeNibble(delta) << 4) | encodeNibble(length));
    bytesOut.put(optionHeader);
    encodeExtendedValue(bytesOut, delta);
    encodeExtendedValue(bytesOut, length);
    bytesOut.put(option.value);

    previousNumber = option.number;
  }

  auto payload = message.payload();
  if (payload.length > 0) {
    bytesOut.put(cast(ubyte) 0xFF);
    bytesOut.put(payload);
  }

  return bytesOut.data;
}

private ushort decodeNibble(ubyte nibble, const(ubyte)[] packet, ref size_t index) {
  switch (nibble) {
  case 13:
    if (index >= packet.length) throw new Exception("Malformed extended option");
    return cast(ushort)(packet[index++] + 13);
  case 14:
    if (index + 1 >= packet.length) throw new Exception("Malformed extended option");
    auto v = cast(ushort)((packet[index] << 8) | packet[index + 1]);
    index += 2;
    return cast(ushort)(v + 269);
  case 15:
    throw new Exception("Invalid option nibble 15");
  default:
    return nibble;
  }
}

private ubyte encodeNibble(ushort value) {
  if (value < 13) return cast(ubyte) value;
  if (value < 269) return 13;
  return 14;
}

private void encodeExtendedValue(ref Appender!(ubyte[]) sink, ushort value) {
  if (value < 13) {
    return;
  }
  if (value < 269) {
    sink.put(cast(ubyte)(value - 13));
    return;
  }

  const v = cast(ushort)(value - 269);
  sink.put(cast(ubyte)((v >> 8) & 0xFF));
  sink.put(cast(ubyte)(v & 0xFF));
}

private ubyte[] coapStringToBytes(string value) {
  auto bytes = new ubyte[](value.length);
  foreach (i, ch; value) {
    bytes[i] = cast(ubyte) ch;
  }
  return bytes;
}

private string coapBytesToString(const(ubyte)[] value) {
  auto chars = new char[](value.length);
  foreach (i, b; value) {
    chars[i] = cast(char) b;
  }
  return chars.idup;
}

unittest {
  auto original = CoAPMessage(CoAPCode.post, "/a/b", coapStringToBytes("hello"));
  original.type(CoAPType.confirmable);
  original.messageId(101);
  original.token([0xAB, 0xCD]);

  auto encoded = coapEncodeMessage(original);
  auto decoded = coapDecodeMessage(encoded);

  assert(decoded.code() == CoAPCode.post);
  assert(decoded.path() == "/a/b");
  assert(coapBytesToString(decoded.payload()) == "hello");
  assert(decoded.messageId() == 101);
}
