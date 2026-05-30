/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.llrp.helpers.codec;

import std.conv : to;
import std.string : indexOf, split, strip;

import uim.llrp.interfaces;

@safe:

LLRPMessage llrpEncodeMessage(string messageType, uint messageId, string payload) {
  LLRPMessage message;

  message.messageType = messageType;
  message.messageId = messageId;
  message.payload = payload;
  message.encodedFrame = "TYPE=" ~ messageType ~ "|ID=" ~ to!string(messageId) ~ "|PAYLOAD=" ~ payload;

  return message;
}

LLRPMessage llrpDecodeFrame(string frame) {
  LLRPMessage message;

  auto trimmed = frame.strip();
  if (trimmed.length == 0) {
    return message;
  }

  message.encodedFrame = trimmed;

  foreach (token; trimmed.split("|")) {
    auto eqPos = token.indexOf("=");
    if (eqPos <= 0) {
      continue;
    }

    auto key = token[0 .. cast(size_t)eqPos].strip();
    auto value = token[cast(size_t)eqPos + 1 .. $].strip();

    if (key == "TYPE") {
      message.messageType = value;
      continue;
    }

    if (key == "ID") {
      try {
        message.messageId = value.to!uint;
      } catch (Exception) {
      }
      continue;
    }

    if (key == "PAYLOAD") {
      message.payload = value;
    }
  }

  return message;
}

unittest {
  auto encoded = llrpEncodeMessage("GET_READER_CAPABILITIES", 101, "RequestedData=All");
  assert(encoded.encodedFrame.length > 0);

  auto decoded = llrpDecodeFrame(encoded.encodedFrame);
  assert(decoded.messageType == "GET_READER_CAPABILITIES");
  assert(decoded.messageId == 101);
}
