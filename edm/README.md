# UIM EDM (Enterprise Data Model) Library

A comprehensive D library for working with the Entity Data Model (EDM) specification, which is the metadata system used by OData to describe the structure and relationships of data.

## Features

- **Complete EDM Type System**: Full implementation of primitive, complex, and entity types
- **Schema Management**: Create and manage EDM schemas with namespaces
- **Property Support**: Both structural (data) and navigation (relationship) properties
- **Type Inheritance**: Support for base types and type hierarchies
- **Key Management**: Define entity keys for identification
- **Fluent API**: Chainable method calls for easy model building
- **Type Safety**: Strongly typed interfaces and implementations
- **Metadata Export**: Generate metadata documents

## Installation

Add to your `dub.sdl`:
```sdl
dependency "uim-framework:edm" path="path/to/uim-framework"
```

Or in `dub.json`:
```json
{
    "dependencies": {
        "uim-framework:edm": "*"
    }
}
```

## Quick Start

### Creating a Simple Schema

```d
import uim.edm;

// Create a schema
auto schema = createSchema("MyCompany.Models");

// Define an entity type
auto personType = schema.createEntityType("Person")
    .addKey("Id")
    .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
    .addProperty("Name", primitiveType(EdmPrimitiveType.String), false)
    .addProperty("Email", primitiveType(EdmPrimitiveType.String), true)
    .addProperty("BirthDate", primitiveType(EdmPrimitiveType.Date), true);
```

### Working with Complex Types

```d
// Define a complex type
auto addressType = schema.createComplexType("Address")
    .addProperty("Street", primitiveType(EdmPrimitiveType.String), false)
    .addProperty("City", primitiveType(EdmPrimitiveType.String), false)
    .addProperty("ZipCode", primitiveType(EdmPrimitiveType.String), true)
    .addProperty("Country", primitiveType(EdmPrimitiveType.String), false);

// Use complex type in entity
personType.addProperty("HomeAddress", addressType, true);
```

### Navigation Properties (Relationships)

```d
// Create Order entity
auto orderType = schema.createEntityType("Order")
    .addKey("Id")
    .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
    .addProperty("OrderDate", primitiveType(EdmPrimitiveType.DateTimeOffset), false)
    .addProperty("Total", primitiveType(EdmPrimitiveType.Decimal), false);

// Add navigation property (one-to-many relationship)
personType.addNavigationProperty("Orders", orderType, true); // true = collection
orderType.addNavigationProperty("Customer", personType, false); // false = single
```

### Type Inheritance

```d
// Create base type
auto employeeType = schema.createEntityType("Employee")
    .baseType(personType)  // Inherit from Person
    .addProperty("EmployeeId", primitiveType(EdmPrimitiveType.String), false)
    .addProperty("HireDate", primitiveType(EdmPrimitiveType.Date), false)
    .addProperty("Salary", primitiveType(EdmPrimitiveType.Decimal), true);

// Set key (can use inherited properties)
employeeType.addKey("Id");
```

## Core Concepts

### EDM Primitive Types

The library supports all OData EDM primitive types:

- **Numeric**: `Int16`, `Int32`, `Int64`, `Single`, `Double`, `Decimal`, `Byte`, `SByte`
- **String**: `String`
- **Boolean**: `Boolean`
- **Binary**: `Binary`, `Stream`
- **Date/Time**: `Date`, `TimeOfDay`, `DateTimeOffset`, `Duration`
- **Identifier**: `Guid`
- **Spatial**: `Geography*`, `Geometry*`

Example:
```d
import uim.edm.enumerations.primitivetypes;

auto stringType = primitiveType(EdmPrimitiveType.String);
auto intType = primitiveType(EdmPrimitiveType.Int32);
auto dateType = primitiveType(EdmPrimitiveType.Date);
```

### Entity Types vs Complex Types

**Entity Types:**
- Have keys for unique identification
- Can be referenced independently
- Can have navigation properties
- Represent resources in OData

**Complex Types:**
- No keys
- Cannot be referenced independently
- Represent structured values
- Used as properties of entities or other complex types

### Properties

**Structural Properties (Data Members):**
```d
auto property = entityType.addProperty("Name", stringType, false)
    .maxLength(100)
    .unicode(true)
    .defaultValue("Unknown");
```

**Navigation Properties (Relationships):**
```d
// One-to-many
entityType.addNavigationProperty("Orders", orderType, true); // collection

// Many-to-one
orderType.addNavigationProperty("Customer", personType, false); // single

// With partner
auto ordersNav = personType.addNavigationProperty("Orders", orderType, true);
auto customerNav = orderType.addNavigationProperty("Customer", personType, false);
ordersNav.partner(customerNav);
customerNav.partner(ordersNav);
```

## Advanced Features

### Abstract Types

```d
auto baseType = schema.createEntityType("BaseEntity")
    .isAbstract(true)
    .addProperty("Id", primitiveType(EdmPrimitiveType.Guid), false);
```

### Open Types

```d
auto openType = schema.createEntityType("DynamicEntity")
    .isOpen(true);  // Allows dynamic properties
```

### Media Entities

```d
auto photoType = schema.createEntityType("Photo")
    .hasStream(true)  // This entity has binary content
    .addProperty("Id", primitiveType(EdmPrimitiveType.Int32), false)
    .addProperty("Title", primitiveType(EdmPrimitiveType.String), false);
```

### Property Constraints

```d
// String constraints
property.maxLength(255)
        .unicode(true);

// Decimal constraints
decimalProperty.precision(18)
               .scale(2);
```

## API Reference

### Schema

- `createSchema(namespace, alias)` - Create a new schema
- `addEntityType(name)` - Add entity type to schema
- `addComplexType(name)` - Add complex type to schema
- `findType(name)` - Find type by name

### Entity Type

- `addKey(propertyName)` - Add key property
- `addProperty(name, type, nullable)` - Add structural property
- `addNavigationProperty(name, targetType, isCollection)` - Add navigation
- `baseType(type)` - Set base type
- `isAbstract(bool)` - Make type abstract
- `hasStream(bool)` - Mark as media entity

### Complex Type

- `addProperty(name, type, nullable)` - Add structural property
- `baseType(type)` - Set base type
- `isAbstract(bool)` - Make type abstract

### Property

- `nullable(bool)` - Set nullable
- `defaultValue(string)` - Set default value
- `maxLength(int)` - Set max length
- `precision(int)` - Set precision
- `scale(int)` - Set scale
- `unicode(bool)` - Set unicode support

## Best Practices

1. **Use Fluent API**: Chain method calls for cleaner code
2. **Define Keys Early**: Add keys before adding properties that reference them
3. **Organize by Schema**: Group related types in the same schema
4. **Document Types**: Use comments to describe entity purposes
5. **Validate Names**: Use consistent naming conventions
6. **Consider Nullable**: Think carefully about nullable properties

## Examples

See the `examples/` directory for complete working examples:
- `basic_schema.d` - Simple schema creation
- `relationships.d` - Navigation properties
- `inheritance.d` - Type hierarchies
- `complex_model.d` - Real-world data model

## Integration with OData

The EDM library is designed to work seamlessly with the UIM OData library:

```d
import uim.edm;
import uim.odata;

// Create EDM model
auto schema = createSchema("MyService");
// ... define types ...

// Use with OData service
auto service = new ODataService(schema);
```

## License

Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.

## Authors

Ozan Nurettin Süel (aka UIManufaktur)

## Contributing

Contributions are welcome! Please ensure:
- Code follows D style guidelines
- All tests pass
- Documentation is updated
- Examples are provided for new features
