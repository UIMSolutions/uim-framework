/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.insert;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Inserts a value at a specified index in the array.
  *
  * Params:
  *   arr = The input array where the value will be inserted.
  *   index = The index at which to insert the value.
  *   value = The value to insert.
  *
  * Returns:
  *   A new array with the value inserted at the specified index.
  * ```
  */
auto insertAt(T)(T[] arr, size_t index, in T value) {
  T[] result;
  if (index >= arr.length) {
    result = arr.dup;
    result ~= value;
  } else {          
    result = arr[0 .. index].dup;
    result ~= value;
    result ~= arr[index .. $];
  }
  return result;
}
///     
unittest {
  auto result1 = insertAt([1, 2, 3, 4], 2, 99);
  assert(result1 == [1, 2, 99, 3, 4]);

  auto result2 = insertAt(["a", "b", "c"], 1, "x");
  assert(result2 == ["a", "x", "b", "c"]);

  auto result3 = insertAt([1.1, 2.2, 3.3], 0, 0.0);
  assert(result3 == [0.0, 1.1, 2.2, 3.3]);

  auto result4 = insertAt([true, false], 5, true);
  assert(result4 == [true, false, true]);
}