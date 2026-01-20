module uim.oop.patterns.registries.threadsafe;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Thread-safe registry with synchronized access
 */
 /* 
synchronized class ThreadSafeRegistry(K, V) : IRegistry!(K, V) {
  private V[K] _items;

  @safe
  void register(K key, V value) {
    synchronized (this) {
      _items[key] = value;
    }
  }

  V get(K key) {
    synchronized (this) {
      if (auto item = key in _items) {
        return *item;
      }
      throw new Exception("Item not found in thread-safe registry: " ~ key.to!string);
    }
  }

  bool has(K key) {
    synchronized (this) {
      return (key in _items) !is null;
    }
  }

  void unregister(K key) {
    synchronized (this) {
      _items.remove(key);
    }
  }

  void clear() {
    synchronized (this) {
      _items.clear();
    }
  }

  K[] keys() {
    synchronized (this) {
      return _items.keys;
    }
  }

  V[] values() {
    synchronized (this) {
      return _items.values;
    }
  }

  size_t count() {
    synchronized (this) {
      return _items.length;
    }
  }
}

unittest {
  // Test thread-safe registry
  auto registry = new shared ThreadSafeRegistry!(string, int);
  registry.register("key", 42);
  
  assert(registry.has("key"));
  assert(registry.get("key") == 42);
} */