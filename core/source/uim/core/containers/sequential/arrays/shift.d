/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.shift;

import uim.core;

mixin(ShowModule!());
@safe:

/** 
  * Removes and returns the first `times` elements from the `values` array.
  * If `times` is greater than or equal to the length of `values`, all elements are removed and returned.
  * If `values` is empty, an empty array is returned.
  * If `times` is zero, `null` is returned and `values` remains unchanged.
  *
  * Params:
  *   values = The array from which elements will be removed.
  *   times  = The number of elements to remove from the start of the array (default is 1).
  *
  * Returns:
  *   An array containing the removed elements, or `null` if `times` is zero.
  */
Tuple!(T[], T[]) shiftMany(T)(T[] values, size_t times = 1) {
  T[] nullResult;
  if (values.length == 0) {
    return tuple(nullResult, values);
  }

  if (times == 0) {
    return tuple(nullResult, values);
  }

  if (times >= values.length) {
    return tuple(values.dup, nullResult);
  }

  return tuple(values[0 .. times].dup, values[times .. $].dup);
}
///
unittest {
  // Test shiftMany with normal case
  int[] array1 = [1, 2, 3, 4, 5];
  auto result1 = shiftMany(array1, 2);
  assert(result1[0].equal([1, 2]));
  assert(result1[1].equal([3, 4, 5]));

  // Test shiftMany with times greater than array length
  int[] array2 = [10, 20, 30];
  auto result2 = shiftMany(array2, 5);
  assert(result2[0].equal([10, 20, 30]));
  assert(result2[1] is null);

  // Test shiftMany with empty array
  int[] array3 = [];
  auto result3 = shiftMany(array3, 2);
  assert(result3[0] is null);
  assert(result3[1].length == 0);

  // Test shiftMany with times zero
  int[] array4 = [7, 8, 9];
  auto result4 = shiftMany(array4, 0);
  assert(result4[0] is null);
  assert(result4[1].equal([7, 8, 9]));  
}
/** 
  * Removes and returns the first element from the `values` array.
  * If `values` is empty, returns the default value of type `T`.
  *
  * Params:
  *   values = The array from which the first element will be removed.
  *
  * Returns:
  *   The removed element, or the default value of type `T` if the array is empty.
  */  
Tuple!(T, T[]) shift(T)(T[] values) {
  if (values.length == 0) {
    return tuple(T.init, values);
  }

  T firstValue = values[0];
  values = values[1 .. $].dup;
  return tuple(firstValue, values);
}
///
unittest {
  // Test shift with normal case
  int[] array1 = [1, 2, 3, 4, 5];
  auto result1 = shift(array1);
  assert(result1[0] == 1);
  assert(result1[1].equal([2, 3, 4, 5]));

  // Test shift with empty array
  int[] array2 = [];
  auto result2 = shift(array2);
  assert(result2[0] == int.init);
  assert(result2[1].length == 0);
}
