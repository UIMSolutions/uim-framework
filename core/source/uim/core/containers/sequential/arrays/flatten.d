/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.flatten;

import uim.core;

mixin(ShowModule!());
@safe:

/** Flattens a two-dimensional array into a one-dimensional array by concatenating all inner arrays.

  Params:
    values = The two-dimensional array to be flattened.

  Returns:
    A one-dimensional array containing all elements from the inner arrays in order.
*/
auto flatten(T)(T[][] values) {
  T[] results;
  () @trusted { results = values.reduce!((a, b) => a ~ b); }();
  return results;
}
///
unittest {
  // Test with int arrays
  int[][] intArr = [[1, 2], [3, 4], [5, 6]];
  assert(intArr.flatten.equal([1, 2, 3, 4, 5, 6]));

  // Test with double arrays
  double[][] dblArr = [[1.0, 2.0], [3.0, 4.0], [5.0, 6.0]];
  assert(dblArr.flatten.equal([1.0, 2.0, 3.0, 4.0, 5.0, 6.0]));

  // Test with string arrays
  string[][] strArr = [["a", "b"], ["c", "d"], ["e", "f"]];
  assert(strArr.flatten.equal(["a", "b", "c", "d", "e", "f"]));

  // Test with single inner array
  int[][] singleArr = [[42, 43, 44]];
  assert(singleArr.flatten.equal([42, 43, 44]));

  // Test with inner empty arrays
  int[][] innerEmptyArr = [[], [], []];
  assert(innerEmptyArr.flatten.isEmpty);

  // Test with mixed empty and non-empty inner arrays
  int[][] mixedArr = [[], [1, 2], [], [3], []];
  assert(mixedArr.flatten.equal([1, 2, 3]));
}
