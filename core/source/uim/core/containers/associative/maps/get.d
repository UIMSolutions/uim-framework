/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.get;

import uim.core;

mixin(ShowModule!());

@safe:

/* 
V getValue(K, V)(V[K] map, K key, V defaultValue = Null!V) {
  return key in map ? map[key] : defaultValue;
}

V getValue(K:string, V:Json)(V[K] map, K key, V defaultValue = Null!V) {
  return key in map ? map[key] : defaultValue;
}
*/