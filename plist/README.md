# UIM Property List (plist) Library

Property List library for the UIM framework providing comprehensive support for working with property lists in various formats.

## Overview

Property lists (plists) are data structures used to store configuration data and settings in a hierarchical key-value format. This library provides:

- Property list data structure with type-safe value storage
- Support for various data types (string, number, boolean, array, dictionary, date, data)
- XML plist format support (Apple's traditional format)
- JSON format support for modern applications
- Binary plist format (planned)
- Reading and writing property lists
- Type-safe value access with conversion utilities
- Validation and error handling

## Features

- **Multiple Data Types**: String, Integer, Float, Boolean, Array, Dictionary, Date, Data
- **Format Support**: XML plist, JSON (binary planned)
- **Type Safety**: Strong typing with automatic conversions
- **Nested Structures**: Support for nested arrays and dictionaries
- **Serialization**: Convert to/from XML and JSON
- **Validation**: Built-in validation for structure and types
- **Error Handling**: Comprehensive exception handling

## Usage

### Basic Property List

```d
import uim.plist;

// Create a property list
auto plist = new PropertyList();
plist.set("name", "John Doe");
plist.set("age", 30);
plist.set("active", true);

// Access values
string name = plist.getString("name");
int age = plist.getInt("age");
bool active = plist.getBool("active");
```

### Working with Arrays

```d
auto plist = new PropertyList();

// Set array values
plist.set("colors", ["red", "green", "blue"]);

// Get array
auto colors = plist.getArray("colors");
```

### Working with Dictionaries

```d
auto plist = new PropertyList();

// Create nested dictionary
PlistValue[string] userInfo;
userInfo["name"] = PlistValue("Alice");
userInfo["email"] = PlistValue("alice@example.com");

plist.set("user", userInfo);

// Access nested values
auto user = plist.getDict("user");
string email = user["email"].asString();
```

### XML Format

```d
import uim.plist;

// Write to XML
auto plist = new PropertyList();
plist.set("version", "1.0");
plist.set("name", "MyApp");

string xmlContent = plist.toXML();

// Read from XML
auto loaded = PropertyList.fromXML(xmlContent);
```

### JSON Format

```d
// Convert to JSON
auto plist = new PropertyList();
plist.set("key", "value");

string jsonContent = plist.toJSON();

// Parse from JSON
auto loaded = PropertyList.fromJSON(jsonContent);
```

## API Reference

### PropertyList Class

Main class for working with property lists.

#### Methods

- `set(string key, T value)` - Set a value
- `get(string key)` - Get a value as PlistValue
- `getString(string key)` - Get string value
- `getInt(string key)` - Get integer value
- `getFloat(string key)` - Get float value
- `getBool(string key)` - Get boolean value
- `getArray(string key)` - Get array value
- `getDict(string key)` - Get dictionary value
- `has(string key)` - Check if key exists
- `remove(string key)` - Remove a key
- `keys()` - Get all keys
- `toXML()` - Export to XML format
- `toJSON()` - Export to JSON format
- `static fromXML(string xml)` - Parse from XML
- `static fromJSON(string json)` - Parse from JSON

### PlistValue Struct

Container for property list values with type information.

#### Properties

- `type` - Value type (String, Integer, Float, Boolean, Array, Dict, Date, Data)
- `asString()` - Convert to string
- `asInt()` - Convert to integer
- `asFloat()` - Convert to float
- `asBool()` - Convert to boolean
- `asArray()` - Convert to array
- `asDict()` - Convert to dictionary

## Examples

See the `examples/` directory for complete examples:

- `examples/basic_plist.d` - Basic property list operations
- `examples/xml_plist.d` - XML format handling
- `examples/nested_plist.d` - Working with nested structures

## Testing

Run the test suite:

```bash
dub test
```

## License

Apache-2.0 - See LICENSE.txt file for details

## Author

Ozan Nurettin Süel (UIManufaktur)
