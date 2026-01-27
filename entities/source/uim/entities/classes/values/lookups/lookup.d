/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.lookups.lookup;

import uim.entities;

@safe:
class LookupValue(K, V) : UIMValue {
  mixin(ValueThis!("LookupValue"));

  V[K] _items;

  LookupValue opIndexAssign(V value, K key) {
    _items[key] = value;
    return this;
  }

  V opIndex(this O)(K key) {
    return _items.get(key, null);
  }

  bool isEmpty() {
    return (_items.length == 0);    
  }

  size_t length() {
    return _items.length;    
  }

  alias opEquals = Object.opEquals;
  alias opEquals = UIMValue.opEquals;

  override UIMValue copy() {
    return LookupValue!(K, V)(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }
}
auto createLookupValue(K, V)() { return new LookupValue!(K, V); }
auto createLookupValue(K, V)(UIMAttribute theAttribute) { return new LookupValue!(K, V)(theAttribute); }
auto createLookupValue(K, V)(string theValue) { return new LookupValue!(K, V)(theValue); }
auto createLookupValue(K, V)(Json theValue) { return new LookupValue!(K, V)(theValue); }
auto createLookupValue(K, V)(UIMAttribute theAttribute, string theValue) { return new LookupValue!(K, V)(theAttribute, theValue); }
auto createLookupValue(K, V)(UIMAttribute theAttribute, Json theValue) { return new LookupValue!(K, V)(theAttribute, theValue); }

