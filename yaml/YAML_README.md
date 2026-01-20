# UIM YAML Module

This module provides comprehensive YAML handling functionality for the UIM framework using the D programming language and the dyaml library.

## Features

The YAML module is organized into several sub-modules:

### 1. Parse Module (`uim.core.datatypes.yamls.parse`)

Functions for parsing YAML strings and files:

- **`parseYaml(string yamlString)`** - Parse a YAML string into a Node
- **`parseYamls(string[] yamlStrings)`** - Parse multiple YAML strings
- **`parseYamlFile(string filePath)`** - Parse a YAML file
- **`parseYamlDocuments(string yamlString)`** - Parse multiple YAML documents from a single string

### 2. Create Module (`uim.core.datatypes.yamls.create`)

Functions for creating YAML structures:

- **`createYaml(K, V)(K key, V value)`** - Create a YAML Node from a key-value pair
- **`createYaml(V)(V[string] data)`** - Create from an associative array
- **`createYaml(T)(T[] data)`** - Create from an array
- **`createEmptyYamlMapping()`** - Create an empty YAML mapping
- **`createEmptyYamlSequence()`** - Create an empty YAML sequence
- **`createYamlScalar(T)(T value)`** - Create a YAML scalar node

### 3. Convert Module (`uim.core.datatypes.yamls.convert`)

Functions for converting YAML to other formats:

- **`yamlToString(Node node)`** - Convert YAML Node to string
- **`yamlToJsonString(Node node)`** - Convert YAML to JSON string
- **`yamlToStringMap(Node node)`** - Convert to associative array
- **`yamlToArray(Node node)`** - Convert sequence to array
- **`yamlTo(T)(Node node)`** - Convert to specific type

### 4. Check Module (`uim.core.datatypes.yamls.check`)

Functions for checking YAML properties:

- **`isYamlScalar(Node node)`** - Check if node is a scalar
- **`isYamlSequence(Node node)`** - Check if node is a sequence
- **`isYamlMapping(Node node)`** - Check if node is a mapping
- **`isYamlNull(Node node)`** - Check if node is null
- **`isValidYaml(string yamlString)`** - Validate YAML string
- **`hasYamlKey(Node node, string key)`** - Check if key exists
- **`canConvertYamlTo(T)(Node node)`** - Check if convertible to type
- **`isYamlEmpty(Node node)`** - Check if node is empty

### 5. Values Module (`uim.core.datatypes.yamls.values`)

Functions for accessing YAML values:

- **`getYamlValue(Node node, string key)`** - Get value by key
- **`getYamlValueOr(T)(Node node, string key, T defaultValue)`** - Get value with default
- **`getYamlValueAt(Node node, size_t index)`** - Get value by index
- **`getYamlKeys(Node node)`** - Get all keys
- **`getYamlValues(Node node)`** - Get all values
- **`getYamlLength(Node node)`** - Get node length
- **`getYamlValueByPath(Node node, string[] path)`** - Get nested value by path

## Usage Examples

### Basic Parsing

```d
import uim.core;
import dyaml;

string yamlStr = `
name: John Doe
age: 30
email: john@example.com
`;

auto node = parseYaml(yamlStr);
writeln("Name: ", getYamlValue(node, "name").as!string);
writeln("Age: ", getYamlValue(node, "age").as!int);
```

### Creating YAML

```d
auto data = [
    "database": "postgresql",
    "host": "localhost",
    "port": "5432"
];

auto yamlNode = createYaml(data);
writeln(yamlToString(yamlNode));
```

### Working with Arrays

```d
string[] languages = ["D", "Rust", "Go", "Python"];
auto langNode = createYaml(languages);
writeln(yamlToString(langNode));
```

### Nested Access

```d
string nestedYaml = `
server:
  host: localhost
  port: 8080
  ssl:
    enabled: true
`;

auto node = parseYaml(nestedYaml);
auto sslEnabled = getYamlValueByPath(node, ["server", "ssl", "enabled"]);
writeln("SSL: ", sslEnabled.as!bool);
```

### Converting to JSON

```d
auto node = parseYaml(yamlString);
string jsonStr = yamlToJsonString(node);
writeln(jsonStr);
```

### Validation

```d
if (isValidYaml(yamlString)) {
    auto node = parseYaml(yamlString);
    if (hasYamlKey(node, "config")) {
        // Process config
    }
}
```

### Safe Value Access

```d
auto node = parseYaml(yamlString);
string country = getYamlValueOr(node, "country", "Unknown");
int timeout = getYamlValueOr(node, "timeout", 30);
```

## Dependencies

- **dyaml** (~>0.10.0) - The D YAML library for parsing and emitting YAML

## Module Location

All YAML modules are located in:
- `/core/source/uim/root/datatypes/yamls/`

## Import

```d
import uim.core.datatypes.yamls;  // Import all YAML functionality
```

Or import specific modules:

```d
import uim.core.datatypes.yamls.parse;
import uim.core.datatypes.yamls.create;
import uim.core.datatypes.yamls.convert;
import uim.core.datatypes.yamls.check;
import uim.core.datatypes.yamls.values;
```

## Thread Safety

All functions are marked as `@safe`, providing memory safety guarantees.

## See Also

- [dyaml documentation](https://github.com/dlang-community/D-YAML)
- [YAML specification](https://yaml.org/spec/)
- UIM JSON module (`uim.core.datatypes.jsons`) for similar JSON functionality
