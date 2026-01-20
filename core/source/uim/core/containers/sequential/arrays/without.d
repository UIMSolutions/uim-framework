/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.without;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Removes all occurrences of `value` from the `values` array.
  * 
  * Params:
  *   values = The input array from which to remove the specified value.
  *   value = The value to be removed from the array.
  * 
  * Returns:
  *   A new array with all occurrences of `value` removed.
  */
T[] without(T)(T[] values, T value) {
  return values.filter!(v => v != value).array;
}
/// 
unittest {
  // Test removing an existing value
  int[] arr = [1, 2, 3, 2, 4];
  auto result = without(arr, 2);
  assert(result.equal([1, 3, 4]));

  // Test removing a value not present
  int[] array2 = [5, 6, 7];
  auto result2 = without(array2, 4);
  assert(result2.equal([5, 6, 7]));

  // Test with empty array
  int[] emptyArr;
  auto resultEmpty = without(emptyArr, 1);
  assert(resultEmpty.length == 0);

  // Test with string array
  string[] arrStr = ["a", "b", "c", "b"];
  auto resultStr = without(arrStr, "b");
  assert(resultStr.equal(["a", "c"]));

  // Test with all elements equal to value
  int[] arrAll = [2, 2, 2];
  auto resultAll = without(arrAll, 2);
  assert(resultAll.length == 0);

  // Test with no elements to remove
  int[] arrNone = [1, 3, 5];
  auto resultNone = without(arrNone, 2);
  assert(resultNone.equal([1, 3, 5]));
}

/** 
  * Removes all occurrences of each value in `toRemove` from the `values` array.
  * 
  * Params:
  *   values = The input array from which to remove the specified values.
  *   toRemove = An array of values to be removed from the input array.
  * 
  * Returns:
  *   A new array with all occurrences of the specified values removed.
  */
auto withoutMany(T)(T[] values, T[] toRemove) {
  return values.filter!(v => !(toRemove.hasValue(v))).array;
}
///
unittest {
  // Test removing multiple existing values
  int[] arr = [1, 2, 3, 2, 4, 5];
  int[] toRemove = [2, 4];
  auto result = withoutMany(arr, toRemove);
  assert(result.equal([1, 3, 5]));

  // Test removing values not present
  int[] array2 = [5, 6, 7];
  int[] toRemove2 = [8, 9];
  auto result2 = withoutMany(array2, toRemove2);
  assert(result2.equal([5, 6, 7]));

  // Test with empty array
  int[] emptyArr;
  int[] toRemoveEmpty = [1, 2];
  auto resultEmpty = withoutMany(emptyArr, toRemoveEmpty);
  assert(resultEmpty.length == 0);

  // Test with empty toRemove array
  int[] arr3 = [1, 2, 3];
  int[] toRemove3;
  auto result3 = withoutMany(arr3, toRemove3);
  assert(result3.equal([1, 2, 3]));

  // Test with string array
  string[] arrStr = ["a", "b", "c", "b", "d"];
  string[] toRemoveStr = ["b", "d"];
  auto resultStr = withoutMany(arrStr, toRemoveStr);
  assert(resultStr.equal(["a", "c"]));

  // Test with all elements to remove
  int[] arrAll = [2, 2, 2];
  int[] toRemoveAll = [2];
  auto resultAll = withoutMany(arrAll, toRemoveAll);
  assert(resultAll.length == 0);

  // Test with duplicate values in toRemove
  int[] arrDup = [1, 2, 3, 4, 5];
  int[] toRemoveDup = [2, 2, 4];
  auto resultDup = withoutMany(arrDup, toRemoveDup);
  assert(resultDup.equal([1, 3, 5]));
}
