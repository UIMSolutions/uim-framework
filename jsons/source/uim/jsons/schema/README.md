# UIM-JSONSchema - JSON Schema Library

**Version**: 1.0.0  
**Author**: Ozan Nurettin Süel (aka UIManufaktur)  
**License**: Apache 2.0  
**Language**: D

## Overview

UIM-JSONSchema is a comprehensive JSON Schema validation and generation library for the D programming language, supporting JSON Schema Draft 7. It provides tools for defining, validating, and working with JSON schemas.

## Features

- **Schema Definition**: Create JSON schemas programmatically
- **Validation**: Validate JSON data against schemas
- **Type Support**: All JSON Schema types (string, number, integer, boolean, object, array, null)
- **Constraints**: Min/max, length, patterns, formats, enums
- **Composition**: allOf, anyOf, oneOf, not
- **Format Validators**: Email, URI, date, datetime, IPv4, IPv6
- **Fluent Builder API**: Chainable schema construction
- **Error Reporting**: Detailed validation error messages

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-jsonschema" path="../jsonschema"
```

## Usage Examples

### Basic Schema Creation

```d
import uim.jsonschema;

// Create a string schema
auto schema = new DJSONSchema();
schema.type = "string";
schema.minLength = 3;
schema.maxLength = 50;
schema.pattern = "^[A-Za-z]+$";

// Validate data
auto validator = new DJSONSchemaValidator(schema);
auto result = validator.validate(Json("hello"));

if (result.valid) {
    writeln("Valid!");
} else {
    foreach (error; result.errors) {
        writeln(error.toString());
    }
}
```

### Using Schema Builder (Fluent API)

```d
// Build a complex schema fluently
auto userSchema = schemaBuilder("object")
    .title("User")
    .description("User registration schema")
    .property("username", 
        schemaBuilder("string")
            .minLength(3)
            .maxLength(20)
            .pattern("^[a-zA-Z0-9_]+$")
    )
    .property("email", 
        schemaBuilder("string")
            .format("email")
    )
    .property("age", 
        schemaBuilder("integer")
            .minimum(18)
            .maximum(120)
    )
    .property("role",
        schemaBuilder("string")
            .enumValues([Json("admin"), Json("user"), Json("guest")])
    )
    .required(["username", "email"])
    .additionalProperties(false)
    .build();

// Use the schema
auto validator = new DJSONSchemaValidator(userSchema);
```

### Type Helper Functions

```d
import uim.jsonschema;

// Quick type schemas
auto stringSchema = SchemaTypes.string_(5, 100);
auto numberSchema = SchemaTypes.number(0.0, 100.0);
auto integerSchema = SchemaTypes.integer(1, 1000);
auto boolSchema = SchemaTypes.boolean();
auto emailSchema = SchemaTypes.email();
auto dateSchema = SchemaTypes.date();
auto uriSchema = SchemaTypes.uri();

// Array schema
auto arraySchema = SchemaTypes.array(SchemaTypes.string_());
arraySchema.minItems = 1;
arraySchema.maxItems = 10;
arraySchema.uniqueItems = true;
```

### Object Schema with Properties

```d
auto addressSchema = schemaBuilder("object")
    .property("street", SchemaTypes.string_())
    .property("city", SchemaTypes.string_())
    .property("zipCode", schemaBuilder("string").pattern("^\\d{5}$"))
    .property("country", SchemaTypes.string_())
    .required(["street", "city", "country"])
    .build();

auto personSchema = schemaBuilder("object")
    .property("name", SchemaTypes.string_(1, 100))
    .property("age", SchemaTypes.integer(0, 150))
    .property("address", addressSchema)
    .property("phoneNumbers", 
        SchemaTypes.array(SchemaTypes.string_()))
    .required(["name"])
    .build();
```

### Number Constraints

```d
auto priceSchema = schemaBuilder("number")
    .minimum(0.0)
    .exclusiveMaximum(1000000.0)
    .multipleOf(0.01)  // Two decimal places
    .build();

auto quantitySchema = schemaBuilder("integer")
    .minimum(1)
    .maximum(999)
    .build();
```

### String Formats

```d
// Email validation
auto emailSchema = SchemaTypes.email();
auto validator = new DJSONSchemaValidator(emailSchema);
assert(validator.validate(Json("user@example.com")).valid);
assert(!validator.validate(Json("invalid")).valid);

// Date validation (YYYY-MM-DD)
auto dateSchema = SchemaTypes.date();
assert(validator.validate(Json("2026-01-19")).valid);

// DateTime validation (ISO 8601)
auto datetimeSchema = SchemaTypes.dateTime();
assert(validator.validate(Json("2026-01-19T10:30:00Z")).valid);

// IPv4 validation
auto ipSchema = SchemaTypes.ipv4();
assert(validator.validate(Json("192.168.1.1")).valid);
```

### Array Validation

```d
auto tagsSchema = schemaBuilder("array")
    .items(SchemaTypes.string_())
    .minItems(1)
    .maxItems(5)
    .uniqueItems(true)
    .build();

auto data = Json([Json("tag1"), Json("tag2"), Json("tag3")]);
auto result = new DJSONSchemaValidator(tagsSchema).validate(data);
```

### Enum Values

```d
auto statusSchema = schemaBuilder("string")
    .enumValues([
        Json("pending"),
        Json("approved"),
        Json("rejected")
    ])
    .build();

// Only these values are valid
assert(validator.validate(Json("approved")).valid);
assert(!validator.validate(Json("unknown")).valid);
```

### Schema Composition

```d
// allOf - Must match all schemas
auto nameSchema = SchemaTypes.string_(1, 100);
auto patternSchema = schemaBuilder("string")
    .pattern("^[A-Z]")  // Must start with uppercase
    .build();

auto composedSchema = new DJSONSchema();
composedSchema.allOf([nameSchema, patternSchema]);

// anyOf - Must match at least one
auto stringOrNumber = new DJSONSchema();
stringOrNumber.anyOf([
    SchemaTypes.string_(),
    SchemaTypes.number()
]);

// oneOf - Must match exactly one
auto strictType = new DJSONSchema();
strictType.oneOf([
    SchemaTypes.string_(),
    SchemaTypes.integer()
]);
```

### Const and Default Values

```d
auto configSchema = schemaBuilder("object")
    .property("version", schemaBuilder("string").constValue(Json("1.0.0")))
    .property("debug", schemaBuilder("boolean").defaultValue(Json(false)))
    .property("maxRetries", schemaBuilder("integer").defaultValue(Json(3)))
    .build();
```

### Validation with Detailed Errors

```d
auto schema = schemaBuilder("object")
    .property("name", SchemaTypes.string_(3, 50))
    .property("age", SchemaTypes.integer(0, 150))
    .required(["name", "age"])
    .build();

auto data = Json.emptyObject;
data["name"] = "Jo";  // Too short
// Missing 'age' field

auto validator = new DJSONSchemaValidator(schema);
auto result = validator.validate(data);

if (!result.valid) {
    writeln("Validation failed:");
    foreach (error; result.errors) {
        writeln("  ", error.keyword, ": ", error.message);
        if (error.path.length > 0) {
            writeln("    at: ", error.path);
        }
    }
}
```

### Custom Format Validators

```d
class CustomFormatValidator : DFormatValidator {
    bool validate(string value) {
        // Custom validation logic
        return value.startsWith("CUSTOM-");
    }

    string formatName() {
        return "custom-format";
    }
}

// Register in validator
auto validator = new DJSONSchemaValidator(schema);
// Note: Currently format validators are registered in constructor
```

### Complete Example: User Registration

```d
import uim.jsonschema;
import std.stdio;

void main() {
    // Define schema
    auto registrationSchema = schemaBuilder("object")
        .title("User Registration")
        .property("username", 
            schemaBuilder("string")
                .minLength(3)
                .maxLength(20)
                .pattern("^[a-zA-Z0-9_]+$")
                .description("Alphanumeric username")
        )
        .property("email", SchemaTypes.email())
        .property("password",
            schemaBuilder("string")
                .minLength(8)
                .pattern(".*[A-Z].*")  // At least one uppercase
        )
        .property("age", SchemaTypes.integer(18, 120))
        .property("terms", SchemaTypes.boolean())
        .required(["username", "email", "password", "terms"])
        .build();

    // Test data
    auto userData = Json.emptyObject;
    userData["username"] = "john_doe";
    userData["email"] = "john@example.com";
    userData["password"] = "SecurePass123";
    userData["age"] = 25;
    userData["terms"] = true;

    // Validate
    auto validator = new DJSONSchemaValidator(registrationSchema);
    auto result = validator.validate(userData);

    if (result.valid) {
        writeln("Registration data is valid!");
    } else {
        writeln("Validation errors:");
        foreach (error; result.errors) {
            writeln("  - ", error.toString());
        }
    }
}
```

## Supported JSON Schema Features

### Types
- ✅ string
- ✅ number
- ✅ integer
- ✅ boolean
- ✅ object
- ✅ array
- ✅ null

### String Validation
- ✅ minLength
- ✅ maxLength
- ✅ pattern (regex)
- ✅ format (email, uri, date, datetime, ipv4, ipv6)

### Number Validation
- ✅ minimum
- ✅ maximum
- ✅ exclusiveMinimum
- ✅ exclusiveMaximum
- ✅ multipleOf

### Object Validation
- ✅ properties
- ✅ required
- ✅ additionalProperties
- ✅ minProperties
- ✅ maxProperties

### Array Validation
- ✅ items
- ✅ minItems
- ✅ maxItems
- ✅ uniqueItems

### Generic Validation
- ✅ enum
- ✅ const
- ✅ default

### Schema Composition
- ✅ allOf
- ✅ anyOf
- ✅ oneOf
- ✅ not

## Architecture

```
uim.jsonschema
├── schema.d       - Schema definition and manipulation
├── validator.d    - Validation engine
├── types.d        - Type helpers and shortcuts
├── formats.d      - Format validators (email, uri, etc.)
├── builder.d      - Fluent schema builder API
└── errors.d       - Error types and reporting
```

## Future Enhancements

- Schema references ($ref resolution)
- Remote schema loading
- Schema compilation for performance
- Custom vocabulary support
- JSON Schema 2020-12 support
- Schema generation from D types
- OpenAPI integration

## Contributing

Contributions welcome! Please ensure:
- Code follows D best practices
- Unit tests included
- Documentation updated

## License

Copyright © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)

Licensed under the Apache License, Version 2.0.

## Dependencies

- uim-oop - Object-oriented patterns
- uim-core - Core utilities  
- uim-json - JSON processing

## Building

```bash
cd jsonschema
dub build
dub test
```
