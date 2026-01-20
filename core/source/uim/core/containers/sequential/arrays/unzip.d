/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.unzip;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Unzips an array of tuples into two separate arrays.
  *
  * Params:
  *   zipped = The input array of tuples to be unzipped.
  *
  * Returns:
  *   A tuple containing two arrays: the first array contains the first elements of the tuples,
  *   and the second array contains the second elements of the tuples.
  * ```
  */
Tuple!(T1[], T2[]) unzip(T1, T2)(Tuple!(T1, T2)[] zipped) {
  T1[] firsts;
  T2[] seconds;
  foreach (item; zipped) {
    firsts ~= item[0];
    seconds ~= item[1];
  }
  return tuple(firsts, seconds);
}
///
unittest {
  mixin(ShowTest!"Testing unzip");

  auto zipped = [tuple(1, "a"), tuple(2, "b"), tuple(3, "c")];
  auto result = unzip(zipped);
  assert(result[0] == [1, 2, 3]);
  assert(result[1] == ["a", "b", "c"]);
}
