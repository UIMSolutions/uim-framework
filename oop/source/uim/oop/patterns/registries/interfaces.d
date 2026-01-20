module uim.oop.patterns.registries.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic registry interface
 */
interface IRegistry(K, V) {
  void register(K key, V value);
  V get(K key);
  bool has(K key);
  void unregister(K key);
  void clear();
  K[] keys();
  V[] values();
  size_t count();
}
