/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.last;

import uim.core;

mixin(ShowModule!());
@safe:

/**
  * Returns the last element of the array, or `Null!T` if the array is empty.
  *
  * Params:
  *   values = The array to get the last element from.
  *
  * Returns:
  *   The last element of the array, or `Null!T` if the array is empty.
  */
T last(T)(T[] values) {
  return values.length > 0
    ? values[$ - 1] 
    : Null!T;
}
///
unittest {
  mixin(ShowTest!"Testing last");

  // Test last with non-empty array
  int[] arr = [1, 2, 3, 4, 5];
  auto lastElem = last(arr);
  assert(lastElem == 5);

  // Test last with single-element array
  int[] singleArr = [42];
  lastElem = last(singleArr);
  assert(lastElem == 42);

  // Test last with empty array (should return Null!int)
  int[] emptyArr;
  lastElem = last(emptyArr);
  import uim.core; // For Null!T
  assert(lastElem == Null!int);

  // Test last with string array
  string[] strArr = ["a", "b", "c"];
  auto lastStr = last(strArr);
  assert(lastStr == "c");

  // Test last with empty string array
  string[] emptyStrArr;
  lastStr = last(emptyStrArr);
  assert(lastStr == Null!string);
}

/**
  * Returns the last `size` elements of the array.
  *
  * Params:
  *   values = The array to get the last elements from.
  *   size = The number of elements to return from the end of the array.
  *
  * Returns:
  *   An array containing the last `size` elements. If `size` is greater than the array length, returns the entire array.
  *   If the array is empty, returns `null`.
  */
auto lastMany(T)(T[] values, size_t size) {
  if (values.length == 0) {
    return null;
  }

  return values.length > size
    ? values[$ - size .. $] 
    : values.dup;
}
///
unittest {
  // Test with non-empty array, size less than length
  int[] arr = [1, 2, 3, 4, 5];
  auto result = lastMany(arr, 3);
  assert(result == [3, 4, 5]);

  // Test with non-empty array, size equal to length
  result = lastMany(arr, 5);
  assert(result == [1, 2, 3, 4, 5]);

  // Test with non-empty array, size greater than length
  result = lastMany(arr, 10);
  assert(result == [1, 2, 3, 4, 5]);

  // Test with empty array
  int[] emptyArr;
  result = lastMany(emptyArr, 3);
  assert(result is null);

  // Test with size zero
  result = lastMany(arr, 0);
  assert(result == []);
}
