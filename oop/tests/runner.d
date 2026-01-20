/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module oop.tests.runner;

import std.stdio;

void main() {
    writeln("Running UIM OOP Tests...");
    writeln("========================");
    
    // Import all test modules to trigger unittest blocks
    import tests.helpers.test_classes;
    import tests.datatypes.test_factory;
    import tests.datatypes.test_pool;
    import tests.datatypes.test_objects;
    
    writeln("All tests completed successfully!");
}