/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schemas.builder;

import uim.jsons;

@safe:

/**
 * Fluent schema builder.
 */
class DJSONSchemaBuilder {
  protected DJSONSchema _schema;

  this() {
    _schema = new DJSONSchema();
  }

  this(string type) {
    this();
    _schema.type = type;
  }

  DJSONSchemaBuilder type(string t) {
    _schema.type = t;
    return this;
  }

  DJSONSchemaBuilder title(string t) {
    _schema.title = t;
    return this;
  }

  DJSONSchemaBuilder description(string desc) {
    _schema.description = desc;
    return this;
  }

  DJSONSchemaBuilder defaultValue(Json value) {
    _schema.defaultValue = value;
    return this;
  }

  DJSONSchemaBuilder required(string[] fields) {
    _schema.required = fields;
    return this;
  }

  DJSONSchemaBuilder property(string name, DJSONSchema propSchema) {
    _schema.addProperty(name, propSchema);
    return this;
  }

  DJSONSchemaBuilder property(string name, DJSONSchemaBuilder propBuilder) {
    _schema.addProperty(name, propBuilder.build());
    return this;
  }

  DJSONSchemaBuilder minimum(double value) {
    _schema.minimum = value;
    return this;
  }

  DJSONSchemaBuilder maximum(double value) {
    _schema.maximum = value;
    return this;
  }

  DJSONSchemaBuilder minLength(size_t length) {
    _schema.minLength = length;
    return this;
  }

  DJSONSchemaBuilder maxLength(size_t length) {
    _schema.maxLength = length;
    return this;
  }

  DJSONSchemaBuilder pattern(string regex) {
    _schema.pattern = regex;
    return this;
  }

  DJSONSchemaBuilder format(string fmt) {
    _schema.format = fmt;
    return this;
  }

  DJSONSchemaBuilder enumValues(Json[] values) {
    _schema.enumValues = values;
    return this;
  }

  DJSONSchemaBuilder items(DJSONSchema itemSchema) {
    _schema.items = itemSchema;
    return this;
  }

  DJSONSchemaBuilder items(DJSONSchemaBuilder itemBuilder) {
    _schema.items = itemBuilder.build();
    return this;
  }

  DJSONSchemaBuilder minItems(size_t count) {
    _schema.minItems = count;
    return this;
  }

  DJSONSchemaBuilder maxItems(size_t count) {
    _schema.maxItems = count;
    return this;
  }

  DJSONSchemaBuilder uniqueItems(bool unique = true) {
    _schema.uniqueItems = unique;
    return this;
  }

  DJSONSchemaBuilder additionalProperties(bool allowed) {
    _schema.additionalProperties = allowed;
    return this;
  }

  DJSONSchemaBuilder ref_(string reference) {
    _schema.ref_ = reference;
    return this;
  }

  DJSONSchema build() {
    return _schema;
  }
}

/**
 * Helper function to create a builder.
 */
DJSONSchemaBuilder schemaBuilder() {
  return new DJSONSchemaBuilder();
}

DJSONSchemaBuilder schemaBuilder(string type) {
  return new DJSONSchemaBuilder(type);
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
