/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.minmax;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Returns the minimum and maximum values from the input array.
  *
  * Params:
  *   arr = The input array from which to find the minimum and maximum values.
  *
  * Returns:
  *   A tuple containing the minimum and maximum values.
  *   If the array is empty, both values in the tuple will be the default value of type T.
  * ```
  */
Tuple!(T, T) minMax(T)(T[] arr) {
  if (arr.length == 0) {
    return tuple(T.init, T.init);
  }
  T minValue = arr[0];
  T maxValue = arr[0];
  foreach (value; arr) {
    if (value < minValue) {
      minValue = value;
    }
    if (value > maxValue) {
      maxValue = value;
    }
  }
  return tuple(minValue, maxValue);
}
///
unittest {
  auto result1 = minMax([3, 1, 4, 1, 5, 9, 2, 6, 5]);
  assert(result1[0] == 1); // Minimum
  assert(result1[1] == 9); // Maximum

  auto result2 = minMax(["banana", "apple", "cherry"]);
  assert(result2[0] == "apple"); // Minimum
  assert(result2[1] == "cherry"); // Maximum
}
