/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.drop;

import uim.core;

mixin(ShowModule!());
@safe:

/** 
    * Drops the first `n` elements from the array `values` and returns the resulting array.
    *
    * Params:
    *   values = The input array from which elements will be dropped.
    *   number = The number of elements to drop from the start of the array.
    *
    * Returns:
    *   A new array with the first `n` elements removed.
    *
    * Example:
    * ```d
    * import uim.core.containers.sequential.arrays.drop : drop;
    * 
    * auto values = [1, 2, 3, 4, 5];
    * auto result = drop(arr, 2); // result is [3, 4, 5]
    * ```
    */
auto drop(T)(T[] values, size_t number) {
  return number >= values.length
    ? T[].init // Return an empty array if number is greater than or equal to the array length
    : values[number .. $]; // Return the subarray starting from index number to the end
}
///
unittest {
  auto result = drop([1, 2, 3, 4, 5], 2);
  assert(result == [3, 4, 5]);
  assert(drop([1, 2, 3], 0) == [1, 2, 3]);
  assert(drop([1, 2, 3], 3) == []);
  assert(drop([1, 2, 3], 5) == []);
  assert(drop([], 2) == []);
}
