/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.lookups.lookup;

import uim.entities;

mixin(ShowModule!());

@safe:
/* 
class LookupValue(K, V) : UIMValue {
  this() {
    super();
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

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

  // override UIMValue copy() {
  //   return new LookupValue!(K, V)(attribute, toJson);
  // }
  // override UIMValue dup() {
  //   return copy;
  // }
}

*/ 