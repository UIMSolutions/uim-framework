/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.codec;

import std.conv : to;
import std.datetime : SysTime;
import std.json;

import uim.adatp3;

mixin(ShowModule!());

@safe:

string adatp3EncodeJson(IADatP3Message message) {
  JSONValue root;
  root["standard"] = "ADatP-3";
  root["messageType"] = adatp3MessageTypeToString(message.messageType());
  root["messageId"] = message.messageId();
  root["originator"] = message.originator();
  root["recipient"] = message.recipient();
  root["timestampStdTime"] = cast(long) message.timestamp().stdTime;
  root["priority"] = adatp3PriorityToString(message.priority());

  JSONValue fieldsNode;
  foreach (key, value; message.fields()) {
    fieldsNode[key] = value;
  }

  root["fields"] = fieldsNode;
  return root.toString();
}

IADatP3Message adatp3DecodeJson(string payload) {
  auto root = parseJSON(payload);
  auto rootObject = (() @trusted => root.object)();

  auto type = ADatP3MessageType.freeText;
  if ("messageType" in rootObject) {
    type = adatp3MessageTypeFromString(root["messageType"].str);
  }

  auto priority = ADatP3Priority.routine;
  if ("priority" in rootObject) {
    priority = adatp3PriorityFromString(root["priority"].str);
  }

  auto message = ADatP3Message(
    type,
    root["messageId"].str,
    root["originator"].str,
    root["recipient"].str,
    priority
  );

  if ("timestampStdTime" in rootObject) {
    auto stdTimeValue = root["timestampStdTime"].integer.to!long;
    message.timestamp(SysTime(stdTimeValue));
  }

  if ("fields" in rootObject && root["fields"].type == JSONType.object) {
    auto fieldsObject = (() @trusted => root["fields"].object)();
    foreach (key, value; fieldsObject) {
      message.setField(key, value.str);
    }
  }

  return message;
}

unittest {
  auto message = ADatP3Message(
    ADatP3MessageType.spotrep,
    "MSG-2002",
    "BN-2",
    "HQ-NORTH",
    ADatP3Priority.immediate
  );
  message.setField("enemyStrength", "Platoon");
  message.setField("remarks", "Contact at waypoint ALPHA");

  auto json = adatp3EncodeJson(message);
  auto parsed = adatp3DecodeJson(json);

  assert(parsed.messageType() == ADatP3MessageType.spotrep);
  assert(parsed.priority() == ADatP3Priority.immediate);
  assert(parsed.messageId() == "MSG-2002");
  assert(parsed.field("enemyStrength") == "Platoon");
}
