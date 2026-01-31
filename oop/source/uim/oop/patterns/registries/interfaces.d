module uim.oop.patterns.registries.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:
/**
 * Generic registry interface
 */
interface IRegistry(K, V) {
  IRegistry!(K, V) register(K key, V value);
  V get(K key);
  bool has(K key);
  IRegistry!(K, V) unregister(K key);
  IRegistry!(K, V) clear();
  K[] keys();
  V[] values();
  size_t count();
}
