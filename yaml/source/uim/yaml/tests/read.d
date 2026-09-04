module uim.yaml.tests.read;

import uim.core;
import dyaml;

unittest {
    writeln("\nTest reading YAML");

    // Load and parse the YAML file
    Node root = Loader.fromFile("tests/config.yaml").load();

    // Access scalar values
    string name = root["name"].as!string;
    int port = root["port"].as!int;
    bool debugMode = root["debug"].as!bool;

    writeln("Server Name: ", name);
    writeln("Port: ", port);
    writeln("Debug: ", debugMode);

    // Iterate over a YAML sequence (list)
    if ("tags" in root)
    {
        foreach (Node tag; root["tags"])
        {
            writeln("Tag: ", tag.as!string);
        }
    }
}