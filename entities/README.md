# UIM Entities Library

A comprehensive entity management library for D language, providing OOP patterns for working with domain entities, collections, repositories, validation, and lifecycle events.

## Features

- **Entity Interface & Base Class**: `IEntity` interface and `DEntity` base class
- **State Management**: Track entity lifecycle (New, Clean, Dirty, Deleted)
- **Collections**: Manage groups of entities with querying capabilities
- **Repository Pattern**: Abstract persistence layer with CRUD operations
- **Validation**: Flexible validation system with built-in rules
- **UDA Support**: User Defined Attributes for declarative validation
- **Event Integration**: Lifecycle events integrated with uim-events library
- **Entity Manager**: Coordinates entity lifecycle with automatic event dispatching
- **Serialization**: JSON and associative array conversion

## Core Components

### Entity

Base entity with identity, timestamps, attributes, and state management:

```d
import uim.entities;

// Create entity
auto user = Entity("John Doe");
user.setAttribute("email", "john@example.com");
user.setAttribute("role", "admin");

// State management
assert(user.isNew());
user.markClean();
assert(user.isClean());

// Attributes
auto email = user.getAttribute("email");
bool hasRole = user.hasAttribute("role");
```

### Entity Collection

Manage groups of entities with powerful querying:

```d
auto collection = EntityCollection();

auto user1 = Entity("Alice");
user1.setAttribute("department", "Engineering");

auto user2 = Entity("Bob");
user2.setAttribute("department", "Marketing");

collection.add(user1);
collection.add(user2);

// Query by attribute
auto engineers = collection.findByAttribute("department", "Engineering");

// Query by state
auto dirtyEntities = collection.getDirty();
auto newEntities = collection.getNew();
```

### Repository Pattern

CRUD operations with state-aware persistence:

```d
auto repository = EntityRepository();

// Create
auto product = Entity("Laptop");
product.setAttribute("price", "999");
repository.save(product);

// Read
auto found = repository.find(product.id());
auto all = repository.findAll();
auto byName = repository.findByName("Laptop");

// Update
found.setAttribute("price", "899");
repository.save(found);

// Delete
repository.remove(found);
```

### Validation

Flexible validation with built-in rules:

```d
auto validator = EntityValidator();
validator.addRule("username", new RequiredRule());
validator.addRule("username", new MinLengthRule(3));
validator.addRule("username", new MaxLengthRule(20));
validator.addRule("email", new PatternRule(r"^[a-zA-Z0-9._%+-]+@.*"));

auto user = Entity("User");
user.setAttribute("username", "john");
user.setAttribute("email", "john@example.com");

if (validator.validate(user)) {
    // Entity is valid
}

// Check errors
if (!user.isValid()) {
    foreach (error; user.errors()) {
        writeln(error);
    }
}
```

### UDA-Based Validation

Declarative validation using attributes:

```d
@Entity("users")
class User : DEntity {
    @Required
    @MaxLength(50)
    string username;
    
    @Required
    @Pattern(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
    string email;
    
    @MinLength(8)
    string password;
    
    @Range(0, 150)
    int age;
}

// Create validator from UDAs
auto validator = DEntityValidator.fromEntityType!User();
```

### Entity Manager with Events

Coordinate entity lifecycle with automatic event dispatching:

```d
auto manager = EntityManager();
manager.validator(validator);

// Subscribe to lifecycle events
manager.eventDispatcher().on("entity.beforeCreate", (IEvent event) {
    writeln("Before creating entity");
});

manager.eventDispatcher().on("entity.afterCreate", (IEvent event) {
    auto createEvent = cast(EntityAfterCreateEvent)event;
    writeln("Created: ", createEvent.entity.name());
});

// Create with events
auto user = Entity("User");
user.setAttribute("username", "alice");
manager.create(user); // Fires events and validates

// Update with events
user.setAttribute("email", "alice@example.com");
manager.update(user); // Fires events and validates
```

## Lifecycle Events

The library provides these lifecycle events:

- `entity.beforeCreate` - Before entity creation
- `entity.afterCreate` - After entity creation
- `entity.beforeUpdate` - Before entity update
- `entity.afterUpdate` - After entity update
- `entity.beforeDelete` - Before entity deletion
- `entity.afterDelete` - After entity deletion
- `entity.validated` - After validation
- `entity.stateChanged` - When entity state changes

## Validation Rules

Built-in validation rules:

- `RequiredRule` - Field must not be empty
- `MinLengthRule(size)` - Minimum string length
- `MaxLengthRule(size)` - Maximum string length
- `PatternRule(regex)` - Regex pattern matching

## Entity States

Entities track their lifecycle state:

- `EntityState.New` - Newly created, not persisted
- `EntityState.Clean` - Unchanged since loaded
- `EntityState.Dirty` - Modified since loaded
- `EntityState.Deleted` - Marked for deletion

## License

Apache 2.0 License - See LICENSE.txt
