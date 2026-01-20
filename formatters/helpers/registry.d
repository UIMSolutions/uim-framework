/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.registry;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

class DFormatterRegistry : DRegistry!IFormatter {
  mixin(RegistryThis!("Formatter"));
}
mixin(RegistryCalls!("Formatter"));

unittest {
  // Create a dummy formatter for testing
  /* class DummyFormatter : IFormatter {
    override string format(string input) {
      return "dummy:" ~ input;
    }
  }

  auto registry = new DFormatterRegistry();

  // Test registration
  auto formatter = new DummyFormatter();
  registry.register("dummy", formatter);

  // Test retrieval
  auto retrieved = registry.get("dummy");
  assert(retrieved is formatter, "Registry should return the registered formatter");

  // Test formatting
  assert(retrieved.format("test") == "dummy:test", "Formatter should format correctly");

  // Test duplicate registration throws
  bool caught = false;
  try {
    registry.register("dummy", formatter);
  } catch (Exception e) {
    caught = true;
  }
  assert(caught, "Duplicate registration should throw");

  // Test get for non-existent key returns null or throws
  static if (is(typeof(registry.get("notfound")) == typeof(null))) {
    assert(registry.get("notfound") is null, "Non-existent key should return null");
  } else {
    caught = false;
    try {
      registry.get("notfound");
    } catch (Exception e) {
      caught = true;
    }
    assert(caught, "Getting non-existent key should throw");
  } */
}
