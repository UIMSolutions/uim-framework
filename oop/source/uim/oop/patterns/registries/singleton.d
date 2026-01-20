module uim.oop.patterns.registries.singleton;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Singleton registry - ensures single instance per key
 */
class SingletonRegistry(K, V) : IRegistry!(K, V) {
  private V[K] _instances;
  private V delegate() @safe[K] _factories;

  void register(K key, V delegate() @safe factory) {
    _factories[key] = factory;
  }

  void register(K key, V value) {
    _instances[key] = value;
  }

  V get(K key) {
    // Return existing instance if available
    if (auto instance = key in _instances) {
      return *instance;
    }

    // Create new instance using factory
    if (auto factory = key in _factories) {
      auto instance = (*factory)();
      _instances[key] = instance;
      return instance;
    }

    throw new Exception("Item not found in singleton registry: " ~ key.to!string);
  }

  bool has(K key) {
    return (key in _instances) !is null || (key in _factories) !is null;
  }

  void unregister(K key) {
    _instances.remove(key);
    _factories.remove(key);
  }

  void clear() {
    _instances.clear();
    _factories.clear();
  }

  K[] keys() {
    import std.algorithm : sort, uniq;
    import std.array : array;
    auto allKeys = _instances.keys ~ _factories.keys;
    return allKeys.sort.uniq.array;
  }

  V[] values() {
    return _instances.values;
  }

  size_t count() {
    return _instances.length;
  }
}
///
unittest {
  mixin(ShowTest!"Testing SingletonRegistry class...");
  
  class Service {
    int value;
    this() { value = 42; }
  }
  
  auto registry = new SingletonRegistry!(string, Service);
  registry.register("service", () => new Service());
  
  auto instance1 = registry.get("service");
  auto instance2 = registry.get("service");
  
  assert(instance1 is instance2); // Same instance
  assert(instance1.value == 42);
}