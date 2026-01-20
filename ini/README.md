# UIM-INI - INI File Parser and Writer

**Version**: 1.0.0  
**Author**: Ozan Nurettin Süel (aka UIManufaktur)  
**License**: Apache 2.0  
**Language**: D

## Overview

UIM-INI is a comprehensive INI file parser and writer library for the D programming language. It provides a clean, type-safe API for reading, writing, and manipulating INI configuration files.

## Features

- **Full INI Support**: Parse and write standard INI files
- **Section Management**: Organize properties into sections
- **Global Properties**: Support for properties outside sections
- **Type Conversions**: Automatic conversion to int, long, double, bool, arrays
- **Comments**: Support for comment lines and inline comments
- **Fluent API**: Easy-to-use chainable methods
- **Error Handling**: Detailed exceptions with line numbers
- **File I/O**: Direct file reading and writing
- **Flexible**: Configurable parsing and writing options

## Installation

Add to your `dub.sdl`:

```sdl
dependency "uim-ini" path="../ini"
```

## INI File Format

INI files have a simple structure:

```ini
; This is a comment
global_property=value

[Section1]
key1=value1
key2=value2

[Section2]
key3=value3
```

## Usage Examples

### Parsing INI Content

```d
import uim.ini;

auto content = `
[Database]
host=localhost
port=5432
user=admin
password=secret

[Server]
host=0.0.0.0
port=8080
debug=true
timeout=30.5
`;

// Parse from string
auto doc = parseINI(content);

// Access values
string dbHost = doc.get("Database", "host");  // "localhost"
int dbPort = doc.getInt("Database", "port");  // 5432
bool debug = doc.getBool("Server", "debug");  // true
double timeout = doc.getDouble("Server", "timeout");  // 30.5
```

### Reading INI Files

```d
import uim.ini;

// Read from file
auto doc = parseINIFile("config.ini");

// Access sections
auto dbSection = doc.getSection("Database");
string host = dbSection.get("host");
int port = dbSection.getInt("port");

// Check if section exists
if (doc.hasSection("Cache")) {
    auto cacheSection = doc.getSection("Cache");
    // ...
}
```

### Creating INI Documents

```d
import uim.ini;

auto doc = new DINIDocument();

// Add global properties
doc.setGlobal("version", "1.0");
doc.setGlobal("app_name", "MyApp");

// Add sections and properties
doc.set("Database", "host", "localhost");
doc.set("Database", "port", "5432");
doc.set("Database", "user", "admin");

// Using section objects
auto serverSection = doc.section("Server");
serverSection.set("host", "0.0.0.0");
serverSection.set("port", "8080");
serverSection.set("debug", "true");

// Write to string
string iniContent = writeINI(doc);

// Write to file
writeINIFile(doc, "output.ini");
```

### Working with Sections

```d
import uim.ini;

auto section = new DINISection("Database");

// Set properties
section.set("host", "localhost");
section.set("port", "5432");
section.set("enabled", "true");

// Get typed values
string host = section.get("host");
int port = section.getInt("port");
bool enabled = section.getBool("enabled");

// Check if property exists
if (section.has("user")) {
    string user = section.get("user");
}

// Get all keys
string[] keys = section.keys();

// Get property count
size_t count = section.count();

// Remove property
section.remove("password");
```

### Type Conversions

```d
import uim.ini;

auto section = new DINISection("Settings");

// Integer values
section.set("count", "42");
int count = section.getInt("count");  // 42
long bigCount = section.getLong("count");  // 42L

// Floating point values
section.set("ratio", "3.14");
double ratio = section.getDouble("ratio");  // 3.14

// Boolean values
section.set("enabled", "true");
bool enabled = section.getBool("enabled");  // true

// Recognizes: true, false, yes, no, 1, 0, on, off (case-insensitive)
section.set("active", "YES");
bool active = section.getBool("active");  // true

// Array values (comma-separated)
section.set("servers", "server1, server2, server3");
string[] servers = section.getArray("servers");
// ["server1", "server2", "server3"]
```

### Default Values

```d
import uim.ini;

auto doc = parseINI("[Database]\nhost=localhost");

// Use default values when key doesn't exist
string host = doc.get("Database", "host", "127.0.0.1");  // "localhost"
string user = doc.get("Database", "user", "root");       // "root" (default)
int port = doc.getInt("Database", "port", 3306);         // 3306 (default)
bool ssl = doc.getBool("Database", "ssl", false);        // false (default)
```

### Comments

```d
import uim.ini;

auto doc = new DINIDocument();

// Add header comment
doc.header("Application Configuration");

// Create section with comment
auto section = doc.section("Database");
section.comment("Database connection settings");

// Add property with comment
section.set("host", "localhost", "Database server address");
section.set("port", "5432", "Database server port");

// Write with comments
auto writer = new DINIWriter();
writer.writeComments(true);  // Include comments (default)
string content = writer.write(doc);

/* Output:
; Application Configuration

; Database connection settings
[Database]
; Database server address
host=localhost
; Database server port
port=5432
*/
```

### Custom Parser Configuration

```d
import uim.ini;

auto parser = new DINIParser();

// Configure parser
parser.allowComments(true);            // Enable comment parsing (default: true)
parser.allowGlobalProperties(true);    // Allow properties outside sections (default: true)
parser.commentChar(";");              // Set comment character (default: ";")

// Parse with custom settings
auto doc = parser.parse(content);
```

### Custom Writer Configuration

```d
import uim.ini;

auto writer = new DINIWriter();

// Configure writer
writer.writeComments(true);   // Include comments (default: true)
writer.addSpacing(true);      // Add blank lines between sections (default: true)
writer.commentChar(";");      // Set comment character (default: ";")

// Write with custom settings
string content = writer.write(doc);
```

### Error Handling

```d
import uim.ini;

try {
    auto doc = parseINIFile("config.ini");
    
    // Access section (throws if not found)
    auto section = doc.getSection("Database");
    
    // Access property (throws if not found)
    auto prop = section.getProperty("host");
    
} catch (SectionNotFoundException e) {
    writeln("Section not found: ", e.sectionName);
} catch (PropertyNotFoundException e) {
    writeln("Property not found: ", e.propertyName);
} catch (INIParseException e) {
    writeln("Parse error at line ", e.lineNumber, ": ", e.msg);
} catch (INIException e) {
    writeln("INI error: ", e.msg);
}
```

### Iterating Over Sections and Properties

```d
import uim.ini;

auto doc = parseINIFile("config.ini");

// Iterate over all sections
foreach (sectionName; doc.sectionNames()) {
    auto section = doc.getSection(sectionName);
    writeln("Section: ", sectionName);
    
    // Iterate over properties in section
    foreach (key; section.keys()) {
        string value = section.get(key);
        writeln("  ", key, " = ", value);
    }
}

// Or directly iterate over section objects
foreach (section; doc.sections()) {
    writeln("Section: ", section.name);
    
    foreach (prop; section.properties()) {
        writeln("  ", prop.key, " = ", prop.value);
    }
}
```

### Complete Example: Configuration Manager

```d
import uim.ini;
import std.stdio;

class ConfigManager {
    private DINIDocument doc;
    
    this(string filePath) {
        doc = parseINIFile(filePath);
    }
    
    string getDatabaseHost() {
        return doc.get("Database", "host", "localhost");
    }
    
    int getDatabasePort() {
        return doc.getInt("Database", "port", 5432);
    }
    
    bool isDebugMode() {
        return doc.getBool("Server", "debug", false);
    }
    
    string[] getAllowedHosts() {
        return doc.getSection("Server").getArray("allowed_hosts");
    }
    
    void save(string filePath) {
        writeINIFile(doc, filePath);
    }
}

void main() {
    auto config = new ConfigManager("app.ini");
    
    writeln("Database Host: ", config.getDatabaseHost());
    writeln("Database Port: ", config.getDatabasePort());
    writeln("Debug Mode: ", config.isDebugMode());
    writeln("Allowed Hosts: ", config.getAllowedHosts());
}
```

### Example: Building Configuration Programmatically

```d
import uim.ini;

void createDefaultConfig() {
    auto doc = new DINIDocument();
    doc.header("Application Configuration - Generated");
    
    // Database settings
    auto db = doc.section("Database");
    db.comment("Database connection settings");
    db.set("host", "localhost");
    db.set("port", "5432");
    db.set("database", "myapp");
    db.set("user", "admin");
    db.set("pool_size", "10");
    
    // Server settings
    auto server = doc.section("Server");
    server.comment("Web server configuration");
    server.set("host", "0.0.0.0");
    server.set("port", "8080");
    server.set("debug", "false");
    server.set("workers", "4");
    
    // Cache settings
    auto cache = doc.section("Cache");
    cache.comment("Caching configuration");
    cache.set("enabled", "true");
    cache.set("ttl", "3600");
    cache.set("backend", "redis");
    
    // Logging
    auto logging = doc.section("Logging");
    logging.set("level", "INFO");
    logging.set("file", "/var/log/myapp.log");
    logging.set("max_size", "10485760");
    
    // Save to file
    writeINIFile(doc, "config.ini");
}
```

### Working with Global Properties

```d
import uim.ini;

auto content = `
version=1.0.0
app_name=MyApplication

[Database]
host=localhost
`;

auto doc = parseINI(content);

// Access global properties
string version = doc.getGlobal("version");  // "1.0.0"
string appName = doc.getGlobal("app_name"); // "MyApplication"

// Check if global property exists
if (doc.hasGlobal("version")) {
    writeln("Version: ", doc.getGlobal("version"));
}

// Get all global properties
foreach (prop; doc.globalProperties()) {
    writeln(prop.key, " = ", prop.value);
}
```

## API Reference

### DINIDocument
- `section(string name)` - Get or create section
- `getSection(string name)` - Get section (throws if not found)
- `hasSection(string name)` - Check if section exists
- `removeSection(string name)` - Remove section
- `sectionNames()` - Get all section names
- `sections()` - Get all section objects
- `setGlobal(string, string)` - Set global property
- `getGlobal(string)` - Get global property
- `get/set(string section, string key)` - Get/set value in section
- `getInt/getBool/getDouble(...)` - Get typed values

### DINISection
- `set(string key, string value)` - Set property
- `get(string key)` - Get property value
- `getProperty(string key)` - Get property object
- `has(string key)` - Check if property exists
- `remove(string key)` - Remove property
- `keys()` - Get all property keys
- `properties()` - Get all property objects
- `getInt/getLong/getDouble/getBool/getArray(...)` - Get typed values

### DINIProperty
- `key()` / `value()` / `comment()` - Getters
- `asString()` / `asInt()` / `asLong()` / `asDouble()` / `asBool()` / `asArray()` - Type conversions

### DINIParser
- `parse(string content)` - Parse INI from string
- `parseFile(string filePath)` - Parse INI from file
- Configuration: `allowComments()`, `allowGlobalProperties()`, `commentChar()`

### DINIWriter
- `write(DINIDocument)` - Write INI to string
- `writeFile(DINIDocument, string)` - Write INI to file
- Configuration: `writeComments()`, `addSpacing()`, `commentChar()`

## Supported Value Types

- **String**: Any text value
- **Integer**: `int`, `long`
- **Float**: `double`
- **Boolean**: `true`, `false`, `yes`, `no`, `1`, `0`, `on`, `off` (case-insensitive)
- **Array**: Comma-separated values (customizable separator)

## Testing

```bash
cd ini
dub test
```

## License

Copyright © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur)

Licensed under the Apache License, Version 2.0.

## Dependencies

- uim-oop - Object-oriented patterns
- uim-core - Core utilities

## Resources

- [INI File Format](https://en.wikipedia.org/wiki/INI_file)
- [Configuration File Formats](https://en.wikipedia.org/wiki/Configuration_file)
