/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.factories.helpers.singleton;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
  * A helper class for implementing the Singleton design pattern.
  * This class ensures that only one instance of a given type T is created and provides a global access point to it.
  *
  * Example usage:
  * auto singletonFactory = new SingletonFactory!MyClass(() => new MyClass());
  * auto instance = singletonFactory.getInstance();
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

  // Reset and create a new instance
  singletonFactory.reset();
  auto instance3 = singletonFactory.getInstance();

  // After reset, should be a different instance
  assert(instance1 !is instance3);
  assert(instance3.value == 42);  
}