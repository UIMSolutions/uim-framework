/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.chunks;

import uim.core;

mixin(ShowModule!());

@safe:
/** 
  * Splits an array into chunks of a specified size.
  *
  * Params:
  *   arr = The input array to be chunked.
  *   chunkSize = The size of each chunk.
  *
  * Returns:
  *   An array of arrays, where each inner array is a chunk of the specified size.
  *   The last chunk may be smaller if the total number of elements is not divisible by `chunkSize`.
  * ```
  */
auto chunks(T)(T[] arr, size_t chunkSize) {
  T[][] results;
  if (chunkSize == 0) {
    return results; // Return empty array if chunkSize is 0
  }
  for (size_t i = 0; i < arr.length; i += chunkSize) {
    results ~= arr[i .. (i + chunkSize > arr.length ? arr.length : i + chunkSize)];
  }
  return results;
}
///
unittest {
  mixin(ShowTest!"Testing chunks function");

  auto testArray = [1, 2, 3, 4, 5, 6, 7, 8, 9];

  auto result1 = chunks(testArray, 3);
  assert(result1.length == 3);
  assert(result1[0] == [1, 2, 3]);
  assert(result1[1] == [4, 5, 6]);
  assert(result1[2] == [7, 8, 9]);

  auto result2 = chunks(testArray, 4);
  assert(result2.length == 3);
  assert(result2[0] == [1, 2, 3, 4]);
  assert(result2[1] == [5, 6, 7, 8]);
  assert(result2[2] == [9]);

  auto result3 = chunks(testArray, 0);
  assert(result3.length == 0);

  auto result4 = chunks(testArray, 15);
  assert(result4.length == 1);
  assert(result4[0] == testArray);
}