module uim.oop.patterns.registries.hierarchical;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Hierarchical registry with parent-child relationships
 */
class HierarchicalRegistry(K, V) : IRegistry!(K, V) {
  private V[K] _items;
  private HierarchicalRegistry!(K, V) _parent;

  this(HierarchicalRegistry!(K, V) parent = null) {
    _parent = parent;
  }

  void register(K key, V value) {
    _items[key] = value;
  }

  V get(K key) {
    // Check local registry
    if (auto item = key in _items) {
      return *item;
    }

    // Check parent registry
    if (_parent !is null) {
      return _parent.get(key);
    }

    throw new Exception("Item not found in hierarchical registry: " ~ key.to!string);
  }

  bool has(K key) {
    if ((key in _items) !is null) {
      return true;
    }
    if (_parent !is null) {
      return _parent.has(key);
    }
    return false;
  }

  bool hasLocal(K key) {
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

  void setParent(HierarchicalRegistry!(K, V) parent) {
    _parent = parent;
  }

  HierarchicalRegistry!(K, V) createChild() {
    return new HierarchicalRegistry!(K, V)(this);
  }
}
///
unittest {
  // Test hierarchical registry
  auto parent = new HierarchicalRegistry!(string, int);
  parent.register("global", 100);
  
  auto child = parent.createChild();
  child.register("local", 200);
  
  assert(child.has("local"));
  assert(child.has("global")); // Inherited from parent
  assert(child.hasLocal("local"));
  assert(!child.hasLocal("global"));
  
  assert(child.get("local") == 200);
  assert(child.get("global") == 100);
}