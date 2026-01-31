/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schema.builder;

import uim.jsons;

mixin(ShowModule!());

@safe:

/**
 * Fluent schema builder.
 */
class JSONSchemaBuilder {
  protected JSONSchema _schema;

  this() {
    _schema = new JSONSchema();
  }

  this(string type) {
    this();
    _schema.type = type;
  }

  JSONSchemaBuilder type(string t) {
    _schema.type = t;
    return this;
  }

  JSONSchemaBuilder title(string t) {
    _schema.title = t;
    return this;
  }

  JSONSchemaBuilder description(string desc) {
    _schema.description = desc;
    return this;
  }

  JSONSchemaBuilder defaultValue(Json value) {
    _schema.defaultValue = value;
    return this;
  }

  JSONSchemaBuilder required(string[] fields) {
    _schema.required = fields;
    return this;
  }

  JSONSchemaBuilder property(string name, JSONSchema propSchema) {
    _schema.addProperty(name, propSchema);
    return this;
  }

  JSONSchemaBuilder property(string name, JSONSchemaBuilder propBuilder) {
    _schema.addProperty(name, propBuilder.build());
    return this;
  }

  JSONSchemaBuilder minimum(double value) {
    _schema.minimum = value;
    return this;
  }

  JSONSchemaBuilder maximum(double value) {
    _schema.maximum = value;
    return this;
  }

  JSONSchemaBuilder minLength(size_t length) {
    _schema.minLength = length;
    return this;
  }

  JSONSchemaBuilder maxLength(size_t length) {
    _schema.maxLength = length;
    return this;
  }

  JSONSchemaBuilder pattern(string regex) {
    _schema.pattern = regex;
    return this;
  }

  JSONSchemaBuilder format(string fmt) {
    _schema.format = fmt;
    return this;
  }

  JSONSchemaBuilder enumValues(Json[] values) {
    _schema.enumValues = values;
    return this;
  }

  JSONSchemaBuilder items(JSONSchema itemSchema) {
    _schema.items = itemSchema;
    return this;
  }

  JSONSchemaBuilder items(JSONSchemaBuilder itemBuilder) {
    _schema.items = itemBuilder.build();
    return this;
  }

  JSONSchemaBuilder minItems(size_t count) {
    _schema.minItems = count;
    return this;
  }

  JSONSchemaBuilder maxItems(size_t count) {
    _schema.maxItems = count;
    return this;
  }

  JSONSchemaBuilder uniqueItems(bool unique = true) {
    _schema.uniqueItems = unique;
    return this;
  }

  JSONSchemaBuilder additionalProperties(bool allowed) {
    _schema.additionalProperties = allowed;
    return this;
  }

  JSONSchemaBuilder ref_(string reference) {
    _schema.ref_ = reference;
    return this;
  }

  JSONSchema build() {
    return _schema;
  }
}

/**
 * Helper function to create a builder.
 */
JSONSchemaBuilder schemaBuilder() {
  return new JSONSchemaBuilder();
}

JSONSchemaBuilder schemaBuilder(string type) {
  return new JSONSchemaBuilder(type);
}

unittest {
  auto schema = schemaBuilder("object")
    .title("User")
    .description("User schema")
    .property("name", schemaBuilder("string").minLength(3).maxLength(50))
    .property("age", schemaBuilder("integer").minimum(0).maximum(150))
    .property("email", schemaBuilder("string").format("email"))
    .required(["name", "email"])
    .build();

  assert(schema.type == "object");
  auto json = schema.toJson;
  assert("properties" in json);
}
