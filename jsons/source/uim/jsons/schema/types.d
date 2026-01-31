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
  static JsonSchema string_() {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.String;
    return schema;
  }

  static JsonSchema string_(size_t minLen, size_t maxLen) {
    auto schema = string_();
    schema.minLength = minLen;
    schema.maxLength = maxLen;
    return schema;
  }

  static JsonSchema number() {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.Number;
    return schema;
  }

  static JsonSchema number(double min, double max) {
    auto schema = number();
    schema.minimum = min;
    schema.maximum = max;
    return schema;
  }

  static JsonSchema integer() {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.Integer;
    return schema;
  }

  static JsonSchema integer(long min, long max) {
    auto schema = integer();
    schema.minimum = min;
    schema.maximum = max;
    return schema;
  }

  static JsonSchema boolean() {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.Boolean;
    return schema;
  }

  static JsonSchema object() {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.Object;
    return schema;
  }

  static JsonSchema array(JsonSchema itemSchema) {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.Array;
    schema.items = itemSchema;
    return schema;
  }

  static JsonSchema null_() {
    auto schema = new JsonSchema();
    schema.type = JsonSchemaType.Null;
    return schema;
  }

  static JsonSchema email() {
    auto schema = string_();
    schema.format = "email";
    return schema;
  }

  static JsonSchema uri() {
    auto schema = string_();
    schema.format = "uri";
    return schema;
  }

  static JsonSchema date() {
    auto schema = string_();
    schema.format = "date";
    return schema;
  }

  static JsonSchema dateTime() {
    auto schema = string_();
    schema.format = "date-time";
    return schema;
  }

  static JsonSchema ipv4() {
    auto schema = string_();
    schema.format = "ipv4";
    return schema;
  }

  static JsonSchema ipv6() {
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
