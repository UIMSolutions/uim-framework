#!/usr/bin/env dub
/+ dub.sdl:
    dependency "uim-framework:cdm" path="../"
+/
import uim.cdm;
import std.stdio;

void main() {
    writeln("=== UIM CDM Schema Validation Example ===\n");

    // Create a schema for a user entity
    auto userSchema = new Schema("User");
    userSchema
        .description("User entity schema")
        .addField("id", FieldType.UUID, true)
        .addField("username", FieldType.String, true)
        .addField("email", FieldType.String, true)
        .addField("age", FieldType.Integer, false)
        .addField("isActive", FieldType.Boolean, false);

    // Configure field constraints
    userSchema.getField("username").minLength(3).maxLength(50);
    userSchema.getField("email").pattern("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    userSchema.getField("age").minValue(0).maxValue(150);

    writeln("Schema created:");
    writeln(userSchema.toJson().toPrettyString());

    // Create a validator
    auto validator = new SchemaValidator(userSchema);

    // Test valid data
    writeln("\n\n=== Testing Valid Data ===");
    Json validData = Json.emptyObject;
    validData["id"] = "550e8400-e29b-41d4-a716-446655440000";
    validData["username"] = "johndoe";
    validData["email"] = "john@example.com";
    validData["age"] = 30;
    validData["isActive"] = true;

    auto result1 = validator.validate(validData);
    writeln("Is Valid: ", result1.isValid());
    if (!result1.isValid()) {
        writeln("Errors: ", result1.errors());
    }

    // Test invalid data (missing required fields)
    writeln("\n=== Testing Invalid Data (Missing Fields) ===");
    Json invalidData1 = Json.emptyObject;
    invalidData1["username"] = "johndoe";

    auto result2 = validator.validate(invalidData1);
    writeln("Is Valid: ", result2.isValid());
    if (!result2.isValid()) {
        writeln("Errors:");
        foreach (field, error; result2.fieldErrors()) {
            writeln("  ", field, ": ", error);
        }
    }

    // Test invalid data (constraint violations)
    writeln("\n=== Testing Invalid Data (Constraints) ===");
    Json invalidData2 = Json.emptyObject;
    invalidData2["id"] = "550e8400-e29b-41d4-a716-446655440000";
    invalidData2["username"] = "ab"; // Too short
    invalidData2["email"] = "john@example.com";
    invalidData2["age"] = 200; // Too large

    auto result3 = validator.validate(invalidData2);
    writeln("Is Valid: ", result3.isValid());
    if (!result3.isValid()) {
        writeln("Errors:");
        foreach (field, error; result3.fieldErrors()) {
            writeln("  ", field, ": ", error);
        }
    }
}
