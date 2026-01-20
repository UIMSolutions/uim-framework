module uim.oop.patterns.registries.lazy_;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Lazy registry - creates instances on first access
 */
class LazyRegistry(K, V) : IRegistry!(K, V) {
  private V[K] _cache;
  private V delegate() @safe[K] _factories;

  void register(K key, V delegate() @safe factory) {
    _factories[key] = factory;
  }

  void register(K key, V value) {
    _cache[key] = value;
  }

  V get(K key) {
    // Check cache first
    if (auto cached = key in _cache) {
      return *cached;
    }

    // Create and cache
    if (auto factory = key in _factories) {
      auto value = (*factory)();
      _cache[key] = value;
      return value;
    }

    throw new Exception("Item not found in lazy registry: " ~ key.to!string);
  }

  bool has(K key) {
    return (key in _cache) !is null || (key in _factories) !is null;
  }

  bool isCached(K key) {
    return (key in _cache) !is null;
  }

  void unregister(K key) {
    _cache.remove(key);
    _factories.remove(key);
  }

  void clear() {
    _cache.clear();
    _factories.clear();
  }

  void clearCache() {
    _cache.clear();
  }

  K[] keys() {
    import std.algorithm : sort, uniq;
    import std.array : array;
    auto allKeys = _cache.keys ~ _factories.keys;
    return allKeys.sort.uniq.array;
  }

  V[] values() {
    return _cache.values;
  }

  size_t count() {
    return keys().length;
  }
}
///
unittest {
  mixin(ShowTest!"Testing Lazy Registry class...");

  // Test lazy registry
  int factoryCallCount = 0;
  
  class Resource {
    this() { factoryCallCount++; }
  }
  
  auto registry = new LazyRegistry!(string, Resource);
  registry.register("resource", () => new Resource());
  
  assert(factoryCallCount == 0); // Not created yet
  assert(!registry.isCached("resource"));
  
  auto res1 = registry.get("resource");
  assert(factoryCallCount == 1); // Created on first access
  assert(registry.isCached("resource"));
  
  auto res2 = registry.get("resource");
  assert(factoryCallCount == 1); // Not created again (cached)
  assert(res1 is res2);
}