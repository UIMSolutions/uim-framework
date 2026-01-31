/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schema.types;

import uim.jsons;

mixin(ShowModule!());

@safe:



/**
 * Helper functions for creating type schemas.
 */
class SchemaTypes {
  static JSONSchema string_() {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.String;
    return schema;
  }

  static JSONSchema string_(size_t minLen, size_t maxLen) {
    auto schema = string_();
    schema.minLength = minLen;
    schema.maxLength = maxLen;
    return schema;
  }

  static JSONSchema number() {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.Number;
    return schema;
  }

  static JSONSchema number(double min, double max) {
    auto schema = number();
    schema.minimum = min;
    schema.maximum = max;
    return schema;
  }

  static JSONSchema integer() {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.Integer;
    return schema;
  }

  static JSONSchema integer(long min, long max) {
    auto schema = integer();
    schema.minimum = min;
    schema.maximum = max;
    return schema;
  }

  static JSONSchema boolean() {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.Boolean;
    return schema;
  }

  static JSONSchema object() {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.Object;
    return schema;
  }

  static JSONSchema array(JSONSchema itemSchema) {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.Array;
    schema.items = itemSchema;
    return schema;
  }

  static JSONSchema null_() {
    auto schema = new JSONSchema();
    schema.type = JSONSchemaType.Null;
    return schema;
  }

  static JSONSchema email() {
    auto schema = string_();
    schema.format = "email";
    return schema;
  }

  static JSONSchema uri() {
    auto schema = string_();
    schema.format = "uri";
    return schema;
  }

  static JSONSchema date() {
    auto schema = string_();
    schema.format = "date";
    return schema;
  }

  static JSONSchema dateTime() {
    auto schema = string_();
    schema.format = "date-time";
    return schema;
  }

  static JSONSchema ipv4() {
    auto schema = string_();
    schema.format = "ipv4";
    return schema;
  }

  static JSONSchema ipv6() {
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
