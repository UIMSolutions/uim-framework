/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.registries.helpers.factory;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Factory registry - combines Registry with Factory pattern
 */
class FactoryRegistry(T) {
  private static T delegate() @safe[string] _factories;

  static void register(string key, T delegate() @safe factory) {
    _factories[key] = factory;
  }

  static T create(string key) {
    if (auto factory = key in _factories) {
      return (*factory)();
    }
    throw new Exception("Factory not found: " ~ key);
  }

  static bool isRegistered(string key) {
    return (key in _factories) !is null;
  }

  static void unregister(string key) {
    _factories.remove(key);
  }

  static void clear() {
    _factories.clear();
  }

  static string[] registeredKeys() {
    return _factories.keys;
  }

  static size_t count() {
    return _factories.length;
  }
}
