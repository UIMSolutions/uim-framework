/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.registries.typed;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Typed registry with type-safe registration
 */
class TypeUIMRegistry(Base) {
  private Object[string] _items;
  private TypeInfo[string] _types;

  void register(T : Base)(string key, T instance) {
    _items[key] = cast(Object)instance;
    _types[key] = typeid(T);
  }

  void registerFactory(T : Base)(string key, T delegate() @safe factory) {
    _items[key] = cast(Object)factory;
    _types[key] = typeid(T);
  }

  T get(T : Base)(string key) {
    if (key in _items) {
      return cast(T)(_items[key]);
    }
    throw new Exception("Item not found: " ~ key);
  }

  bool has(string key) {
    return (key in _items) !is null;
  }

  TypeInfo getType(string key) {
    if (key in _types) {
      return _types[key];
    }
    return null;
  }

  void unregister(string key) {
    _items.remove(key);
    _types.remove(key);
  }

  void clear() {
    _items.clear();
    _types.clear();
  }

  string[] keys() {
    return _items.keys;
  }

  size_t count() {
    return _items.length;
  }
}