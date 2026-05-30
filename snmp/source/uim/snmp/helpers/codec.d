/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.snmp.helpers.codec;

import std.conv : to;
import std.datetime : Clock, UTC;
import std.string : indexOf, splitLines, strip;

import uim.snmp.interfaces;
import uim.snmp.models;

@safe:

SNMPOidValue snmpParseOidLine(string line, string fallbackOid = "") {
  auto trimmed = line.strip();
  if (trimmed.length == 0) {
    return SNMPOidValueEmpty(fallbackOid);
  }

  SNMPOidValue result;
  result.timestamp = Clock.currTime(UTC()).toUnixTime();

  auto eqPos = trimmed.indexOf("=");
  if (eqPos < 0) {
    result.oid = fallbackOid;
    result.typeTag = "s";
    result.value = trimmed;
    return result;
  }

  result.oid = trimmed[0 .. cast(size_t) eqPos].strip();
  auto right = trimmed[cast(size_t) eqPos + 1 .. $].strip();

  auto colonPos = right.indexOf(":");
  if (colonPos < 0) {
    result.typeTag = "s";
    result.value = right;
    return result;
  }

  result.typeTag = right[0 .. cast(size_t) colonPos].strip();
  result.value = right[cast(size_t) colonPos + 1 .. $].strip();
  return result;
}

SNMPOidValue[] snmpParseWalkBlock(string block, string rootOid = "") {
  SNMPOidValue[] values;
  foreach (line; block.splitLines()) {
    auto parsed = snmpParseOidLine(line, rootOid);
    if (parsed.oid.length == 0 || parsed.value.length == 0) {
      continue;
    }

    values ~= parsed;
  }

  return values;
}

unittest {
  auto value = snmpParseOidLine("1.3.6.1.2.1.1.5.0 = STRING: switch-01");
  assert(value.oid == "1.3.6.1.2.1.1.5.0");
  assert(value.typeTag == "STRING");

  auto walk = snmpParseWalkBlock(
    "1.3.6.1.2.1.1.1.0 = STRING: Linux\n1.3.6.1.2.1.1.3.0 = Timeticks: 200"
  );
  assert(walk.length == 2);
}
