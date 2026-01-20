/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.duplicates;

import uim.core;

mixin(ShowModule!());
@safe:

// #region duplicates
/** 
  * Finds all duplicate values in the given array and returns a mapping of each duplicate value to its count of duplicates.
  *
  * Params:
  *   someValues = The array to search for duplicate values.
  *
  * Returns:
  *   A mapping where each key is a duplicate value from the input array, and the corresponding value is the count of how many times that value appears as a duplicate (i.e., total occurrences minus one).
  *
  * Example:
  * ```d
  * auto result = duplicates([1, 2, 2, 3, 3, 3]);
  * // result will be: [2: 1, 3: 2]
  * ```
  */
size_t[T] duplicates(T)(T[] someValues) {
  size_t[T] results;
  if (someValues.length < 2) {
    return results; // No duplicates possible in arrays with less than 2 elements
  }

  someValues
    .filter!(value => duplicates(someValues, value) > 0)
    .each!(value => results[value] = duplicates(someValues, value));

  return results;
}
/// 
unittest {
  // Test with empty array
  auto result1 = duplicates!int([]);
  assert(result1.length == 0);

  // Test with single element array
  auto result2 = duplicates([42]);
  assert(result2.length == 0);

  // Test with no duplicates
  auto result3 = duplicates([1, 2, 3, 4]);
  assert(result3.length == 0);

  // Test with one duplicate
  auto result4 = duplicates([1, 2, 2, 3]);
  assert(result4.length == 1);
  assert(result4[2] == 1);

  // Test with multiple duplicates
  auto result5 = duplicates([1, 2, 2, 2, 3, 3, 3]);
  assert(result5.length == 2);
  assert(result5[2] == 2);
  assert(result5[3] == 2);

  // Test with strings
  auto result6 = duplicates(["a", "b", "a", "c", "b"]);
  assert(result6.length == 2);
  assert(result6["a"] == 1);
  assert(result6["b"] == 1);

  // Test with floating-point numbers
  auto result8 = duplicates([1.1, 2.2, 1.1, 3.3, 2.2]);
  assert(result8.length == 2);
  assert(result8[1.1] == 1);
  assert(result8[2.2] == 1);

  // Test with all elements the same
  auto result9 = duplicates([5, 5, 5, 5]);
  assert(result9.length == 1);
  assert(result9[5] == 3);

  // Test with mixed types (should not compile, but included for completeness)
  // auto result10 = duplicates([1, "a", 1, "a"]); // Uncommenting this should cause a compilation error
}

/** 
  * Counts the number of duplicate occurrences of `search` in the `values` array.
  * If `search` appears more than once, returns the count of duplicates (total occurrences minus one).
  * If `search` appears once or not at all, returns 0.
  *
  * Params:
  *   values = The array to search for duplicates.
  *   search = The value to count duplicates for.
  *
  * Returns:
  *   The count of duplicate occurrences of `search` in `values`, or 0 if there are no duplicates.
  */
size_t duplicates(T)(T[] values, T search) {
  auto result = values.filter!(value => value == search).count;
  return result > 1 ? result - 1 : 0;
}
///
unittest {
  // Test with no duplicates
  assert(duplicates([1, 2, 3, 4], 2) == 0);
  assert(duplicates([1, 2, 3, 4], 5) == 0);

  // Test with one duplicate
  assert(duplicates([1, 2, 2, 3], 2) == 1);
  assert(duplicates([1, 2, 2, 3], 3) == 0);

  // Test with multiple duplicates
  assert(duplicates([1, 2, 2, 2, 3, 3, 3], 2) == 2);
  assert(duplicates([1, 2, 2, 2, 3, 3, 3], 3) == 2);

  // Test with all elements the same
  assert(duplicates([5, 5, 5, 5], 5) == 3);

  // Test with empty array
  assert(duplicates!int([], 1) == 0);

  // Test with single element array
  assert(duplicates([42], 42) == 0);

  // Test with strings
  assert(duplicates(["a", "b", "a", "c", "b"], "a") == 1);
  assert(duplicates(["a", "b", "a", "c", "b"], "b") == 1);
  assert(duplicates(["a", "b", "a", "c", "b"], "c") == 0);

  // Test with characters
  assert(duplicates(['x', 'y', 'x', 'z', 'y'], 'x') == 1);
  assert(duplicates(['x', 'y', 'x', 'z', 'y'], 'y') == 1);
  assert(duplicates(['x', 'y', 'x', 'z', 'y'], 'z') == 0);

  // Test with floating-point numbers
  assert(duplicates([1.1, 2.2, 1.1, 3.3, 2.2], 1.1) == 1);
  assert(duplicates([1.1, 2.2, 1.1, 3.3, 2.2], 2.2) == 1);
  assert(duplicates([1.1, 2.2, 1.1, 3.3, 2.2], 3.3) == 0);
}
