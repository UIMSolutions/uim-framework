# Library 📚 uim-jsons

Updated on 1. February 2026

[![uim-jsons](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-jsons.yml/badge.svg)](https://github.com/UIMSolutions/uim-framework/actions/workflows/uim-jsons.yml) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

A Json serialization and manipulation library for the UIM framework, built with D language and vibe.d.

## Features

- Fast Json parsing and serialization
- Support for D structs, classes, arrays, and associative arrays
- Type-safe access to Json values
- Customizable serialization formats
- Integration with UIM framework data sources and entities
- Error handling for malformed Json
- Extensible via interfaces for custom types

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-framework:jsons" version="~>1.0.0"
```

Or to your `dub.json`:

```json
"dependencies": {
    "uim-framework:framework:jsons": "~>1.0.0"
}
```

## Quick Start

```d
import uim.jsons;

// Parse Json string
auto doc = parseJson(`{"name": "Alice", "age": 30}`);
string name = doc["name"].get!string;
int age = doc["age"].get!int;

// Serialize D struct to Json
struct User { string name; int age; }
User user = User("Bob", 25);
auto jsonStr = toJson(user);

// Manipulate Json
if (doc.containsKey("name")) {
    doc["name"] = "Charlie";
}
```

## Usage Examples

### Working with Arrays

```d
auto arr = parseJson(`[1, 2, 3, 4]`);
foreach (val; arr) {
    writeln(val.get!int);
}
```

### Error Handling

```d
try {
    auto doc = parseJson(`{"invalid": }`);
} catch (JsonParseException e) {
    writeln("Malformed Json: ", e.msg);
}
```

## Architecture

- **Interfaces**: For extensible serialization and parsing
- **Classes/Structs**: For Json documents, values, and errors
- **Integration**: Works with UIM entities, datasources, and services

## License

Apache License 2.0

## Author

Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)

Copyright © 2018-2026
