/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.intersect;

import uim.core;

mixin(ShowModule!());
@safe:

/** Returns the intersection of two arrays as a new array.
 * 
 * Params:
 *   values1 = The first array.
 *   values2 = The second array.
 *
 * Returns:
 *   A new array containing the intersection of the two input arrays.
 */
auto intersect(T)(T[] values1, T[] values2) {
  return values1.filter!(value => values2.hasValue(value)).array;
}
///
unittest {
  // Test with integers
  int[] array1 = [1, 2, 3, 4, 5];
  int[] array2 = [4, 5, 6, 7, 8];
  auto result = intersect(array1, array2);
  assert(result.equal([4, 5]));

  // Test with strings
  string[] s1 = ["apple", "banana", "cherry"];
  string[] s2 = ["banana", "date", "cherry"];
  auto sresult = intersect(s1, s2);
  assert(sresult.equal(["banana", "cherry"]));

  // Test with no intersection
  int[] a = [1, 2, 3];
  int[] b = [4, 5, 6];
  auto r = intersect(a, b);
  assert(r.length == 0);

  // Test with empty arrays
  int[] empty1 = [];
  int[] empty2 = [];
  auto emptyResult = intersect(empty1, empty2);
  assert(emptyResult.length == 0);

  // Test with one empty array
  int[] nonEmpty = [1, 2, 3];
  auto oneEmptyResult = intersect(nonEmpty, empty1);
  assert(oneEmptyResult.length == 0);

  // Test with duplicates in input
  int[] dup1 = [1, 2, 2, 3];
  int[] dup2 = [2, 2, 3, 4];
  auto dupResult = intersect(dup1, dup2);
  assert(dupResult.equal([2, 2, 3]));
}
