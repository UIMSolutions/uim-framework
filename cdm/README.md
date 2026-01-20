# UIM CDM - Common Data Model Library

A comprehensive Common Data Model (CDM) library for the UIM Framework, providing standardized data structures, schemas, and transformations for enterprise applications.

## Features

- **Standardized Data Models**: Common business entities and data structures
- **Schema Definitions**: Flexible schema system for data validation and transformation
- **Data Validators**: Built-in validation for common data types and patterns
- **Data Transformers**: Transform data between different formats and representations
- **Entity Integration**: Seamless integration with UIM entities framework

## Supported Models

- **Account**: Customer and business account management
- **Contact**: Contact information and relationships
- **Organization**: Company and organizational structures
- **Product**: Product catalog and inventory
- **Order**: Sales orders and transactions
- **Invoice**: Billing and invoicing
- **Custom Models**: Extensible framework for custom data models

## Usage

```d
import uim.cdm;

// Create a contact model
auto contact = Contact()
    .firstName("John")
    .lastName("Doe")
    .email("john.doe@example.com")
    .phone("+1-555-0123");

// Validate the model
if (contact.isValid()) {
    // Transform to JSON
    auto json = contact.toJson();
}

// Define a custom schema
auto schema = Schema("CustomEntity")
    .addField("id", FieldType.UUID, true)
    .addField("name", FieldType.String, true)
    .addField("createdAt", FieldType.DateTime, true);

// Validate data against schema
auto validator = SchemaValidator(schema);
auto result = validator.validate(data);
```

## Installation

Add to your `dub.sdl` or `dub.json`:

```sdl
dependency "uim-framework:cdm" version="~>26.1.0"
```

## Documentation

See the [docs](docs/) directory for detailed documentation.

## License

Apache 2.0 - See LICENSE file for details.
