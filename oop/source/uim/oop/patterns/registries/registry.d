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
class Registry(K, V) : IRegistry!(K, V) {
  private V[K] _items;

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






// Unit tests
unittest {
  mixin(ShowTest!"Testing Registry class...");

  auto registry = new Registry!(string, int);
  
  registry.register("one", 1);
  registry.register("two", 2);
  
  assert(registry.has("one"));
  assert(registry.get("one") == 1);
  assert(registry.count() == 2);
  
  registry.unregister("one");
  assert(!registry.has("one"));
  assert(registry.count() == 1);
  
  registry.clear();
  assert(registry.count() == 0);
}

unittest {
  mixin(ShowTest!"Testing FactoryRegistry class...");

  class Product {
    string name;
    this(string n) { name = n; }
  }
  
  FactoryRegistry!Product.register("productA", () => new Product("A"));
  FactoryRegistry!Product.register("productB", () => new Product("B"));
  
  assert(FactoryRegistry!Product.isRegistered("productA"));
  
  auto productA = FactoryRegistry!Product.create("productA");
  assert(productA.name == "A");
  
  auto productB = FactoryRegistry!Product.create("productB");
  assert(productB.name == "B");
  
  FactoryRegistry!Product.clear();
}







unittest {
  // Test typed registry
  interface IService {}
  class ServiceA : IService { string name = "A"; }
  class ServiceB : IService { string name = "B"; }
  
  auto registry = new TypedRegistry!IService;
  registry.register("serviceA", new ServiceA());
  registry.register("serviceB", new ServiceB());
  
  auto serviceA = registry.get!ServiceA("serviceA");
  assert(serviceA.name == "A");
  
  auto serviceB = registry.get!ServiceB("serviceB");
  assert(serviceB.name == "B");
}

unittest {
  // Test registry iteration
  auto registry = new Registry!(string, int);
  registry.register("a", 1);
  registry.register("b", 2);
  registry.register("c", 3);
  
  int sum = 0;
  foreach (key, value; registry) {
    sum += value;
  }
  assert(sum == 6);
}

