/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.jsons.schemas.validator;

import uim.jsons;

@safe:

/**
 * Validation result.
 */
struct ValidationResult {
  bool valid;
  ValidationError[] errors;

  static ValidationResult success() {
    return ValidationResult(true, []);
  }

  static ValidationResult failure(ValidationError[] errs) {
    return ValidationResult(false, errs);
  }

  static ValidationResult failure(ValidationError err) {
    return ValidationResult(false, [err]);
  }
}

/**
 * JSON Schema validator.
 */
class DJSONSchemaValidator : UIMObject {
  protected DJSONSchema _schema;
  protected DFormatValidator[string] _formatValidators;

  this(DJSONSchema schema) {
    super();
    _schema = schema;
    registerDefaultFormatValidators();
  }

  /**
   * Register default format validators.
   */
  protected void registerDefaultFormatValidators() {
    _formatValidators["email"] = new DEmailFormatValidator();
    _formatValidators["uri"] = new DURIFormatValidator();
    _formatValidators["date"] = new DDateFormatValidator();
    _formatValidators["date-time"] = new DDateTimeFormatValidator();
    _formatValidators["ipv4"] = new DIPv4FormatValidator();
    _formatValidators["ipv6"] = new DIPv6FormatValidator();
  }

  /**
   * Validate JSON data against the schema.
   */
  ValidationResult validate(Json data) {
    ValidationError[] errors;
    
    if (!validateType(data, errors)) {
      return ValidationResult.failure(errors);
    }

    if (!validateConstraints(data, errors)) {
      return ValidationResult.failure(errors);
    }

    return ValidationResult.success();
  }

  /**
   * Validate data type.
   */
  protected bool validateType(Json data, ref ValidationError[] errors) {
    auto schemaJson = _schema.toJson;
    
    if (auto typeField = "type" in schemaJson) {
      string expectedType = typeField.get!string;
      string actualType = data.type.to!string.toLower;

      // Map JSON types
      if (data.isInteger || data.isDouble) {
        actualType = "number";
      } else if (data.isBoolean) {
        actualType = "boolean";
      } else if (data.isNull) {
        actualType = "null";
      }

      if (actualType != expectedType) {
        errors ~= ValidationError(
          "type",
          "Expected type '" ~ expectedType ~ "' but got '" ~ actualType ~ "'",
          ""
        );
        return false;
      }
    }

    return true;
  }

  /**
   * Validate constraints based on type.
   */
  protected bool validateConstraints(Json data, ref ValidationError[] errors) {
    auto schemaJson = _schema.toJson;
    bool valid = true;

    // String validations
    if (data.type == Json.Type.string) {
      valid = validateStringConstraints(data.get!string, schemaJson, errors) && valid;
    }

    // Number validations
    if (data.type == Json.Type.int_ || data.type == Json.Type.float_) {
      double value = data.type == Json.Type.int_ ? data.get!long : data.get!double;
      valid = validateNumberConstraints(value, schemaJson, errors) && valid;
    }

    // Array validations
    if (data.type == Json.Type.array) {
      valid = validateArrayConstraints(data, schemaJson, errors) && valid;
    }

    // Object validations
    if (data.type == Json.Type.object) {
      valid = validateObjectConstraints(data, schemaJson, errors) && valid;
    }

    // Enum validation
    if (auto enumField = "enum" in schemaJson) {
      valid = validateEnum(data, enumField.get!(Json[]), errors) && valid;
    }

    // Const validation
    if (auto constField = "const" in schemaJson) {
      if (data != *constField) {
        errors ~= ValidationError("const", "Value must equal const value", "");
        valid = false;
      }
    }

    return valid;
  }

  /**
   * Validate string constraints.
   */
  protected bool validateStringConstraints(string value, Json schema, ref ValidationError[] errors) {
    bool valid = true;

    if (auto minLen = "minLength" in schema) {
      if (value.length < minLen.get!size_t) {
        errors ~= ValidationError(
          "minLength",
          "String length must be at least " ~ minLen.get!size_t.to!string,
          ""
        );
        valid = false;
      }
    }

    if (auto maxLen = "maxLength" in schema) {
      if (value.length > maxLen.get!size_t) {
        errors ~= ValidationError(
          "maxLength",
          "String length must not exceed " ~ maxLen.get!size_t.to!string,
          ""
        );
        valid = false;
      }
    }

    if (auto patternField = "pattern" in schema) {
      import std.regex : regex, matchFirst;
      auto pattern = patternField.get!string;
      auto re = regex(pattern);
      if (matchFirst(value, re).empty) {
        errors ~= ValidationError("pattern", "String does not match pattern: " ~ pattern, "");
        valid = false;
      }
    }

    if (auto formatField = "format" in schema) {
      string format = formatField.get!string;
      if (auto validator = format in _formatValidators) {
        if (!validator.validate(value)) {
          errors ~= ValidationError("format", "String does not match format: " ~ format, "");
          valid = false;
        }
      }
    }

    return valid;
  }

  /**
   * Validate number constraints.
   */
  protected bool validateNumberConstraints(double value, Json schema, ref ValidationError[] errors) {
    bool valid = true;

    if (auto min = "minimum" in schema) {
      if (value < min.get!double) {
        errors ~= ValidationError("minimum", "Value must be >= " ~ min.get!double.to!string, "");
        valid = false;
      }
    }

    if (auto max = "maximum" in schema) {
      if (value > max.get!double) {
        errors ~= ValidationError("maximum", "Value must be <= " ~ max.get!double.to!string, "");
        valid = false;
      }
    }

    if (auto exMin = "exclusiveMinimum" in schema) {
      if (value <= exMin.get!double) {
        errors ~= ValidationError("exclusiveMinimum", "Value must be > " ~ exMin.get!double.to!string, "");
        valid = false;
      }
    }

    if (auto exMax = "exclusiveMaximum" in schema) {
      if (value >= exMax.get!double) {
        errors ~= ValidationError("exclusiveMaximum", "Value must be < " ~ exMax.get!double.to!string, "");
        valid = false;
      }
    }

    if (auto multipleOf = "multipleOf" in schema) {
      import std.math : abs, fmod;
      double mod = multipleOf.get!double;
      if (abs(fmod(value, mod)) > 1e-10) {
        errors ~= ValidationError("multipleOf", "Value must be multiple of " ~ mod.to!string, "");
        valid = false;
      }
    }

    return valid;
  }

  /**
   * Validate array constraints.
   */
  protected bool validateArrayConstraints(Json data, Json schema, ref ValidationError[] errors) {
    bool valid = true;
    auto arr = data.get!(Json[]);

    if (auto minItems = "minItems" in schema) {
      if (arr.length < minItems.get!size_t) {
        errors ~= ValidationError("minItems", "Array must have at least " ~ minItems.get!size_t.to!string ~ " items", "");
        valid = false;
      }
    }

    if (auto maxItems = "maxItems" in schema) {
      if (arr.length > maxItems.get!size_t) {
        errors ~= ValidationError("maxItems", "Array must have at most " ~ maxItems.get!size_t.to!string ~ " items", "");
        valid = false;
      }
    }

    if (auto uniqueItems = "uniqueItems" in schema) {
      if (uniqueItems.get!bool) {
        // Check for unique items
        for (size_t i = 0; i < arr.length; i++) {
          for (size_t j = i + 1; j < arr.length; j++) {
            if (arr[i] == arr[j]) {
              errors ~= ValidationError("uniqueItems", "Array items must be unique", "");
              valid = false;
              break;
            }
          }
        }
      }
    }

    // Validate items
    if (auto items = "items" in schema) {
      auto itemSchema = new DJSONSchema(*items);
      auto itemValidator = new DJSONSchemaValidator(itemSchema);
      
      foreach (idx, item; arr) {
        auto result = itemValidator.validate(item);
        if (!result.valid) {
          foreach (err; result.errors) {
            errors ~= ValidationError(
              err.keyword,
              "Item " ~ idx.to!string ~ ": " ~ err.message,
              ""
            );
          }
          valid = false;
        }
      }
    }

    return valid;
  }

  /**
   * Validate object constraints.
   */
  protected bool validateObjectConstraints(Json data, Json schema, ref ValidationError[] errors) {
    bool valid = true;
    auto obj = data.get!(Json[string]);

    if (auto minProps = "minProperties" in schema) {
      if (obj.length < minProps.get!size_t) {
        errors ~= ValidationError("minProperties", "Object must have at least " ~ minProps.get!size_t.to!string ~ " properties", "");
        valid = false;
      }
    }

    if (auto maxProps = "maxProperties" in schema) {
      if (obj.length > maxProps.get!size_t) {
        errors ~= ValidationError("maxProperties", "Object must have at most " ~ maxProps.get!size_t.to!string ~ " properties", "");
        valid = false;
      }
    }

    // Required properties
    if (auto required = "required" in schema) {
      foreach (field; required.get!(Json[])) {
        string fieldName = field.get!string;
        if (fieldName !in obj) {
          errors ~= ValidationError("required", "Required property '" ~ fieldName ~ "' is missing", "");
          valid = false;
        }
      }
    }

    // Validate properties
    if (auto props = "properties" in schema) {
      auto properties = props.get!(Json[string]);
      foreach (propName, propSchema; properties) {
        if (propName in obj) {
          auto propValidator = new DJSONSchemaValidator(new DJSONSchema(propSchema));
          auto result = propValidator.validate(obj[propName]);
          if (!result.valid) {
            foreach (err; result.errors) {
              errors ~= ValidationError(
                err.keyword,
                "Property '" ~ propName ~ "': " ~ err.message,
                propName
              );
            }
            valid = false;
          }
        }
      }
    }

    return valid;
  }

  /**
   * Validate enum constraint.
   */
  protected bool validateEnum(Json data, Json[] enumValues, ref ValidationError[] errors) {
    foreach (enumValue; enumValues) {
      if (data == enumValue) {
        return true;
      }
    }
    errors ~= ValidationError("enum", "Value must be one of the enum values", "");
    return false;
  }
}

unittest {
  auto schema = new DJSONSchema();
  schema.type = "string";
  schema.minLength = 3;
  
  auto validator = new DJSONSchemaValidator(schema);
  
  auto result1 = validator.validate(Json("hello"));
  assert(result1.valid);
  
  auto result2 = validator.validate(Json("hi"));
  assert(!result2.valid);
  assert(result2.errors.length > 0);
}
