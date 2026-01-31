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
class JsonSchemaBuilder {
  protected JsonSchema _schema;

  this() {
    _schema = new JsonSchema();
  }

  this(string type) {
    this();
    _schema.type = type;
  }

  JsonSchemaBuilder type(string t) {
    _schema.type = t;
    return this;
  }

  JsonSchemaBuilder title(string t) {
    _schema.title = t;
    return this;
  }

  JsonSchemaBuilder description(string desc) {
    _schema.description = desc;
    return this;
  }

  JsonSchemaBuilder defaultValue(Json value) {
    _schema.defaultValue = value;
    return this;
  }

  JsonSchemaBuilder required(string[] fields) {
    _schema.required = fields;
    return this;
  }

  JsonSchemaBuilder property(string name, JsonSchema propSchema) {
    _schema.addProperty(name, propSchema);
    return this;
  }

  JsonSchemaBuilder property(string name, JsonSchemaBuilder propBuilder) {
    _schema.addProperty(name, propBuilder.build());
    return this;
  }

  JsonSchemaBuilder minimum(double value) {
    _schema.minimum = value;
    return this;
  }

  JsonSchemaBuilder maximum(double value) {
    _schema.maximum = value;
    return this;
  }

  JsonSchemaBuilder minLength(size_t length) {
    _schema.minLength = length;
    return this;
  }

  JsonSchemaBuilder maxLength(size_t length) {
    _schema.maxLength = length;
    return this;
  }

  JsonSchemaBuilder pattern(string regex) {
    _schema.pattern = regex;
    return this;
  }

  JsonSchemaBuilder format(string fmt) {
    _schema.format = fmt;
    return this;
  }

  JsonSchemaBuilder enumValues(Json[] values) {
    _schema.enumValues = values;
    return this;
  }

  JsonSchemaBuilder items(JsonSchema itemSchema) {
    _schema.items = itemSchema;
    return this;
  }

  JsonSchemaBuilder items(JsonSchemaBuilder itemBuilder) {
    _schema.items = itemBuilder.build();
    return this;
  }

  JsonSchemaBuilder minItems(size_t count) {
    _schema.minItems = count;
    return this;
  }

  JsonSchemaBuilder maxItems(size_t count) {
    _schema.maxItems = count;
    return this;
  }

  JsonSchemaBuilder uniqueItems(bool unique = true) {
    _schema.uniqueItems = unique;
    return this;
  }

  JsonSchemaBuilder additionalProperties(bool allowed) {
    _schema.additionalProperties = allowed;
    return this;
  }

  JsonSchemaBuilder ref_(string reference) {
    _schema.ref_ = reference;
    return this;
  }

  JsonSchema build() {
    return _schema;
  }
}

/**
 * Helper function to create a builder.
 */
JsonSchemaBuilder schemaBuilder() {
  return new JsonSchemaBuilder();
}

JsonSchemaBuilder schemaBuilder(string type) {
  return new JsonSchemaBuilder(type);
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
