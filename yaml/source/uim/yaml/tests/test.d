/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.yaml.tests.test;

import uim.yaml;
import dyaml;

@safe:

// Test parsing YAML strings
unittest {
  string yamlStr = `
name: John Doe
age: 30
`;
  
  auto node = parseYaml(yamlStr);
  assert(node.isMapping);
  assert(hasYamlKey(node, "name"));
  assert(getYamlValue(node, "name").as!string == "John Doe");
  assert(getYamlValue(node, "age").as!int == 30);
}

// Test creating YAML from associative array
unittest {
  auto data = [
    "host": "localhost",
    "port": "8080"
  ];
  
  auto node = createYaml(data);
  assert(node.isMapping);
  assert(hasYamlKey(node, "host"));
  assert(getYamlValue(node, "host").as!string == "localhost");
}

// Test creating YAML from array
unittest {
  string[] items = ["apple", "banana", "orange"];
  auto node = createYaml(items);
  
  assert(node.isSequence);
  assert(getYamlLength(node) == 3);
  assert(getYamlValueAt(node, 0).as!string == "apple");
  assert(getYamlValueAt(node, 1).as!string == "banana");
}

// Test YAML validation
unittest {
  assert(isValidYaml("key: value"));
  assert(isValidYaml("- item1\n- item2"));
  assert(!isValidYaml("invalid: [yaml"));
}

// Test YAML type checking
unittest {
  auto scalarNode = createYamlScalar("test");
  assert(isYamlScalar(scalarNode));
  assert(!isYamlSequence(scalarNode));
  assert(!isYamlMapping(scalarNode));
  
  auto emptyMapping = createEmptyYamlMapping();
  assert(isYamlMapping(emptyMapping));
  assert(isYamlEmpty(emptyMapping));
  
  auto emptySequence = createEmptyYamlSequence();
  assert(isYamlSequence(emptySequence));
  assert(isYamlEmpty(emptySequence));
}

// Test getting values with defaults
unittest {
  string yamlStr = "name: Alice";
  auto node = parseYaml(yamlStr);
  
  assert(getYamlValueOr(node, "name", "Unknown") == "Alice");
  assert(getYamlValueOr(node, "age", 25) == 25);
  assert(getYamlValueOr(node, "city", "Default") == "Default");
}

// Test nested path access
unittest {
  string yamlStr = `
server:
  host: localhost
  port: 8080
  ssl:
    enabled: true
`;
  
  auto node = parseYaml(yamlStr);
  auto sslEnabled = getYamlValueByPath(node, ["server", "ssl", "enabled"]);
  assert(!sslEnabled.isNull);
  assert(sslEnabled.as!bool == true);
  
  auto port = getYamlValueByPath(node, ["server", "port"]);
  assert(port.as!int == 8080);
}

// Test getting all keys and values
unittest {
  string yamlStr = `
a: 1
b: 2
c: 3
`;
  
  auto node = parseYaml(yamlStr);
  auto keys = getYamlKeys(node);
  assert(keys.length == 3);
  
  auto values = getYamlValues(node);
  assert(values.length == 3);
}

// Test YAML to JSON conversion
unittest {
  string yamlStr = `
name: Test
value: 42
`;
  
  auto node = parseYaml(yamlStr);
  string jsonStr = yamlToJsonString(node);
  assert(jsonStr.length > 0);
}

// Test YAML to string map
unittest {
  string yamlStr = `
key1: value1
key2: value2
`;
  
  auto node = parseYaml(yamlStr);
  auto map = yamlToStringMap(node);
  assert(map.length == 2);
  assert(map["key1"] == "value1");
  assert(map["key2"] == "value2");
}

// Test YAML sequence to array
unittest {
  string yamlStr = `
- first
- second
- third
`;
  
  auto node = parseYaml(yamlStr);
  auto arr = yamlToArray(node);
  assert(arr.length == 3);
  assert(arr[0] == "first");
  assert(arr[1] == "second");
  assert(arr[2] == "third");
}

// Test multiple YAML documents
unittest {
  string multiDoc = `---
doc: 1
---
doc: 2
`;
  
  auto docs = parseYamlDocuments(multiDoc);
  assert(docs.length == 2);
  assert(getYamlValue(docs[0], "doc").as!int == 1);
  assert(getYamlValue(docs[1], "doc").as!int == 2);
}

// Test type conversion checks
unittest {
  string yamlStr = `
name: Alice
age: 30
active: true
`;
  
  auto node = parseYaml(yamlStr);
  auto nameNode = getYamlValue(node, "name");
  assert(canConvertYamlTo!string(nameNode));
  
  auto ageNode = getYamlValue(node, "age");
  assert(canConvertYamlTo!int(ageNode));
  assert(canConvertYamlTo!long(ageNode));
  
  auto activeNode = getYamlValue(node, "active");
  assert(canConvertYamlTo!bool(activeNode));
}

mixin(ShowModule!());
