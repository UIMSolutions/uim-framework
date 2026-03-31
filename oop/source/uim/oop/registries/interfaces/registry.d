/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.registries.interfaces.registry;

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
