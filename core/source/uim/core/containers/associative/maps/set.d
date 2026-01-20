/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.set;

import uim.core;

mixin(ShowModule!());

@safe:

V[K] setValue(K, V)(V[K] map, K key, V value) {
  V[K] results = map.dup;
  results[key] = value;
  return results;
}
