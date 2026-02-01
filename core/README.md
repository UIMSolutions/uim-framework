# Library 📚 uim-core

Updated on 1. February 2026

[![uim-core](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-core.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-core.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Overview

**uim-core** is the foundational library of the UIM framework, providing essential utilities and building blocks for D language applications. It serves as the base dependency for all other UIM libraries and includes comprehensive support for data manipulation, containers, type handling, and more.

## Features

### 🗂️ Containers
- **Sequential Containers**: Arrays and lists with extended functionality
- **Associative Containers**: Enhanced associative array operations
- **Unordered Containers**: Efficient unordered data structures

### 📊 Data Types
Comprehensive utilities for working with various data types:
- **Strings**: Manipulation (camelize, pluralize, singularize, humanize, underscore, etc.)
- **Booleans**: Boolean operations and conversions
- **JSON/BSON**: JSON and BSON data handling
- **DateTime**: Date and time utilities
- **Files**: File operations and comparisons
- **UUIDs**: UUID generation and handling
- **Numbers**: Long, double, and other numeric types

### 🔧 Core Utilities
- **Constants**: Framework-wide constants for filesystem operations, sorting, etc.
- **Enumerations**: Type-safe enumeration support
- **Mixins**: Reusable code patterns (properties, versioning)
- **Paths**: Path manipulation and handling
- **Logging**: Built-in logging capabilities
- **Tests**: Testing utilities and helpers

### 📦 Standard Library Integration
Re-exports commonly used D standard library modules including:
- Algorithm, array, and range operations
- String and regex processing
- File I/O and path handling
- DateTime and UUID support
- Encoding and digest functions
- And many more...

### 🌐 External Dependencies
- **vibe-d**: High-performance asynchronous I/O
- **colored**: Terminal color output support
- **console-colors**: Enhanced console coloring

## Installation

Add `uim-core` as a dependency to your `dub.json` or `dub.sdl`:

### dub.json
```json
{
  "dependencies": {
    "uim-framework:core": "*"
  }
}
```

### dub.sdl
```sdl
dependency "uim-core" version="*"
```

## Usage

```d
import uim.core;

void main() {
  // String manipulation
  auto className = "user_accounts".classify; // "UserAccount"
  auto tableName = "UserAccount".tableize;   // "user_accounts"
  auto camelCase = "hello_world".camelize;   // "helloWorld"
  
  // Pluralization
  auto plural = "person".pluralize;          // "people"
  auto single = "children".singularize;      // "child"
  
  // Work with containers, data types, and more...
}
```

## Build Configurations

The library provides several build configurations for different use cases:

- **default**: Standard library build
- **modules**: Build with module visibility (`show_module`)
- **tests**: Build with test visibility (`show_module`, `show_test`)
- **calls**: Build with function call tracing (`show_module`, `show_test`, `show_function`)
- **verbose**: Verbose build with all debug information

### Running Tests

```bash
dub test
```

### Building with specific configuration

```bash
dub build --config=modules
dub build --config=verbose
```

## Documentation

- **Homepage**: [https://www.sueel.de/uim/core](https://www.sueel.de/uim/core)
- **Source Code**: [GitHub Repository](https://github.com/UIMSolutions/uim-framework/tree/main/core)

## Module Structure

```
uim.core
├── constants      # Framework constants
├── containers     # Container data structures
│   ├── associative
│   ├── sequential
│   └── unordered
├── datatypes      # Data type utilities
│   ├── booleans
│   ├── bsons
│   ├── classes
│   ├── datetimes
│   ├── doubles
│   ├── files
│   ├── jsons
│   ├── longs
│   ├── strings
│   └── uuids
├── enumerations   # Enumeration support
├── logging        # Logging functionality
├── mixins         # Reusable mixins
├── paths          # Path handling
└── tests          # Test utilities
```

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](../LICENSE) file for details.

## Copyright

Copyright © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)

## Author

Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
