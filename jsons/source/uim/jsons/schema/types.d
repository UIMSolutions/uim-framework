/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schemas.types;

import uim.jsons;

@safe:

/**
 * JSON Schema type definitions.
 */
enum JSONSchemaType : string {
  String = "string",
  Number = "number",
  Integer = "integer",
  Boolean = "boolean",
  Object = "object",
  Array = "array",
  Null = "null"
}

/**
 * Helper functions for creating type schemas.
 */
class SchemaTypes {
  static DJSONSchema string_() {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.String;
    return schema;
  }

  static DJSONSchema string_(size_t minLen, size_t maxLen) {
    auto schema = string_();
    schema.minLength = minLen;
    schema.maxLength = maxLen;
    return schema;
  }

  static DJSONSchema number() {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.Number;
    return schema;
  }

  static DJSONSchema number(double min, double max) {
    auto schema = number();
    schema.minimum = min;
    schema.maximum = max;
    return schema;
  }

  static DJSONSchema integer() {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.Integer;
    return schema;
  }

  static DJSONSchema integer(long min, long max) {
    auto schema = integer();
    schema.minimum = min;
    schema.maximum = max;
    return schema;
  }

  static DJSONSchema boolean() {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.Boolean;
    return schema;
  }

  static DJSONSchema object() {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.Object;
    return schema;
  }

  static DJSONSchema array(DJSONSchema itemSchema) {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.Array;
    schema.items = itemSchema;
    return schema;
  }

  static DJSONSchema null_() {
    auto schema = new DJSONSchema();
    schema.type = JSONSchemaType.Null;
    return schema;
  }

  static DJSONSchema email() {
    auto schema = string_();
    schema.format = "email";
    return schema;
  }

  static DJSONSchema uri() {
    auto schema = string_();
    schema.format = "uri";
    return schema;
  }

  static DJSONSchema date() {
    auto schema = string_();
    schema.format = "date";
    return schema;
  }

  static DJSONSchema dateTime() {
    auto schema = string_();
    schema.format = "date-time";
    return schema;
  }

  static DJSONSchema ipv4() {
    auto schema = string_();
    schema.format = "ipv4";
    return schema;
  }

  static DJSONSchema ipv6() {
    auto schema = string_();
    schema.format = "ipv6";
    return schema;
  }
}

unittest {
  auto stringSchema = SchemaTypes.string_(3, 50);
  assert(stringSchema.type == "string");
  
  auto numberSchema = SchemaTypes.number(0, 100);
  assert(numberSchema.type == "number");
}
