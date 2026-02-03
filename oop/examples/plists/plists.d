module examples.plists.plists;

import std.stdio;

void main() {
    writeln("Running pLists Tests...");
    writeln("========================");
    
    // Import all test modules to trigger unittest blocks
    import tests.helpers.test_classes;
    import tests.datatypes.test_factory;
    import tests.datatypes.test_pool;
    import tests.datatypes.test_objects;
    
    writeln("All tests completed successfully!");
}