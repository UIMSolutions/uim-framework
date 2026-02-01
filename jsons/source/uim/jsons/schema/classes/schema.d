/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jsons.schema.classes.schema;

import uim.jsons;

mixin(ShowModule!());

@safe:

/**
 * Json Schema representation.
 * Supports Json Schema Draft 7.
 */
class JsonSchema : UIMObject {
  alias toJson = UIMObject.toJson;
  
  protected Json _schema;
  protected string _version = "http://json-schema.org/draft-07/schema#";

  this() {
    super();
    _schema = Json.emptyObject;
    _schema["$schema"] = _version;
  }

  this(Json schemaData) {
    this();
    _schema = schemaData;
    
    if (auto schemaVersion = "$schema" in schemaData) {
      _version = schemaVersion.get!string;
    }
  }

  /**
   * Get the schema as Json.
   */
  Json toJson() {
    return _schema;
  }

  /**
   * Set schema type.
   */
  void type(string t) {
    _schema["type"] = t;
  }

  /**
   * Get schema type.
   */
  string type() {
    if (auto t = "type" in _schema) {
      return t.get!string;
    }
    return "";
  }

  /**
   * Set schema title.
   */
  void title(string t) {
    _schema["title"] = t;
  }

  /**
   * Set schema description.
   */
  void description(string desc) {
    _schema["description"] = desc;
  }

  /**
   * Set default value.
   */
  void defaultValue(Json value) {
    _schema["default"] = value;
  }

  /**
   * Set as required.
   */
  void required(string[] fields) {
    _schema["required"] = fields.toJson;
  }

  /**
   * Add a property to object schema.
   */
  void addProperty(string name, JsonSchema propertySchema) {
    if ("properties" !in _schema) {
      _schema["properties"] = Json.emptyObject;
    }
    _schema["properties"][name] = propertySchema.toJson;
  }

  /**
   * Set minimum value for numbers.
   */
  void minimum(double value) {
    _schema["minimum"] = value;
  }

  /**
   * Set maximum value for numbers.
   */
  void maximum(double value) {
    _schema["maximum"] = value;
  }

  /**
   * Set exclusive minimum.
   */
  void exclusiveMinimum(double value) {
    _schema["exclusiveMinimum"] = value;
  }

  /**
   * Set exclusive maximum.
   */
  void exclusiveMaximum(double value) {
    _schema["exclusiveMaximum"] = value;
  }

  /**
   * Set multiple of constraint for numbers.
   */
  void multipleOf(double value) {
    _schema["multipleOf"] = value;
  }

  /**
   * Set minimum length for strings.
   */
  void minLength(size_t length) {
    _schema["minLength"] = length;
  }

  /**
   * Set maximum length for strings.
   */
  void maxLength(size_t length) {
    _schema["maxLength"] = length;
  }

  /**
   * Set pattern for string validation.
   */
  void pattern(string regex) {
    _schema["pattern"] = regex;
  }

  /**
   * Set format for string validation.
   */
  void format(string fmt) {
    _schema["format"] = fmt;
  }

  /**
   * Set enum values.
   */
  void enumValues(Json[] values) {
    _schema["enum"] = Json(values);
  }

  /**
   * Set const value.
   */
  void constValue(Json value) {
    _schema["const"] = value;
  }

  /**
   * Set array items schema.
   */
  void items(JsonSchema itemSchema) {
    _schema["items"] = itemSchema.toJson;
  }

  /**
   * Set minimum items for arrays.
   */
  void minItems(size_t count) {
    _schema["minItems"] = count;
  }

  /**
   * Set maximum items for arrays.
   */
  void maxItems(size_t count) {
    _schema["maxItems"] = count;
  }

  /**
   * Set unique items constraint for arrays.
   */
  void uniqueItems(bool unique) {
    _schema["uniqueItems"] = unique;
  }

  /**
   * Add allOf composition.
   */
  void allOf(JsonSchema[] schemas) {
    Json[] schemaArray;
    foreach (schema; schemas) {
      schemaArray ~= schema.toJson;
    }
    _schema["allOf"] = Json(schemaArray);
  }

  /**
   * Add anyOf composition.
   */
  void anyOf(JsonSchema[] schemas) {
    Json[] schemaArray;
    foreach (schema; schemas) {
      schemaArray ~= schema.toJson;
    }
    _schema["anyOf"] = Json(schemaArray);
  }

  /**
   * Add oneOf composition.
   */
  void oneOf(JsonSchema[] schemas) {
    Json[] schemaArray;
    foreach (schema; schemas) {
      schemaArray ~= schema.toJson;
    }
    _schema["oneOf"] = Json(schemaArray);
  }

  /**
   * Set not schema.
   */
  void not(JsonSchema schema) {
    _schema["not"] = schema.toJson;
  }

  /**
   * Set additional properties.
   */
  void additionalProperties(bool allowed) {
    _schema["additionalProperties"] = allowed;
  }

  /**
   * Set additional properties schema.
   */
  void additionalProperties(JsonSchema schema) {
    _schema["additionalProperties"] = schema.toJson;
  }

  /**
   * Set minimum properties for objects.
   */
  void minProperties(size_t count) {
    _schema["minProperties"] = count;
  }

  /**
   * Set maximum properties for objects.
   */
  void maxProperties(size_t count) {
    _schema["maxProperties"] = count;
  }

  /**
   * Add a definition (reusable schema).
   */
  void addDefinition(string name, JsonSchema schema) {
    if ("definitions" !in _schema) {
      _schema["definitions"] = Json.emptyObject;
    }
    _schema["definitions"][name] = schema.toJson;
  }

  /**
   * Set reference to another schema.
   */
  void ref_(string reference) {
    _schema["$ref"] = reference;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }
    return true;
  }
}
///
unittest {
  auto schema = new JsonSchema();
  schema.type = "string";
  schema.minLength = 5;
  schema.maxLength = 50;
  
  assert(schema.type == "string");
  auto json = schema.toJson;
  assert("type" in json);
  assert(json["type"].get!string == "string");
}
