/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.size;

import uim.core;

mixin(ShowModule!());
@safe:

/**
  Returns the number of elements in the array.
  
  Params:
    values = The array whose size is to be determined.
  
  Returns:
    The number of elements in the array.  
  */
size_t size(T)(T[] values) {
  return values.length;
}
///
unittest {
  // Test with int array
  int[] arr = [1, 2, 3, 4, 5];
  assert(size(arr) == 5);

  // Test with empty array
  int[] emptyArr;
  assert(size(emptyArr) == 0);

  // Test with string array
  string[] strArr = ["a", "b", "c"];
  assert(size(strArr) == 3);

  // Test with array of structs
  struct S {
    int x;
  }

  S[] sArr = [S(1), S(2)];
  assert(size(sArr) == 2);

  // Test with array of arrays
  int[][] arrArr = [[1, 2], [3], []];
  assert(size(arrArr) == 3);
}
