/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.unique;

import uim.core;

mixin(ShowModule!());

@safe:

T[] unique(T)(T[] values) {
  T[] results;
  values.each!((value) {
    if (!results.hasValue(value)) {
      results ~= value;
    }
  });
  return results;
}
/// 
unittest {
  mixin(ShowTest!"Testing unique function");
  auto arr = [1, 2, 2, 3, 4, 4, 5];

  auto uniqueArr = unique(arr);
  assert(uniqueArr.length == 5);
  assert(uniqueArr[0] == 1);
  assert(uniqueArr[1] == 2);
  assert(uniqueArr[2] == 3);
  assert(uniqueArr[3] == 4);
  assert(uniqueArr[4] == 5);
}
