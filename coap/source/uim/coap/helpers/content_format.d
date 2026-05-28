/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.helpers.content_format;

import vibe.data.json : Json, parseJsonString;

import uim.coap.message : UIMCoAPMessage;
import uim.coap.helpers.options;
import uim.coap.interfaces.message;

@safe:

enum CoAPContentFormat : ushort {
  textPlainUtf8 = 0,
  applicationLinkFormat = 40,
  applicationXml = 41,
  applicationOctetStream = 42,
  applicationExi = 47,
  applicationJson = 50,
  applicationCbor = 60
}

ICoAPMessage coapSetContentFormat(ICoAPMessage message, CoAPContentFormat format) {
  return coapSetUintOption(message, CoAPOptionNumber.contentFormat, cast(uint) format);
}

bool coapTryGetContentFormat(ICoAPMessage message, out CoAPContentFormat format) {
  format = CoAPContentFormat.applicationOctetStream;

  uint raw;
  if (!coapTryGetUintOption(message, CoAPOptionNumber.contentFormat, raw)) {
    return false;
  }

  format = cast(CoAPContentFormat) cast(ushort) raw;
  return true;
}

ICoAPMessage coapSetJsonPayload(ICoAPMessage message, Json payload) {
  auto jsonString = payload.toString();
  auto bytes = coapStringToBytes(jsonString);
  message.payload(bytes);
  return coapSetContentFormat(message, CoAPContentFormat.applicationJson);
}

bool coapTryGetJsonPayload(ICoAPMessage message, out Json payload) {
  payload = Json(null);

  CoAPContentFormat format;
  if (!coapTryGetContentFormat(message, format)) {
    return false;
  }

  if (format != CoAPContentFormat.applicationJson) {
    return false;
  }

  try {
    payload = parseJsonString(coapBytesToString(message.payload()));
    return true;
  } catch (Exception) {
    return false;
  }
}

ubyte[] coapStringToBytes(string value) {
  auto bytes = new ubyte[](value.length);
  foreach (i, ch; value) {
    bytes[i] = cast(ubyte) ch;
  }
  return bytes;
}

string coapBytesToString(const(ubyte)[] value) {
  auto chars = new char[](value.length);
  foreach (i, b; value) {
    chars[i] = cast(char) b;
  }
  return chars.idup;
}

unittest {
  auto msg = new UIMCoAPMessage();

  auto json = parseJsonString(`{"ok":true}`);
  coapSetJsonPayload(msg, json);

  Json outJson;
  assert(coapTryGetJsonPayload(msg, outJson));
  assert(outJson["ok"].get!bool);
}
