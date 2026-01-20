module uim.oop.patterns.registries.typed;

import uim.oop;

mixin(ShowModule!());

@safe:

/**
 * Typed registry with type-safe registration
 */
class TypedRegistry(Base) {
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
    if (auto item = key in _items) {
      return cast(T)(*item);
    }
    throw new Exception("Item not found: " ~ key);
  }

  bool has(string key) {
    return (key in _items) !is null;
  }

  TypeInfo getType(string key) {
    if (auto type = key in _types) {
      return *type;
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