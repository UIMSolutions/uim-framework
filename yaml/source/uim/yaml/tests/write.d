module uim.yaml.tests.write;

import uim.core;
import dyaml;

auto dumper()
{
    auto dumper = Dumper();
    return dumper;
}

unittest {
    writeln("\nTest writing YAML");

    // Create a YAML structure using D primitives and Associative Arrays
    Node root = Node([
        "title": Node("Dlang App"),
        "version": Node(1.0),
        "features": Node(["fast", "safe", "expressive"])
    ]);

    // 3. Pass the appender's output range to dumper
    auto stream = appender!(string)();
    
    // Explicit Dumper instantiation
    dumper().dump(stream, root);
    writeln(stream.data);
}
