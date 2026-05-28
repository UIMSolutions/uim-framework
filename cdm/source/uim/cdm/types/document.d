/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.cdm.types.document;

@safe:

enum CdmObjectKind : ubyte {
  entity,
  attribute,
  relationship,
  document,
  profile
}

enum CdmDataType : ubyte {
  string,
  boolean,
  integer,
  decimal,
  dateTime,
  identifier,
  json
}

string cdmObjectKindToString(CdmObjectKind value) pure nothrow {
  final switch (value) {
    case CdmObjectKind.entity: return "ENTITY";
    case CdmObjectKind.attribute: return "ATTRIBUTE";
    case CdmObjectKind.relationship: return "RELATIONSHIP";
    case CdmObjectKind.document: return "DOCUMENT";
    case CdmObjectKind.profile: return "PROFILE";
  }
}

CdmObjectKind cdmObjectKindFromString(string value) pure {
  import std.string : toUpper;

  auto normalized = value.toUpper();
  switch (normalized) {
    case "ENTITY": return CdmObjectKind.entity;
    case "ATTRIBUTE": return CdmObjectKind.attribute;
    case "RELATIONSHIP": return CdmObjectKind.relationship;
    case "DOCUMENT": return CdmObjectKind.document;
    case "PROFILE": return CdmObjectKind.profile;
    default: return CdmObjectKind.document;
  }
}

string cdmDataTypeToString(CdmDataType value) pure nothrow {
  final switch (value) {
    case CdmDataType.string: return "STRING";
    case CdmDataType.boolean: return "BOOLEAN";
    case CdmDataType.integer: return "INTEGER";
    case CdmDataType.decimal: return "DECIMAL";
    case CdmDataType.dateTime: return "DATETIME";
    case CdmDataType.identifier: return "IDENTIFIER";
    case CdmDataType.json: return "JSON";
  }
}

CdmDataType cdmDataTypeFromString(string value) pure {
  import std.string : toUpper;

  auto normalized = value.toUpper();
  switch (normalized) {
    case "STRING": return CdmDataType.string;
    case "BOOLEAN": return CdmDataType.boolean;
    case "INTEGER": return CdmDataType.integer;
    case "DECIMAL": return CdmDataType.decimal;
    case "DATETIME":
    case "DATE_TIME": return CdmDataType.dateTime;
    case "IDENTIFIER": return CdmDataType.identifier;
    case "JSON": return CdmDataType.json;
    default: return CdmDataType.json;
  }
}

unittest {
  assert(cdmObjectKindFromString("entity") == CdmObjectKind.entity);
  assert(cdmObjectKindToString(CdmObjectKind.profile) == "PROFILE");
  assert(cdmDataTypeFromString("datetime") == CdmDataType.dateTime);
}
