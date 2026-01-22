/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.patterns.registries.registry;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Basic registry implementation
 */
class UIMRegistry(K, V) : IRegistry!(K, V) {
  this() {
  }

  protected V[K] _items;

  void register(K key, V value) {
    _items[key] = value;
  }

  V get(K key) {
    if (auto item = key in _items) {
      return *item;
    }
    throw new Exception("Item not found in registry: " ~ key.to!string);
  }

  V get(K key, V defaultValue) {
    if (auto item = key in _items) {
      return *item;
    }
    return defaultValue;
  }

  bool has(K key) {
    return (key in _items) !is null;
  }

  void unregister(K key) {
    _items.remove(key);
  }

  void clear() {
    _items.clear();
  }

  K[] keys() {
    return _items.keys;
  }

  V[] values() {
    return _items.values;
  }

  size_t count() {
    return _items.length;
  }

  int opApply(scope int delegate(K key, V value) @safe dg) {
    int result = 0;
    foreach (key, value; _items) {
      result = dg(key, value);
      if (result) break;
    }
    return result;
  }
}

