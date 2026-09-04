module uim.yaml.tests.parse;

import std.stdio : writeln;
import dyaml;

unittest {
    writeln("\nTest parsing YAML");

    string yamlData = `
name: "My App"
version: 1.2
features:
  - fast
  - safe
`;

    // Parse YAML directly from a string
    Node root = Loader.fromString(yamlData).load();

    // Access properties
    string name = root["name"].as!string;
    double ver = root["version"].as!double;

    writeln("App: ", name, " v", ver);

    foreach (Node feature; root["features"]) {
        writeln("Feature: ", feature.as!string);
    }
}
