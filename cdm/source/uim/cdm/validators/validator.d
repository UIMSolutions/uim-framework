/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.cdm.validators.validator;

import uim.cdm;

/**
 * Schema validator for validating data against schemas
 */
class SchemaValidator : UIMObject {
    mixin(ObjThis!("SchemaValidator"));

    protected Schema _schema;

    this(Schema schema) {
        this();
        _schema = schema;
    }

    ValidationResult validate(Json data) {
        auto result = new ValidationResult();

        if (data.type != Json.Type.object) {
            result.addError("Data must be a JSON object");
            return result;
        }

        // Check required fields
        foreach (name, field; _schema.fields) {
            if (field.required && (name !in data || data[name].type == Json.Type.null_)) {
                result.addFieldError(name, "Field is required");
                continue;
            }

            // Skip validation if field is not present and not required
            if (name !in data) {
                continue;
            }

            auto value = data[name];

            // Check nullable
            if (value.type == Json.Type.null_ && !field.nullable) {
                result.addFieldError(name, "Field cannot be null");
                continue;
            }

            // Type-specific validation
            if (value.type != Json.Type.null_) {
                validateFieldValue(cast(SchemaField)field, value, result);
            }
        }

        return result;
    }

    protected void validateFieldValue(SchemaField field, Json value, ValidationResult result) {
        final switch (field.type) {
            case FieldType.String:
                validateString(field, value, result);
                break;
            case FieldType.Integer:
            case FieldType.Long:
                validateInteger(field, value, result);
                break;
            case FieldType.Double:
                validateDouble(field, value, result);
                break;
            case FieldType.Boolean:
                validateBoolean(field, value, result);
                break;
            case FieldType.DateTime:
            case FieldType.Date:
            case FieldType.Time:
                validateDateTime(field, value, result);
                break;
            case FieldType.UUID:
                validateUUID(field, value, result);
                break;
            case FieldType.Array:
                validateArray(field, value, result);
                break;
            case FieldType.Object:
                validateObject(field, value, result);
                break;
            case FieldType.Binary:
            case FieldType.JSON:
                // Basic validation for binary and JSON types
                break;
        }
    }

    protected void validateString(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.string) {
            result.addFieldError(field.name, "Expected string type");
            return;
        }

        string str = value.get!string;
        if (field.minLength > 0 && str.length < field.minLength) {
            result.addFieldError(field.name, "String too short");
        }
        if (field.maxLength > 0 && str.length > field.maxLength) {
            result.addFieldError(field.name, "String too long");
        }
    }

    protected void validateInteger(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.int_) {
            result.addFieldError(field.name, "Expected integer type");
            return;
        }

        long num = value.get!long;
        if (field.minValue != double.init && num < field.minValue) {
            result.addFieldError(field.name, "Value too small");
        }
        if (field.maxValue != double.init && num > field.maxValue) {
            result.addFieldError(field.name, "Value too large");
        }
    }

    protected void validateDouble(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.float_) {
            result.addFieldError(field.name, "Expected number type");
        }
    }

    protected void validateBoolean(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.bool_) {
            result.addFieldError(field.name, "Expected boolean type");
        }
    }

    protected void validateDateTime(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.string) {
            result.addFieldError(field.name, "Expected string for datetime");
        }
    }

    protected void validateUUID(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.string) {
            result.addFieldError(field.name, "Expected string for UUID");
        }
    }

    protected void validateArray(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.array) {
            result.addFieldError(field.name, "Expected array type");
        }
    }

    protected void validateObject(SchemaField field, Json value, ValidationResult result) {
        if (value.type != Json.Type.object) {
            result.addFieldError(field.name, "Expected object type");
        }
    }
}
