/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module yaml.examples.example;

import uim.core;
import dyaml;
import std.stdio;

void main() {
  writeln("=== UIM YAML Module Examples ===\n");
  
  // Example 1: Parse YAML from string
  writeln("1. Parsing YAML from string:");
  string yamlStr = `
name: John Doe
age: 30
email: john@example.com
skills:
  - D programming
  - YAML
  - JSON
`;
  
  auto node1 = parseYaml(yamlStr);
  writeln("Name: ", getYamlValue(node1, "name").as!string);
  writeln("Age: ", getYamlValue(node1, "age").as!int);
  writeln("Email: ", getYamlValue(node1, "email").as!string);
  writeln();
  
  // Example 2: Create YAML from data
  writeln("2. Creating YAML from data:");
  auto data = [
    "database": "postgresql",
    "host": "localhost",
    "port": "5432"
  ];
  auto node2 = createYaml(data);
  writeln("Created YAML:");
  writeln(yamlToString(node2));
  
  // Example 3: Check YAML properties
  writeln("3. Checking YAML properties:");
  writeln("Is valid YAML? ", isValidYaml(yamlStr));
  writeln("Has 'name' key? ", hasYamlKey(node1, "name"));
  writeln("Has 'address' key? ", hasYamlKey(node1, "address"));
  writeln("Is 'skills' a sequence? ", isYamlSequence(getYamlValue(node1, "skills")));
  writeln();
  
  // Example 4: Get values with defaults
  writeln("4. Getting values with defaults:");
  writeln("Country: ", getYamlValueOr(node1, "country", "Unknown"));
  writeln("City: ", getYamlValueOr(node1, "city", "Not specified"));
  writeln();
  
  // Example 5: Convert YAML to JSON
  writeln("5. Converting YAML to JSON:");
  string jsonStr = yamlToJsonString(node1);
  writeln(jsonStr);
  writeln();
  
  // Example 6: Work with sequences
  writeln("6. Working with sequences:");
  string[] languages = ["D", "Rust", "Go", "Python"];
  auto langNode = createYaml(languages);
  writeln("Languages YAML:");
  writeln(yamlToString(langNode));
  
  // Example 7: Get all keys and values
  writeln("7. Getting all keys and values:");
  writeln("Keys: ", getYamlKeys(node1));
  writeln("Number of top-level items: ", getYamlLength(node1));
  writeln();
  
  // Example 8: Nested value access
  writeln("8. Nested value access:");
  string nestedYaml = `
server:
  host: localhost
  port: 8080
  ssl:
    enabled: true
    cert: /path/to/cert
`;
  auto nestedNode = parseYaml(nestedYaml);
  auto sslEnabled = getYamlValueByPath(nestedNode, ["server", "ssl", "enabled"]);
  if (!sslEnabled.isNull) {
    writeln("SSL Enabled: ", sslEnabled.as!bool);
  }
  writeln();
  
  // Example 9: Create complex YAML structures
  writeln("9. Creating complex YAML structures:");
  auto emptyMapping = createEmptyYamlMapping();
  writeln("Empty mapping is empty? ", isYamlEmpty(emptyMapping));
  
  auto emptySequence = createEmptyYamlSequence();
  writeln("Empty sequence is empty? ", isYamlEmpty(emptySequence));
  writeln();
  
  // Example 10: Parse multiple YAML documents
  writeln("10. Parsing multiple YAML documents:");
  string multiDoc = `---
document: 1
type: config
---
document: 2
type: data
`;
  auto docs = parseYamlDocuments(multiDoc);
  writeln("Number of documents: ", docs.length);
  foreach (i, doc; docs) {
    writeln("Document ", i + 1, " type: ", getYamlValue(doc, "type").as!string);
  }
  
  writeln("\n=== Examples completed successfully! ===");
}
