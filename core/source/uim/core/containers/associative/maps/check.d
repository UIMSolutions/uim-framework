/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.associative.maps.check;

import uim.core;

mixin(ShowModule!());

@safe:

bool isNull(K, V)(V[K] map) {
  return map is null;
}
///
unittest {
  mixin(ShowTest!"Testing isNull function");

  int[string] map = null;
  assert(map is null);

  map = ["a": 1];
  assert(!map.isNull);
}

bool isEmpty(K, V)(V[K] map) {
  return map.length == 0;
}
///
unittest {
  mixin(ShowTest!"Testing isEmpty function");

  int[string] map = null;
  assert(map.isEmpty());

  map = ["a": 1];
  assert(!map.isEmpty());
}

bool isSingle(K, V)(V[K] map) {
  return map.length == 1;
}
///
unittest {
  mixin(ShowTest!"Testing isSingle function");

  int[string] map = ["a": 1];
  assert(map.isSingle());

  map = ["a": 1, "b": 2];
  assert(!map.isSingle());
}

bool isMulti(K, V)(V[K] map) {
  return map.length > 1;
}
///
unittest {
  mixin(ShowTest!"Testing isMulti function");

  int[string] map = ["a": 1, "b": 2];
  assert(map.isMulti());

  map = ["a": 1];
  assert(!map.isMulti());
}