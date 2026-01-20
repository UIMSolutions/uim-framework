/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.replace;

import uim.core;

mixin(ShowModule!());
@safe:

/* 
auto replace(T)(T[] arr, T oldValue, T newValue) {
  return arr.map!(x => x == oldValue ? newValue : x).array;
}
*/

/**
  * Replaces all occurrences of `oldValue` in the array with `newValue`.
  *
  * Params:
  *   values = The array to modify.
  *   oldValues = The value to replace.
  *   newValue = The value to insert in place of `oldValue`.
  *
  * Returns:
  *   A new array with the replacements made.
  */
auto replaceAll(T)(T[] values, T[] oldValues, T newValue) {
  return (values is null || oldValues is null || oldValues.length == 0)
   ? values
   : values.map!(value => (oldValues.canFind(value)) ? newValue : value).array;
}
///
unittest {
  // Test: replaceAll with single oldValue
  int[] arr = [1, 2, 3, 2, 4, 2];
  int[] oldVals = [2];
  auto result = arr.replaceAll(oldVals, 99);
  assert(result == [1, 99, 3, 99, 4, 99]);

  // Test: replaceAll with multiple oldValues
  int[] oldVals2 = [2, 4];
  auto result2 = arr.replaceAll(oldVals2, 77);
  assert(result2.equal([1, 77, 3, 77, 77, 77]));

  // Test: replaceAll with no oldValues (should not replace anything)
  int[] oldVals3 = null;
  auto result3 = arr.replaceAll(oldVals3, 42);
  assert(result3.equal([1, 2, 3, 2, 4, 2]));

  // Test: replaceAll with all elements as oldValues (should replace all)
  int[] oldVals4 = [1, 2, 3, 4];
  auto result4 = arr.replaceAll(oldVals4, 0);
  assert(result4.equal([0, 0, 0, 0, 0, 0]));

  // Test: replaceAll with empty array
  int[] emptyArr = null;
  auto result5 = arr.replaceAll(emptyArr, 123);
  assert(result5.equal(arr));

  // Test: replaceAll with custom type
  struct S {
    int a;
  }

  S[] sArr = [S(1), S(2), S(3), S(2)];
  S[] oldSArr = [S(2)];
  auto result6 = replaceAll(sArr, oldSArr, S(99));
  assert(result6[0].a == 1 && result6[1].a == 99 && result6[2].a == 3 && result6[3].a == 99);

  // Test: replaceAll with custom type, multiple oldValues
  S[] oldSarray2 = [S(1), S(3)];
  auto result7 = replaceAll(sArr, oldSarray2, S(42));
  assert(result7[0].a == 42 && result7[1].a == 2 && result7[2].a == 42 && result7[3].a == 2);
}

/**
  * Replaces all elements in the array that satisfy the given predicate with `newValue`.
  *
  * Params:
  *   values = The array to modify.
  *   predicate = A delegate that returns true for elements to be replaced.
  *   newValue = The value to insert in place of elements satisfying the predicate.
  *
  * Returns:
  *   A new array with the replacements made.
  */
auto replaceIf(T)(T[] values, bool delegate(T) @safe predicate, T newValue) {
  return values.replaceAll(values.filter!(x => predicate(x)).array, newValue);
}
/// 
unittest {
  // Test: replaceIf with even numbers
  int[] arr = [1, 2, 3, 4, 5];
  auto result = arr.replaceIf((int x) => x % 2 == 0, 99);
  assert(result.equal([1, 99, 3, 99, 5]));

  // Test: replaceIf with odd numbers
  auto result2 = arr.replaceIf((int x) => x % 2 != 0, 77);
  assert(result2.equal([77, 2, 77, 4, 77]));

  // Test: replaceIf with all elements (always true)
  auto result3 = arr.replaceIf((int x) => true, 42);
  assert(result3.equal([42, 42, 42, 42, 42]));

  // Test: replaceIf with no elements (always false)
  auto result4 = arr.replaceIf((int x) => false, 0);
  assert(result4.equal([1, 2, 3, 4, 5]));

  // Test: replaceIf with empty array
  int[] emptyArr;
  auto result5 = emptyArr.replaceIf((int x) => true, 123);
  assert(result5 is null);

  // Test: replaceIf with custom type
  struct S {
    int a;
  }

  S[] sArr = [S(1), S(2), S(3)];
  auto result6 = sArr.replaceIf((S x) => x.a == 2, S(99));
  assert(result6[0].a == 1 && result6[1].a == 99 && result6[2].a == 3);
}

T[] replaceFirst(T)(T[] values, T searchValue, T newValue) {
  T[] result;
  bool replaced = false;
  foreach (value; values) {
    if (!replaced && value == searchValue) {
      result ~= newValue;
      replaced = true;
    } else {
      result ~= value;
    }
  }
  return result;
}
/// 
unittest {
  version (show_test) writeln("Testing replaceFirst function");

  auto arr = [1, 2, 3, 2, 4];
  auto result = replaceFirst(arr, 2, 99);
  assert(result == [1, 99, 3, 2, 4]);

  auto result2 = replaceFirst(arr, 5, 77); // value not found
  assert(result2 == arr);

  auto arr2 = ["a", "b", "c", "b"];
  auto result3 = replaceFirst(arr2, "b", "z");
  assert(result3 == ["a", "z", "c", "b"]);
}

T[] replaceLast(T)(T[] values, T searchValue, T newValue) {
  T[] result;
  bool replaced = false;
  foreach (value; values.reverse) {
    if (!replaced && value == searchValue) {
      result ~= newValue;
      replaced = true;
    } else {
      result ~= value;
    }
  }
  return result.reverse;
}
/// 
unittest {
  version (show_test) writeln("Testing replaceLast function");

  auto arr = [1, 2, 3, 2, 4];
  auto result = replaceLast(arr, 2, 99);
  assert(result == [1, 2, 3, 99, 4]);
}