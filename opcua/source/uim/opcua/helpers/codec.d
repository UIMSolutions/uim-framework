/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.opcua.helpers.codec;

import std.conv : to;
import std.datetime : Clock, UTC;
import std.string : indexOf, split, strip;

import uim.opcua.interfaces;

@safe:

string opcuaBuildReadRequest(string nodeId, string attributeId = "Value") {
  return "READ|NodeId=" ~ nodeId ~ "|Attribute=" ~ attributeId;
}

string opcuaBuildWriteRequest(string nodeId, string value, string dataType = "String") {
  return "WRITE|NodeId=" ~ nodeId ~ "|DataType=" ~ dataType ~ "|Value=" ~ value;
}

OPCUANodeRead opcuaParseReadResponse(string response, string fallbackNodeId = "") {
  OPCUANodeRead result;
  auto trimmed = response.strip();
  if (trimmed.length == 0) {
    return result;
  }

  result.nodeId = fallbackNodeId;
  result.sourceTimestamp = Clock.currTime(UTC()).toUnixTime();

  foreach (token; trimmed.split("|")) {
    auto eqPos = token.indexOf("=");
    if (eqPos <= 0) {
      continue;
    }

    auto key = token[0 .. cast(size_t)eqPos].strip();
    auto value = token[cast(size_t)eqPos + 1 .. $].strip();

    if (key == "NodeId") {
      result.nodeId = value;
    } else if (key == "Attribute") {
      result.attributeId = value;
    } else if (key == "Value") {
      result.value = value;
    } else if (key == "DataType") {
      result.dataType = value;
    } else if (key == "SourceTimestamp") {
      try {
        result.sourceTimestamp = value.to!long;
      } catch (Exception) {
      }
    }
  }

  return result;
}

unittest {
  auto request = opcuaBuildReadRequest("ns=2;s=Machine/Speed");
  assert(request.length > 0);

  auto parsed = opcuaParseReadResponse(
    "NodeId=ns=2;s=Machine/Speed|Attribute=Value|Value=1750|DataType=Int32|SourceTimestamp=1710000000"
  );
  assert(parsed.nodeId.length > 0);
  assert(parsed.value == "1750");
}
