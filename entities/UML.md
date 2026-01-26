# UIM Entities - UML Architecture

## Overview
The UIM Entities library provides a comprehensive entity management system with lifecycle support, validation, event integration, and collection management. It follows a layered architecture with clear separation of concerns between entities, repositories, validators, and event dispatching.

## Class Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         UIM Framework Dependencies                       │
│                   (uim-core, uim-oop, uim-events)                       │
└─────────────────────────────────────────────────────────────────────────┘
                                    ▲
                                    │ imports
                    ┌───────────────┼───────────────┐
                    │               │               │
           ┌────────▼────────┐ ┌────▼────────┐ ┌───▼───────────┐
           │   UIMObject     │ │  UIMEvent   │ │ EventDispatcher│
           │                 │ │             │ │                │
           │ (from uim-core) │ │(from events)│ │ (from events) │
           └─────────────────┘ └─────────────┘ └────────────────┘


                        ┌──────────────────────────┐
                        │      Entity Model        │
                        └──────────────────────────┘
                                    │
        ┌───────────────────────────┼───────────────────────────┐
        │                           │                           │
        ▼                           ▼                           ▼
┌──────────────────┐       ┌─────────────────────┐    ┌─────────────────┐
│  <<interface>>   │       │  EntityState Enum   │    │ <<interface>>   │
│     IEntity      │       │                     │    │    IEntity      │
├──────────────────┤       ├─────────────────────┤    │                 │
│ + id(): UUID     │       │ New                 │    │ + id(): UUID    │
│ + name(): string │       │ Clean               │    │ + name(): string│
│ + state()        │       │ Dirty               │    │ + state()       │
│ + attributes()   │       │ Deleted             │    │ + attributes()  │
│                  │       └─────────────────────┘    │ + isNew()       │
│ + getAttribute() │                                  │ + isDirty()     │
│ + setAttribute() │                                  │ + isClean()     │
│ + removeAttr()   │                                  │ + isDeleted()   │
│ + isValid()      │                                  │                 │
│ + errors()       │                                  │ + setAttribute()│
│ + addError()     │                                  │ + getAttribute()│
│ + toJson()       │                                  │ + hasAttribute()│
│ + toAA()         │                                  │ + removeAttr()  │
│ + markDirty()    │                                  │ + isValid()     │
│ + markClean()    │                                  │ + errors()      │
│ + markDeleted()  │                                  │ + addError()    │
└──────────────────┘                                  │ + clearErrors() │
        ▲                                             │ + toJson()      │
        │ implements                                  │ + toAA()        │
        │                                             │ + markDirty()   │
┌───────┴──────────┐                                  │ + markClean()   │
│    UIMEntity       │                                  │ + markDeleted() │
├──────────────────┤                                  └─────────────────┘
│ - _id: UUID      │
│ - _name: string  │
│ - _state        │
│ - _createdAt    │
│ - _updatedAt    │
│ - _attributes   │
│ - _errors       │
│ - _original     │
│                  │
│ + this()         │
│ + this(UUID)     │
└──────────────────┘


                    ┌──────────────────────────┐
                    │   Collection Model       │
                    └──────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
    ┌──────────────────┐ ┌──────────────────────────┐
    │ <<interface>>    │ │     UIMEntityCollection    │
    │ IEntityCollection│ ├──────────────────────────┤
    ├──────────────────┤ │ - _entities: IEntity[]   │
    │ + count()        │ │                          │
    │ + isEmpty()      │ │ + this()                 │
    │ + clear()        │ │ + count()                │
    │ + add(IEntity)   │ │ + isEmpty()              │
    │ + remove()       │ │ + clear()                │
    │ + removeById()   │ │ + add(IEntity)           │
    │ + get(UUID)      │ │ + remove(IEntity)        │
    │ + findByName()   │ │ + removeById(UUID)       │
    │ + findByAttr()   │ │ + get(UUID)              │
    │ + getAll()       │ │ + findByName(string)     │
    │ + contains()     │ │ + findByAttr()           │
    │ + containsId()   │ │ + getAll()               │
    │ + getNew()       │ │ + contains()             │
    │ + getDirty()     │ │ + containsId()           │
    │ + getClean()     │ │ + getNew()               │
    │ + getDeleted()   │ │ + getDirty()             │
    │ + markAllClean() │ │ + getClean()             │
    │ + markAllDirty() │ │ + getDeleted()           │
    └──────────────────┘ │ + markAllClean()         │
         ▲               │ + markAllDirty()         │
         │ implements    └──────────────────────────┘
         └────────────────────┐
                              │
                    UIMEntityCollection


                    ┌──────────────────────────┐
                    │   Validation Model       │
                    └──────────────────────────┘
                              │
    ┌─────────────────────────┼──────────────────────────┐
    ▼                         ▼                          ▼
┌──────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ <<interface>>│  │   RequiredRule   │  │  MaxLengthRule   │
│IValidationRle │  │   : IValidRule   │  │  : IValidRule    │
├──────────────┤  ├──────────────────┤  ├──────────────────┤
│ + validate() │  │ + validate()     │  │ - _maxLength     │
│ + errorMsg() │  │ + errorMessage() │  │ + validate()     │
└──────────────┘  └──────────────────┘  │ + errorMessage() │
        ▲                                 └──────────────────┘
        │ implements
        │
    ┌───┴──────────────────────────────────────┐
    │                                          │
    ▼                                          ▼
┌──────────────┐                   ┌──────────────────┐
│ MinLengthRle │                   │  PatternRule     │
│:IValidRule   │                   │  : IValidRule    │
├──────────────┤                   ├──────────────────┤
│ - _minLength │                   │ - _pattern       │
│ + validate() │                   │ + validate()     │
│ + errorMsg() │                   │ + errorMessage() │
└──────────────┘                   └──────────────────┘

    ┌──────────────────────────┐
    │   UIMEntityValidator       │
    ├──────────────────────────┤
    │ - _rules: IValidRule[]   │
    │                          │
    │ + addRule()              │
    │ + removeRule()           │
    │ + validate(IEntity)      │
    │ + errors()               │
    └──────────────────────────┘


                    ┌──────────────────────────┐
                    │    Event Model           │
                    └──────────────────────────┘
                              │
    ┌─────────────────────────┼──────────────────────────────┐
    │                         │                              │
    ▼                         ▼                              ▼
┌────────────────┐  ┌──────────────────────┐  ┌──────────────────┐
│ UIMEvent       │  │EntityBeforeCreateEv  │  │EntityAfterCreateEv
│(from events)   │  │  : UIMEvent          │  │  : UIMEvent      │
│                │  ├──────────────────────┤  ├──────────────────┤
│ + name()       │  │ + entity: IEntity    │  │ + entity: IEntity│
│ + data()       │  │ + this(IEntity)      │  │ + this(IEntity)  │
│ + timestamp()  │  └──────────────────────┘  └──────────────────┘
│ + stopped()    │
│                │  ┌──────────────────────┐  ┌──────────────────┐
│ + stopPropag() │  │EntityBeforeUpdateEv  │  │EntityAfterUpdateEv
│ + isPropagStp()│  │  : UIMEvent          │  │  : UIMEvent      │
│ + setData()    │  ├──────────────────────┤  ├──────────────────┤
│ + getData()    │  │ + entity: IEntity    │  │ + entity: IEntity│
│ + hasKey()     │  │ + this(IEntity)      │  │ + this(IEntity)  │
└────────────────┘  └──────────────────────┘  └──────────────────┘

    ┌──────────────────────┐  ┌──────────────────────┐
    │EntityBeforeDeleteEv  │  │EntityAfterDeleteEv   │
    │  : UIMEvent          │  │  : UIMEvent          │
    ├──────────────────────┤  ├──────────────────────┤
    │ + entity: IEntity    │  │ + entity: IEntity    │
    │ + this(IEntity)      │  │ + this(IEntity)      │
    └──────────────────────┘  └──────────────────────┘

    ┌──────────────────────┐  ┌──────────────────────┐
    │EntityValidateUIMEvent│  │EntityStateChangeEv   │
    │  : UIMEvent          │  │  : UIMEvent          │
    ├──────────────────────┤  ├──────────────────────┤
    │ + entity: IEntity    │  │ + entity: IEntity    │
    │ + isValid: bool      │  │ + oldState: StateEnum│
    │ + this(IEntity,bool) │  │ + newState: StateEnum│
    └──────────────────────┘  │ + this(IEntity...)   │
                             └──────────────────────┘


                    ┌──────────────────────────┐
                    │   Repository Model       │
                    └──────────────────────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
    ┌──────────────────┐ ┌──────────────────┐
    │ <<interface>>    │ │ UIMEntityRepository│
    │ IEntityRepository│ │                  │
    ├──────────────────┤ ├──────────────────┤
    │ + save()         │ │ - _entities      │
    │ + delete()       │ │ + save()         │
    │ + findById()     │ │ + delete()       │
    │ + findAll()      │ │ + findById()     │
    └──────────────────┘ │ + findAll()      │
         ▲               │ + exists()       │
         │ implements    └──────────────────┘
         └────────────────────┐
                              │
                    UIMEntityRepository


                    ┌──────────────────────────┐
                    │   Manager (Coordinator)  │
                    └──────────────────────────┘
                              │
                              ▼
                    ┌──────────────────────────┐
                    │  UIMEntityManager          │
                    ├──────────────────────────┤
                    │ - _repository            │
                    │ - _validator             │
                    │ - _eventDispatcher       │
                    │                          │
                    │ + create(IEntity)        │
                    │ + update(IEntity)        │
                    │ + delete(IEntity)        │
                    │ + validator(Validator)   │
                    │ + eventDispatcher()      │
                    └──────────────────────────┘
                           │ coordinates
           ┌───────────────┼───────────────┐
           ▼               ▼               ▼
       Repository     Validator      EventDispatcher
                    (from events)
```

## Component Relationships

### Entity Lifecycle Flow

```
┌─────────────────────────────────────────────────────────────────────┐
│                         Entity Manager                               │
└─────────────────────────────────────────────────────────────────────┘
                              │
                ┌─────────────┼─────────────┐
                │             │             │
                ▼             ▼             ▼
            CREATE        UPDATE          DELETE
                │             │             │
                ├─────────────┼─────────────┤
                │             │             │
                ▼             ▼             ▼
         BeforeCreate   BeforeUpdate   BeforeDelete
         (Event 1)      (Event 1)      (Event 1)
                │             │             │
                ▼             ▼             ▼
         ┌─────────────────────────────────────┐
         │      Validate (if validator set)    │
         │      Validate Event dispatched      │
         └─────────────────────────────────────┘
                │             │             │
                ▼             ▼             ▼
         ┌─────────────────────────────────────┐
         │      Repository.save()              │
         │      (Persists entity)              │
         └─────────────────────────────────────┘
                │             │             │
                ▼             ▼             ▼
         AfterCreate    AfterUpdate     AfterDelete
         (Event 2)      (Event 2)       (Event 2)
                │             │             │
                └─────────────┼─────────────┘
                              ▼
                        Return Entity
```

### Event Integration

The EntityManager integrates with the EventDispatcher to emit lifecycle events:

```
┌────────────────────────────────────────────────────┐
│              EntityManager Events                  │
├────────────────────────────────────────────────────┤
│ 1. EntityBeforeCreateEvent                         │
│ 2. EntityValidateUIMEvent (if validator exists)    │
│ 3. EntityAfterCreateEvent                          │
│                                                     │
│ 1. EntityBeforeUpdateEvent                         │
│ 2. EntityValidateUIMEvent (if validator exists)    │
│ 3. EntityAfterUpdateEvent                          │
│                                                     │
│ 1. EntityBeforeDeleteEvent                         │
│ 2. EntityAfterDeleteEvent                          │
│                                                     │
│ Additional: EntityStateChangeEvent                 │
│            (fired when entity state changes)       │
└────────────────────────────────────────────────────┘
```

## Key Design Patterns

### 1. **Composition Pattern**
   - `UIMEntityManager` composes `UIMEntityRepository`, `UIMEntityValidator`, and `UIMEventDispatcher`
   - Allows flexible swapping of implementations

### 2. **Observer Pattern**
   - Event system integrated throughout entity lifecycle
   - External subscribers can react to entity changes without coupling

### 3. **State Pattern**
   - `EntityState` enum tracks entity lifecycle states
   - Methods like `isNew()`, `isDirty()`, `isClean()`, `isDeleted()` query state

### 4. **Strategy Pattern**
   - `IValidationRule` interface allows pluggable validation rules
   - Multiple rules can be composed in `UIMEntityValidator`

### 5. **Factory Pattern**
   - Implicit factories for creating specialized rules and validators

### 6. **Template Method Pattern**
   - `UIMEntityManager` methods follow consistent lifecycle patterns
   - Validation, event dispatching, and persistence steps are templated

## Module Structure

```
uim.entities
├── uim.entities.entity          # Core entity implementation
├── uim.entities.collection      # Collection management
├── uim.entities.validator       # Validation rules and validators
├── uim.entities.manager         # Entity lifecycle coordinator
├── uim.entities.events          # Entity-specific events
├── uim.entities.attributes      # Entity attribute handling
├── uim.entities.annotated       # UDA-based entity support
├── uim.entities.interfaces      # Interface contracts
│   ├── entity
│   ├── collection
│   └── repository
├── uim.entities.helpers         # Utility functions
└── uim.entities.package         # Module aggregation
```

## Dependencies

```
External Dependencies:
├── uim-core      (UIMObject, UUID, Clock)
├── uim-oop       (Object-oriented patterns)
└── uim-events    (Event system, UIMEvent, EventDispatcher)

Internal Dependencies:
├── Validators depend on: Entity interfaces
├── Manager depends on: Repository, Validator, EventDispatcher
└── Events depend on: Entity interfaces, UIMEvent
```

## Usage Patterns

### Creating and Managing Entities

```d
// Create manager with repository and validator
auto manager = new UIMEntityManager(repository);
manager.validator(validator);

// Create entity - fires BeforeCreate, Validate, AfterCreate events
auto entity = manager.create(new UIMEntity("john_doe"));

// Update entity - fires BeforeUpdate, Validate, AfterUpdate events
entity.setAttribute("email", "john@example.com");
manager.update(entity);

// Delete entity - fires BeforeDelete, AfterDelete events
manager.delete(entity);

// Listen to events
manager.eventDispatcher().on("entity.afterCreate", (IEvent event) {
    auto createEvent = cast(EntityAfterCreateEvent)event;
    writeln("Entity created: ", createEvent.entity.name());
});
```

## Thread Safety

Current implementation is `@safe` but not thread-safe. For multi-threaded environments:
- Synchronize access to collections
- Use thread-safe repositories
- Implement locking in validators if needed

## Performance Considerations

1. **Collection**: O(1) lookup by UUID, O(n) by name or attribute
2. **Validation**: O(n) where n is number of validation rules
3. **Event Dispatching**: O(m) where m is number of listeners
4. **State Tracking**: Minimal overhead with enum-based states
