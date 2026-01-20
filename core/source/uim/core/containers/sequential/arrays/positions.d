/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.positions;

import uim.core;

mixin(ShowModule!());

@safe:
// #region positions
// Creates a associative array with all positions of a value in an array
size_t[][T] positions(T)(T[] list) {
  size_t[][T] results;
  foreach (pos, v; list) {
    if (v in results) {
      results[v] ~= pos;
    } else {
      results[v] = [pos];
    }
  }
  return results;
}

unittest {
  // Test with an empty array
  assert(positions!int(null) == null);

  // Test with a single element array
  assert(positions([1]) == [1: [0UL]]);

  // Test with repeated elements
  assert(positions([1, 1]) == [1: [0UL, 1UL]]);

  // Test with multiple distinct elements
  assert(positions([1, 2]) == [1: [0UL], 2: [1UL]]);

  // Test with mixed repeated and distinct elements
  assert(positions([1, 2, 1, 3, 2]) == [1: [0UL, 2UL], 2: [1UL, 4UL], 3: [3UL]]);

  // Test with strings
  assert(positions(["a", "b", "a", "c", "b"]) == [
      "a": [0UL, 2UL],
      "b": [1UL, 4UL],
      "c": [3UL]
    ]);

  // Test with an array of characters
  assert(positions(['a', 'b', 'a', 'c', 'b']) == [
      'a': [0UL, 2UL],
      'b': [1UL, 4UL],
      'c': [3UL]
    ]);

  // Test with floating-point numbers
  assert(positions([1.1, 2.2, 1.1, 3.3]) == [
      1.1: [0UL, 2UL],
      2.2: [1UL],
      3.3: [3UL]
    ]);
}
// #endregion positions