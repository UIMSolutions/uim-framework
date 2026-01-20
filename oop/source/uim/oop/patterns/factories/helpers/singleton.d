/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.factories.helpers.singleton;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Singleton factory - ensures only one instance exists.
 */
class SingletonFactory(T) {
  private static T _instance;
  private T delegate() @safe _creator;

  this(T delegate() @safe creator) {
    _creator = creator;
  }

  T getInstance() {
    if (_instance is null) {
      _instance = _creator();
    }
    return _instance;
  }

  void reset() {
    _instance = null;
  }
}
///
unittest {
  mixin(ShowTest!"Testing Singleton Factory Pattern");

  class Product {
    int value;
    this() { value = 42; }
  }

  auto singletonFactory = new SingletonFactory!Product(() => new Product());
  
  auto instance1 = singletonFactory.getInstance();
  auto instance2 = singletonFactory.getInstance();
  
  assert(instance1 is instance2); // Same instance
  assert(instance1.value == 42);
}