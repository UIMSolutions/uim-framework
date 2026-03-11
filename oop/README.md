# Library 📚 uim-oop

Updated on 1. February 2026

[![uim-oop](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-oop.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-oop.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

**uim-oop** is a comprehensive object-oriented programming library for D, providing implementations of classic and modern design patterns, helper utilities, and OOP-focused data structures. Built on top of uim-core, it enables developers to write cleaner, more maintainable, and architecturally sound applications using proven design patterns.

## Features

### 🏗️ Design Patterns

Comprehensive implementations of 27+ design patterns, organized by category:

#### Structural Patterns
- **Bridges**: Decouple abstraction from implementation
- **Composites**: Treat individual objects and compositions uniformly
- **Decorators**: Add behavior to objects dynamically
- **Facades**: Provide simplified interfaces to complex subsystems
- **Flyweights**: Share objects efficiently for memory optimization
- **Proxies**: Control access to other objects

#### Behavioral Patterns
- **Chains of Responsibility**: Pass requests along a chain of handlers
- **Commands**: Encapsulate requests as objects
- **Delegates**: Function delegation patterns
- **Interpreters**: Define language grammars and interpret expressions
- **Mediators**: Reduce coupling between communicating objects
- **Mementos**: Capture and restore object state
- **Observers**: Define one-to-many dependencies between objects
- **States**: Alter behavior when internal state changes
- **Strategies**: Define a family of algorithms
- **Visitors**: Add operations to objects without modifying them

#### Creational Patterns
- **Factories**: Create objects without specifying exact classes
- **Prototypes**: Create objects by cloning prototypes
- **Registries**: Central registry for object creation
- **Pools**: Manage reusable object pools for performance
- **DAOs**: Data Access Object pattern for persistence

#### Architectural Patterns
- **MVC**: Model-View-Controller architecture support
- **Repositories**: Abstract data access layer
- **Transfer Objects**: Define data transfer objects
- **Locators**: Service locator pattern

### 🔍 Containers

Enhanced OOP-focused container implementations:
- **List**: Type-safe list container
- **Map**: Key-value mapping
- **Set**: Unique element collection
- **PList**: Persistent list implementation

### 📦 Data Types

Object-oriented data type utilities:
- **Objects**: Base object functionality and utilities
- **Classes**: Class introspection and manipulation helpers

### 🛠️ Helpers

Utility functions for object-oriented programming:
- **Class Helpers**: Class manipulation and inspection utilities
- Additional OOP-specific helpers

### 📝 Formatters

Output formatting and serialization:
- **Formatter**: Base formatter interface
- **Helpers**: Formatting utility functions
- Custom formatting support

### ⚠️ Exceptions

OOP-specific exception handling:
- Custom exception types for better error management

## Installation

Add `uim-oop` as a dependency to your `dub.json` or `dub.sdl`:

### dub.json
```json
{
  "dependencies": {
    "uim-framework:oop": "*"
  }
}
```

### dub.sdl
```sdl
dependency "uim-oop" version="*"
```

## Usage

### Using Design Patterns

```d
import uim.oop;

// Example: Factory Pattern
class ConcreteFactory : IFactory {
  Object create() {
    return new ConcreteProduct();
  }
}

// Example: Observer Pattern
auto observer = new Observer();
auto subject = new Subject();
subject.attach(observer);
subject.notifyObservers();

// Example: Strategy Pattern
auto context = new Context(new ConcreteStrategyA());
context.executeStrategy();
```

### Working with Containers

```d
import uim.oop;

auto list = new List!int();
list.add(1);
list.add(2);
list.add(3);

auto map = new Map!(string, int)();
map.set("key1", 100);
map.set("key2", 200);

auto set = new Set!string();
set.add("item1");
set.add("item2");
```

### Spring-style UDAs

The OOP package includes Spring-inspired UDAs (annotations) in a dedicated module:

```d
import uim.oop.udas;
```

Note: `uim.oop.udas` is imported explicitly to avoid naming collisions with existing MVC symbols (for example `Controller`).

```d
import std.traits : hasUDA;
import uim.oop.udas;

@Service("userService")
class UserService {
  @Autowired(true)
  UserRepository repository;
}

@Controller("users")
class UserController {
  @GetMapping("/users")
  void list() {}
}

static assert(hasComponentAttribute!UserService);
static assert(getComponentName!UserService == "userService");

alias listMethod = __traits(getMember, UserController, "list");
static assert(hasRequestMapping!listMethod);
static assert(getRequestMethod!listMethod == "GET");
static assert(getRequestPath!listMethod == "/users");
```

Available stereotypes and DI-related UDAs include `Component`, `Service`, `Repository`, `Controller`, `Configuration`, `Bean`, `Autowired`, `Inject`, `Qualifier`, `Value`, `Scope`, `Lazy`, `Primary`, `PostConstruct`, `PreDestroy`, `Getter`, `Setter`, `Accessor`, and HTTP mapping UDAs.

## Build Configurations

The library provides several build configurations for different use cases:

- **default**: Standard library build
- **modules**: Build with module visibility (`show_module`)
- **tests**: Build with test visibility (`show_module`, `show_test`)
- **inits**: Build with initialization tracking (`show_module`, `show_init`)
- **calls**: Build with function call tracing (`show_module`, `show_test`, `show_function`)
- **verbose**: Complete debug information (`show_module`, `show_test`, `show_init`, `show_function`)
- **runtests**: Executable test runner

### Running Tests

```bash
dub test
dub run --config=runtests
```

### Building with specific configuration

```bash
dub build --config=modules
dub build --config=verbose
```

## Dependencies

- **uim-framework:core**: Core UIM framework library providing base utilities

## Documentation

- **Homepage**: [https://www.sueel.de](https://www.sueel.de)
- **Source Code**: [GitHub Repository](https://github.com/UIMSolutions/uim-framework/tree/main/oop)

## Module Structure

```
uim.oop
├── containers         # OOP-focused containers
│   ├── list
│   ├── map
│   ├── set
│   └── plist
├── datatypes          # Object-oriented data types
│   └── objects
├── exceptions         # Custom exceptions
├── formatters         # Output formatting
│   ├── formatter
│   ├── interfaces
│   └── helpers
├── helpers            # OOP utilities
│   └── classes
├── patterns           # Design patterns (27+ implementations)
│   ├── bridges
│   ├── chains
│   ├── commands
│   ├── composites
│   ├── daos
│   ├── decorators
│   ├── delegates
│   ├── facades
│   ├── factories
│   ├── flyweights
│   ├── interpreters
│   ├── locators
│   ├── mediators
│   ├── mementos
│   ├── mvc
│   ├── observers
│   ├── pools
│   ├── prototypes
│   ├── proxies
│   ├── registries
│   ├── repositories
│   ├── states
│   ├── strategies
│   ├── transferobjects
│   └── visitors
└── core (re-exported)  # Access to uim.core utilities
```

## Design Pattern Categories

### Creational (6)
Deals with object creation mechanisms

### Structural (6)
Deals with object composition and relationships

### Behavioral (11)
Deals with object interaction and responsibility distribution

### Architectural (4)
Deals with high-level application structure

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](../LICENSE) file for details.

## Copyright

Copyright © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)

## Author

Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
