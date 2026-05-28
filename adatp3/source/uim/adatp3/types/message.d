/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.adatp3.types.message;

@safe:

enum ADatP3MessageType : ubyte {
  sitrep,
  spotrep,
  oprep,
  frago,
  freeText
}

enum ADatP3Priority : ubyte {
  routine,
  priority,
  immediate,
  flash
}

string adatp3MessageTypeToString(ADatP3MessageType value) pure nothrow {
  final switch (value) {
    case ADatP3MessageType.sitrep: return "SITREP";
    case ADatP3MessageType.spotrep: return "SPOTREP";
    case ADatP3MessageType.oprep: return "OPREP";
    case ADatP3MessageType.frago: return "FRAGO";
    case ADatP3MessageType.freeText: return "FREE_TEXT";
  }
}

ADatP3MessageType adatp3MessageTypeFromString(string value) pure {
  import std.string : toUpper;

  auto normalized = value.toUpper();
  switch (normalized) {
    case "SITREP": return ADatP3MessageType.sitrep;
    case "SPOTREP": return ADatP3MessageType.spotrep;
    case "OPREP": return ADatP3MessageType.oprep;
    case "FRAGO": return ADatP3MessageType.frago;
    case "FREE_TEXT":
    case "FREETEXT": return ADatP3MessageType.freeText;
    default: return ADatP3MessageType.freeText;
  }
}

string adatp3PriorityToString(ADatP3Priority value) pure nothrow {
  final switch (value) {
    case ADatP3Priority.routine: return "ROUTINE";
    case ADatP3Priority.priority: return "PRIORITY";
    case ADatP3Priority.immediate: return "IMMEDIATE";
    case ADatP3Priority.flash: return "FLASH";
  }
}

ADatP3Priority adatp3PriorityFromString(string value) pure {
  import std.string : toUpper;

  auto normalized = value.toUpper();
  switch (normalized) {
    case "ROUTINE": return ADatP3Priority.routine;
    case "PRIORITY": return ADatP3Priority.priority;
    case "IMMEDIATE": return ADatP3Priority.immediate;
    case "FLASH": return ADatP3Priority.flash;
    default: return ADatP3Priority.routine;
  }
}

unittest {
  assert(adatp3MessageTypeFromString("sitrep") == ADatP3MessageType.sitrep);
  assert(adatp3MessageTypeToString(ADatP3MessageType.frago) == "FRAGO");

  assert(adatp3PriorityFromString("IMMEDIATE") == ADatP3Priority.immediate);
  assert(adatp3PriorityToString(ADatP3Priority.flash) == "FLASH");
}
