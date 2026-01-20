/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.factories.helpers.builder;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Factory builder for fluent configuration.
 */
class FactoryBuilder(T) {
  private T delegate() @safe _creator;
  private bool _singleton = false;
  private bool _cached = false;

  this(T delegate() @safe creator) {
    _creator = creator;
  }

  FactoryBuilder!T asSingleton() {
    _singleton = true;
    return this;
  }

  FactoryBuilder!T withCaching() {
    _cached = true;
    return this;
  }

  IFactory!T build() {
    if (_singleton) {
      return new SingletonFactoryWrapper!T(_creator);
    }
    return new Factory!T(_creator);
  }
}

private class SingletonFactoryWrapper(T) : IFactory!T {
  private T _instance;
  private T delegate() @safe _creator;

  this(T delegate() @safe creator) {
    _creator = creator;
  }

  T create() {
    if (_instance is null) {
      _instance = _creator();
    }
    return _instance;
  }
}
