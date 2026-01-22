/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.factory;

import uim.oop;

mixin(ShowModule!());

@safe:

/** 
  * Factory class for creating instances of `IFormatter`.
  *
  * This factory provides methods to create formatters based on the provided type.
  */
class DFormatterFactory : UIMFactory!(string, IFormatter) {
  this() {
    // Default constructor
    super();
  }

  this(V delegate() @safe creator) { // Constructor with default creator
    super(creator);
  }
}
/// 
unittest {
  // Test with empty factory
  auto emptyFactory = new DFormatterFactory();
  assert(emptyFactory.isEmpty);

  // Test with single formatter creation
  auto singleFormatter = emptyFactory.create("Single");
  assert(singleFormatter !is null);
  assert(singleFormatter.name == "Single");

  // Test with multiple formatter creations
  auto multiFormatter1 = emptyFactory.create("First");
  auto multiFormatter2 = emptyFactory.create("Second");
  assert(multiFormatter1 !is null && multiFormatter2 !is null);
  assert(multiFormatter1.name == "First");
  assert(multiFormatter2.name == "Second");
}

unittest {
  // Test that DFormatterFactory can be instantiated
  auto factory = new DFormatterFactory();

}

unittest {
  // Test that DFormatterFactory can be instantiated
  auto factory = new DFormatterFactory();
  assert(factory !is null, "DFormatterFactory instance should not be null");
}
