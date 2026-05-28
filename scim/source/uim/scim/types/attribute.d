/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.scim.types.attribute;

@safe:

// SCIM attribute value type (RFC 7643 §2.3)
enum ScimAttributeType {
  string_,
  integer_,
  decimal_,
  boolean_,
  dateTime,
  binary,
  reference,
  complex,
}

// Controls when the attribute may be modified
enum ScimAttributeMutability {
  readOnly,
  readWrite,
  immutable_,
  writeOnly,
}

// Controls when the attribute is returned in a response
enum ScimAttributeReturned {
  always,
  never,
  default_,
  request,
}

// Server-enforced uniqueness constraint
enum ScimAttributeUniqueness {
  none_,
  server,
  global,
}

// Attribute schema definition (used for ServiceProviderConfig / Schema endpoint)
struct ScimAttributeDef {
  string                  name;
  ScimAttributeType       type         = ScimAttributeType.string_;
  bool                    multiValued  = false;
  bool                    required     = false;
  bool                    caseExact    = false;
  ScimAttributeMutability mutability   = ScimAttributeMutability.readWrite;
  ScimAttributeReturned   returned     = ScimAttributeReturned.default_;
  ScimAttributeUniqueness uniqueness   = ScimAttributeUniqueness.none_;
  string                  description;
  ScimAttributeDef[]      subAttributes;

  unittest {
    auto def = ScimAttributeDef(
      "userName",
      ScimAttributeType.string_,
      false, true, false,
      ScimAttributeMutability.readWrite,
      ScimAttributeReturned.default_,
      ScimAttributeUniqueness.server,
      "Unique identifier for the user"
    );
    assert(def.name == "userName");
    assert(def.required);
    assert(def.uniqueness == ScimAttributeUniqueness.server);
  }
}
