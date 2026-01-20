/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.move;

import uim.core;

mixin(ShowModule!());

@safe:

// #region forward
T[] moveForward(T)(T[] values, size_t fromIndex, size_t toIndex) {
  auto result = values.dup;

  if (fromIndex >= result.length || toIndex >= result.length || fromIndex >= toIndex) {
    return result;
  }
  auto temp = result[fromIndex];
  for (size_t i = fromIndex; i < toIndex; i++) {
    result[i] = result[i + 1];
  }

  result[toIndex] = temp;
  return result;
}
///
unittest {
  mixin(ShowTest!"Testing moveForward"); 

  auto arr = [1, 2, 3, 4, 5];
  auto movedArr = moveForward(arr, 1, 3); // Move element at index 1 to index 3
  assert(movedArr == [1, 3, 4, 2, 5]);
}
  // #endregion forward

// #region backward
T[] moveBackward(T)(ref T[] values, size_t fromIndex, size_t toIndex) {
  auto result = values.dup;

  if (fromIndex >= result.length || toIndex >= result.length || fromIndex <= toIndex) {
    return result;
  }
  auto temp = result[fromIndex];
  for (size_t i = fromIndex; i > toIndex; i--) {
    result[i] = result[i - 1];
  }
  result[toIndex] = temp;
  return result;
}
// #endregion backward
