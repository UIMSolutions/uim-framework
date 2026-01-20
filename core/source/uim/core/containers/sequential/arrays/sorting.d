/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.sorting;

import uim.core;

mixin(ShowModule!());

@safe:

T[] sortAsc(T)(T[] items) {
  auto results = items.dup;
  results.sort!((a, b) => a < b);
  return results;
}
///
unittest {
  auto test1 = [5, 3, 1, 4, 2];
  assert(test1.sortAsc() == [1, 2, 3, 4, 5]);

  auto test2 = ["e", "c", "a", "d", "b"];
  assert(test2.sortAsc() == ["a", "b", "c", "d", "e"]);
}

T[] sortDesc(T)(T[] items) {
  auto results = items.dup;
  results.sort!((a, b) => a > b);
  return results;
}
///
unittest {
  auto test1 = [5, 3, 1, 4, 2];
  assert(test1.sortDesc() == [5, 4, 3, 2, 1]);

  auto test2 = ["e", "c", "a", "d", "b"];
  assert(test2.sortDesc() == ["e", "d", "c", "b", "a"]);
}