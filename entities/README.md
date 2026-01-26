# UIM Entities Library

A comprehensive entity management library for D language, providing OOP patterns for working with domain entities, collections, repositories, validation, and lifecycle events.

## UML Architecture

### Class Diagram

```text
┌─────────────────────────────────────────────────────────────┐
│                      <<interface>>                          │
│                        IEntity                              │
├─────────────────────────────────────────────────────────────┤
│ + id(): UUID                                                │
│ + id(UUID): IEntity                                         │
│ + name(): string                                            │
│ + name(string): IEntity                                     │
│ + createdAt(): SysTime                                      │
│ + updatedAt(): SysTime                                      │
│ + state(): EntityState                                      │
│ + attributes(): string[string]                              │
│ + getAttribute(key, default): string                        │
│ + setAttribute(key, value): IEntity                         │
│ + hasAttribute(key): bool                                   │
│ + removeAttribute(key): IEntity                             │
│ + isNew(), isClean(), isDirty(), isDeleted(): bool          │
│ + markDirty(), markClean(), markDeleted(): void             │
│ + isValid(): bool                                           │
│ + errors(): string[]                                        │
│ + addError(error): IEntity                                  │
│ + toJson(): Json                                            │
│ + toAA(): string[string]                                    │
└─────────────────────────────────────────────────────────────┘
                          △
                          │ implements
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                       UIMEntity                               │
├─────────────────────────────────────────────────────────────┤
│ # _id: UUID                                                 │
│ # _name: string                                             │
│ # _createdAt: SysTime                                       │
│ # _updatedAt: SysTime                                       │
│ # _state: EntityState                                       │
│ # _attributes: string[string]                               │
│ # _errors: string[]                                         │
│ # _originalAttributes: string[string]                       │
├─────────────────────────────────────────────────────────────┤
│ + this()                                                    │
│ + this(UUID)                                                │
│ + getAttribute(key, default): string                        │
│ + setAttribute(key, value): IEntity                         │
│ + hasAttribute(key): bool                                   │
│ + removeAttribute(key): IEntity                             │
│ + isNew(), isClean(), isDirty(), isDeleted(): bool          │
│ + markDirty(), markClean(), markDeleted(): void             │
│ + isValid(): bool                                           │
│ + errors(): string[]                                        │
│ + toJson(): Json                                            │
│ + toAA(): string[string]                                    │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│              <<enumeration>>                                │
│              EntityState                                    │
├─────────────────────────────────────────────────────────────┤
│ New                                                         │
│ Clean                                                       │
│ Dirty                                                       │
│ Deleted                                                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    <<interface>>                            │
│                  IEntityCollection                          │
├─────────────────────────────────────────────────────────────┤
│ + count(): size_t                                           │
│ + isEmpty(): bool                                           │
│ + clear(): void                                             │
│ + add(entity): IEntityCollection                            │
│ + remove(entity): IEntityCollection                         │
│ + removeById(id): IEntityCollection                         │
│ + get(id): IEntity                                          │
│ + findByName(name): IEntity                                 │
│ + findByAttribute(key, value): IEntity[]                    │
│ + getAll(): IEntity[]                                       │
│ + contains(entity): bool                                    │
│ + containsId(id): bool                                      │
│ + getNew(), getDirty(), getClean(), getDeleted(): IEntity[] │
│ + markAllClean(), markAllDirty(): void                      │
└─────────────────────────────────────────────────────────────┘
                          △
                          │ implements
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                  UIMEntityCollection                          │
├─────────────────────────────────────────────────────────────┤
│ # _entities: IEntity[UUID]                                  │
├─────────────────────────────────────────────────────────────┤
│ + count(): size_t                                           │
│ + isEmpty(): bool                                           │
│ + add(entity): IEntityCollection                            │
│ + remove(entity): IEntityCollection                         │
│ + get(id): IEntity                                          │
│ + findByName(name): IEntity                                 │
│ + findByAttribute(key, value): IEntity[]                    │
│ + getNew(), getDirty(), getClean(), getDeleted(): IEntity[] │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                    <<interface>>                            │
│                 IEntityRepository                           │
├─────────────────────────────────────────────────────────────┤
│ + find(id): IEntity                                         │
│ + findAll(): IEntity[]                                      │
│ + save(entity): IEntity                                     │
│ + remove(entity): void                                      │
│ + removeById(id): void                                      │
│ + findByName(name): IEntity                                 │
│ + findByAttribute(key, value): IEntity[]                    │
│ + findByState(state): IEntity[]                             │
│ + saveAll(entities): IEntity[]                              │
│ + removeAll(entities): void                                 │
│ + count(): size_t                                           │
│ + countByState(state): size_t                               │
└─────────────────────────────────────────────────────────────┘
                          △
                          │ implements
                          │
┌─────────────────────────┴───────────────────────────────────┐
│                  UIMEntityRepository                          │
├─────────────────────────────────────────────────────────────┤
│ # _collection: UIMEntityCollection                            │
├─────────────────────────────────────────────────────────────┤
│ + find(id): IEntity                                         │
│ + findAll(): IEntity[]                                      │
│ + save(entity): IEntity                                     │
│ + remove(entity): void                                      │
│ + findByName(name): IEntity                                 │
│ + findByAttribute(key, value): IEntity[]                    │
│ + findByState(state): IEntity[]                             │
│ + saveAll(entities): IEntity[]                              │
│ + count(): size_t                                           │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ uses
                          ▼
                  UIMEntityCollection

┌─────────────────────────────────────────────────────────────┐
│                    <<interface>>                            │
│                 IValidationRule                             │
├─────────────────────────────────────────────────────────────┤
│ + validate(value): bool                                     │
│ + errorMessage(): string                                    │
└─────────────────────────────────────────────────────────────┘
                          △
                          │ implements
            ┌─────────────┼─────────────┬────────────┐
            │             │             │            │
┌───────────┴────┐ ┌──────┴───────┐ ┌──┴──────────┐ ┌┴────────────┐
│ RequiredRule   │ │ MinLengthRule│ │MaxLengthRule│ │PatternRule  │
├────────────────┤ ├──────────────┤ ├─────────────┤ ├─────────────┤
│ + validate()   │ │ # _minLength │ │# _maxLength │ │# _pattern   │
│ + errorMessage│ │ + validate() │ │+ validate() │ │+ validate() │
└────────────────┘ └──────────────┘ └─────────────┘ └─────────────┘

┌─────────────────────────────────────────────────────────────┐
│                  UIMEntityValidator                           │
├─────────────────────────────────────────────────────────────┤
│ # _rules: IValidationRule[][string]                         │
├─────────────────────────────────────────────────────────────┤
│ + addRule(fieldName, rule): UIMEntityValidator                │
│ + validate(entity): bool                                    │
│ + fromEntityType!T(): UIMEntityValidator                      │
└─────────────────────────────────────────────────────────────┘
                          │
                          │ validates
                          ▼
                       IEntity

┌─────────────────────────────────────────────────────────────┐
│                   UIMEntityManager                            │
├─────────────────────────────────────────────────────────────┤
│ # _repository: UIMEntityRepository                            │
│ # _validator: UIMEntityValidator                              │
│ # _eventDispatcher: UIMEventDispatcher                        │
├─────────────────────────────────────────────────────────────┤
│ + validator(val): UIMEntityManager                            │
│ + eventDispatcher(): UIMEventDispatcher                       │
│ + create(entity): IEntity                                   │
│ + update(entity): IEntity                                   │
│ + remove(entity): void                                      │
│ + find(id): IEntity                                         │
│ + findAll(): IEntity[]                                      │
│ + findByName(name): IEntity                                 │
│ + findByAttribute(key, value): IEntity[]                    │
│ + repository(): UIMEntityRepository                           │
└─────────────────────────────────────────────────────────────┘
                          │
                    ┌─────┼─────┐
                    │     │     │
                    │     │     │
                    ▼     ▼     ▼
            Repository Validator Events

┌─────────────────────────────────────────────────────────────┐
│                Entity Lifecycle Events                      │
├─────────────────────────────────────────────────────────────┤
│ EntityBeforeCreateEvent                                     │
│ EntityAfterCreateEvent                                      │
│ EntityBeforeUpdateEvent                                     │
│ EntityAfterUpdateEvent                                      │
│ EntityBeforeDeleteEvent                                     │
│ EntityAfterDeleteEvent                                      │
│ EntityValidateUIMEvent                                        │
│ EntityStateChangeEvent                                     │
└─────────────────────────────────────────────────────────────┘
```

### Component Interaction Diagram

```text
    ┌──────────────┐
    │    Client    │
    └──────┬───────┘
           │
           ▼
    ┌──────────────────┐
    │ EntityManager    │  Coordinates lifecycle
    └─────┬───┬───┬────┘
          │   │   │
    ┌─────┘   │   └──────┐
    │         │          │
    ▼         ▼          ▼
┌────────┐ ┌─────────┐ ┌──────────────┐
│Validator│ │Repository│ │EventDispatcher│
└────┬───┘ └────┬────┘ └──────┬───────┘
     │          │             │
     │validates │persists     │notifies
     │          │             │
     ▼          ▼             ▼
   ┌──────────────────┐   ┌────────┐
   │     IEntity      │   │Listeners│
   └──────┬───────────┘   └────────┘
          │
          │contains
          ▼
   ┌──────────────────┐
   │  IEntityCollection│
   └───────────────────┘
```

### Sequence Diagram: Creating an Entity

```text
Client      Manager      Validator    Repository    Events
  │            │             │             │           │
  │─create()──>│             │             │           │
  │            │             │             │           │
  │            │─beforeCreate────────────────────────> │
  │            │             │             │           │
  │            │─validate()─>│             │           │
  │            │<────valid───┤             │           │
  │            │             │             │           │
  │            │─validated───────────────────────────> │
  │            │             │             │           │
  │            │─save()──────────────────> │           │
  │            │             │             │           │
  │            │             │             │─markClean()
  │            │             │             │           │
  │            │─afterCreate─────────────────────────> │
  │            │             │             │           │
  │<───entity──┤             │             │           │
  │            │             │             │           │
```

### Sequence Diagram: Validating an Entity

```text
Manager     Validator    Entity       Rules
  │            │            │            │
  │─validate()─>│           │            │
  │            │            │            │
  │            │─clearErrors()           │
  │            │            │            │
  │            │─attributes()            │
  │            │<───data────┤            │
  │            │            │            │
  │            │─validate(field1)───────>│
  │            │<───true/false───────────┤
  │            │            │            │
  │            │─validate(field2)───────>│
  │            │<───true/false───────────┤
  │            │            │            │
  │            │─addError()─>│ (if invalid)
  │            │            │            │
  │<─bool──────┤            │            │
  │            │            │            │
```

### State Diagram: Entity Lifecycle

```text
              ┌─────────────┐
        ┌────>│     New     │
        │     └──────┬──────┘
        │            │
        │            │ save()
        │            ▼
        │     ┌─────────────┐
        │     │    Clean    │<────┐
        │     └──────┬──────┘     │
        │            │             │
        │            │ setAttribute() │ save()
        │            ▼             │
        │     ┌─────────────┐     │
        │     │    Dirty    │─────┘
        │     └──────┬──────┘
        │            │
        │            │ markDeleted()
        │            ▼
        │     ┌─────────────┐
        └─────│   Deleted   │
              └─────────────┘
```

### Repository Pattern Diagram

```text
┌───────────────────────────────────────────┐
│         Application Layer                 │
│  ┌─────────────────────────────────────┐ │
│  │      UIMEntityManager                 │ │
│  └────────────┬────────────────────────┘ │
└───────────────┼───────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────┐
│       Persistence Layer                   │
│  ┌─────────────────────────────────────┐ │
│  │    <<interface>>                    │ │
│  │   IEntityRepository                 │ │
│  └────────────┬────────────────────────┘ │
│               │ implements               │
│               ▼                          │
│  ┌─────────────────────────────────────┐ │
│  │    UIMEntityRepository                │ │
│  │  (In-Memory Implementation)         │ │
│  └────────────┬────────────────────────┘ │
└───────────────┼───────────────────────────┘
                │
                ▼
┌───────────────────────────────────────────┐
│         Data Layer                        │
│  ┌─────────────────────────────────────┐ │
│  │    UIMEntityCollection                │ │
│  │   IEntity[UUID]                     │ │
│  └─────────────────────────────────────┘ │
└───────────────────────────────────────────┘
```

### Package Diagram

```text
┌────────────────────────────────────────────────────────────┐
│                   uim.entities                             │
├────────────────────────────────────────────────────────────┤
│                                                            │
│  ┌──────────────────┐         ┌──────────────────┐       │
│  │   interfaces/    │         │    helpers/      │       │
│  ├──────────────────┤         ├──────────────────┤       │
│  │ - IEntity        │         │ - repository.d   │       │
│  │ - IEntityCollection│       └──────────────────┘       │
│  │ - IRepository    │                │                   │
│  └────────┬─────────┘                │                   │
│           │ defines                  │ implements         │
│           │                          │                   │
│           ▼                          ▼                   │
│  ┌────────────────────────────────────────────┐         │
│  │  Core Implementation                       │         │
│  ├────────────────────────────────────────────┤         │
│  │ - entity.d (UIMEntity)                       │         │
│  │ - collection.d (UIMEntityCollection)         │         │
│  │ - validator.d (UIMEntityValidator)           │         │
│  │ - manager.d (UIMEntityManager)               │         │
│  └────────────────────────────────────────────┘         │
│           │                                              │
│           │ uses                                         │
│           ▼                                              │
│  ┌────────────────────────────────────────────┐         │
│  │  events.d                                  │         │
│  ├────────────────────────────────────────────┤         │
│  │ - EntityBeforeCreateEvent                  │         │
│  │ - EntityAfterCreateEvent                   │         │
│  │ - EntityBeforeUpdateEvent                  │         │
│  │ - EntityAfterUpdateEvent                   │         │
│  │ - EntityBeforeDeleteEvent                  │         │
│  │ - EntityAfterDeleteEvent                   │         │
│  │ - EntityValidateUIMEvent                     │         │
│  │ - EntityStateChangeEvent                  │         │
│  └────────────────────────────────────────────┘         │
│                                                            │
│  External Dependencies:                                   │
│  - uim.core (UIMObject, ShowModule)                      │
│  - uim.events (UIMEvent, UIMEventDispatcher)                 │
│  - vibe.data.json (Json)                                 │
│  - std.uuid (UUID)                                       │
│  - std.datetime (SysTime)                                │
└────────────────────────────────────────────────────────────┘
```

## Features

- **Entity Interface & Base Class**: `IEntity` interface and `UIMEntity` base class
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

Base entity with iUIMEntity, timestamps, attributes, and state management:

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
@UseEntity("users")
class User : UIMEntity {
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
auto validator = UIMEntityValidator.fromEntityType!User();
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

## Design Patterns Used

### 1. Repository Pattern

**Purpose**: Abstracts data persistence layer  
**Implementation**: `IEntityRepository` and `UIMEntityRepository`  
**Benefits**: Decouples business logic from data access, enables testing with mock repositories

### 2. Observer Pattern

**Purpose**: Notifies views/listeners of entity changes  
**Implementation**: Event system with lifecycle events  
**Benefits**: Loose coupling between entities and their observers

### 3. State Pattern

**Purpose**: Entity behavior changes based on lifecycle state  
**Implementation**: `EntityState` enum with state-specific operations  
**Benefits**: Clear entity lifecycle management

### 4. Composite Pattern

**Purpose**: Treat individual entities and collections uniformly  
**Implementation**: `IEntityCollection` manages multiple `IEntity` objects  
**Benefits**: Simplifies bulk operations on entities

### 5. Strategy Pattern

**Purpose**: Interchangeable validation strategies  
**Implementation**: `IValidationRule` with multiple implementations  
**Benefits**: Flexible validation logic, easy to extend

### 6. Factory Pattern

**Purpose**: Simplified object creation  
**Implementation**: Factory functions like `Entity()`, `EntityCollection()`  
**Benefits**: Cleaner code, consistent object initialization

### 7. Chain of Responsibility

**Purpose**: Multiple validation rules processed in sequence  
**Implementation**: Multiple `IValidationRule` per field  
**Benefits**: Flexible validation pipelines

## Performance Optimizations

The library includes several performance optimizations:

1. **Direct Field Access**: Reduced method call overhead by using direct field access where safe
2. **Lazy Evaluation**: State filtering methods only create arrays when needed
3. **Memory Pre-allocation**: Collections pre-allocate capacity based on heuristics
4. **Efficient Lookups**: Uses associative arrays with pointer checks for O(1) access
5. **Batch Operations**: Optimized `saveAll()` and `removeAll()` methods
6. **Reduced Allocations**: String formatting uses `format()` instead of concatenation
7. **Iterator Optimization**: Uses `byValue` for better performance in loops

## Best Practices

1. **Use Repository Pattern**: Always access entities through repositories for consistency
2. **Validate Before Saving**: Use validators to ensure data integrity
3. **Listen to Events**: Subscribe to lifecycle events for cross-cutting concerns
4. **Mark State Explicitly**: Use `markClean()`, `markDirty()` appropriately
5. **Batch Operations**: Use `saveAll()` for multiple entities instead of individual saves
6. **Check State**: Always check entity state before operations
7. **Handle Errors**: Check `isValid()` and `errors()` after validation

## Thread Safety

**Note**: The current implementation is not thread-safe. For concurrent access:

- Use external synchronization (mutexes, locks)
- Consider implementing thread-safe collection variants
- Use thread-local entity managers in multi-threaded applications

## Testing

The library includes comprehensive unit tests. Run tests with:

```bash
dub test
```

## License

Apache 2.0 License - See LICENSE.txt
