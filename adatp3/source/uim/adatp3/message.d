/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.message;

import std.datetime : Clock, SysTime;

import uim.adatp3;

mixin(ShowModule!());

@safe:

class UIMADatP3Message : UIMObject, IADatP3Message {
  this() {
    super();
    _messageType = ADatP3MessageType.freeText;
    _priority = ADatP3Priority.routine;
    _timestamp = Clock.currTime();
  }

  this(
    ADatP3MessageType type,
    string id,
    string from,
    string to,
    ADatP3Priority precedence = ADatP3Priority.routine
  ) {
    this();
    _messageType = type;
    _messageId = id;
    _originator = from;
    _recipient = to;
    _priority = precedence;
  }

  private ADatP3MessageType _messageType;
  ADatP3MessageType messageType() {
    return _messageType;
  }

  IADatP3Message messageType(ADatP3MessageType value) {
    _messageType = value;
    return this;
  }

  private string _messageId;
  string messageId() {
    return _messageId;
  }

  IADatP3Message messageId(string value) {
    _messageId = value;
    return this;
  }

  private string _originator;
  string originator() {
    return _originator;
  }

  IADatP3Message originator(string value) {
    _originator = value;
    return this;
  }

  private string _recipient;
  string recipient() {
    return _recipient;
  }

  IADatP3Message recipient(string value) {
    _recipient = value;
    return this;
  }

  private SysTime _timestamp;
  SysTime timestamp() {
    return _timestamp;
  }

  IADatP3Message timestamp(SysTime value) {
    _timestamp = value;
    return this;
  }

  private ADatP3Priority _priority;
  ADatP3Priority priority() {
    return _priority;
  }

  IADatP3Message priority(ADatP3Priority value) {
    _priority = value;
    return this;
  }

  private string[string] _fields;
  string[string] fields() {
    return _fields.dup;
  }

  IADatP3Message fields(string[string] value) {
    _fields = value.dup;
    return this;
  }

  IADatP3Message setField(string key, string value) {
    if (key.length == 0) {
      return this;
    }

    _fields[key] = value;
    return this;
  }

  string field(string key, string defaultValue = "") const {
    auto result = key in _fields;
    return result is null ? defaultValue : *result;
  }
}

IADatP3Message ADatP3Message(
  ADatP3MessageType type,
  string id,
  string from,
  string to,
  ADatP3Priority precedence = ADatP3Priority.routine
) {
  return new UIMADatP3Message(type, id, from, to, precedence);
}

unittest {
  auto message = ADatP3Message(
    ADatP3MessageType.sitrep,
    "MSG-1001",
    "HQ-NORTH",
    "BDE-7",
    ADatP3Priority.priority
  );

  assert(message.messageType() == ADatP3MessageType.sitrep);
  assert(message.messageId() == "MSG-1001");
  assert(message.originator() == "HQ-NORTH");
  assert(message.recipient() == "BDE-7");
  assert(message.priority() == ADatP3Priority.priority);

  message.setField("grid", "32TLP12345678");
  assert(message.field("grid") == "32TLP12345678");
}
