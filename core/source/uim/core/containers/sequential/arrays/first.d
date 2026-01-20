/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.first;

import uim.core;

mixin(ShowModule!());
@safe:

// #region firstPosition
/**
  * Returns the index of the first occurrence of `matchValue` in the array.
  * If `matchValue` is not found, returns -1.
  * 
  * Params:
  *   values = The array to search through.
  *   matchValue = The value to search for.
  * 
  * Returns:
  *   The index of the first occurrence of `matchValue`, or -1 if not found.
*/
size_t firstPosition(T)(T[] values, T matchValue) {
  return values.firstPosition((T item) => item == matchValue);
}
///
unittest {
  // Test: firstPosition with existing value
  int[] array1 = [10, 20, 30, 40, 50];
  assert(array1.firstPosition(30) == 2);

  // Test: firstPosition with non-existing value
  int[] array2 = [1, 2, 3, 4, 5];
  assert(array2.firstPosition(10) == -1);

  // Test: firstPosition with strings
  string[] array3 = ["apple", "banana", "cherry"];
  assert(array3.firstPosition("banana") == 1);
}

/** 
  * Returns the index of the first element in the array that satisfies the provided delegate function.
  * If no element satisfies the function, returns -1.
  * 
  * Params:
  *   values = The array to search through.
  *   matchFunc = A delegate function that takes an element and returns a boolean indicating if it matches the condition.
  * 
  * Returns:
  *   The index of the first element that satisfies the condition, or -1 if none do.
  */
size_t firstPosition(T)(T[] values, bool delegate(T) @safe matchFunc) {
  foreach (index, item; values)
    if (matchFunc(item))
      return index;
  return -1;
}
///
unittest {
  // Test: firstPosition with a condition that matches an element
  int[] array1 = [10, 20, 30, 40, 50];
  assert(array1.firstPosition((int value) => value == 30) == 2);

  // Test: firstPosition with no matching elements
  int[] array2 = [1, 2, 3, 4, 5];
  assert(array2.firstPosition((int value) => value == 10) == -1);

  // Test: firstPosition with strings
  string[] array3 = ["apple", "banana", "cherry"];
  assert(array3.firstPosition((string value) => value == "banana") == 1);
}
// #endregion firstPosition

// #region first(Value)
/** 
  * Returns the first element of the array or a Null!T if the array is empty.
  * 
  * Params:
  *   values = The array to get the first element from.
  * 
  * Returns:
  *   The first element of the array or a Null!T if the array is empty.
  */
T first(T)(T[] values) {
  return values.length > 0
    ? values[0] : Null!T;
}
///
unittest {
  // Test: first with non-empty int array
  int[] array1 = [42, 7, 13];
  assert(first(array1) == 42);

  // Test: first with empty int array
  int[] array2 = [];
  assert(first(array2) == Null!int);

  // Test: first with non-empty string array
  string[] array3 = ["hello", "world"];
  assert(first(array3) == "hello");

  // Test: first with empty string array
  string[] array4 = [];
  assert(first(array4) == Null!string);

  // Test: first with single-element array
  double[] array5 = [3.14];
  assert(first(array5) == 3.14);

  // Test: first with empty double array
  double[] array6 = [];
  assert(first(array6) == Null!double);
}
// #endregion first(Value)

// #region firstMany
/** 
  * Returns an array containing the first 'size' elements of the input array.
  * If the input array has fewer than 'size' elements, returns a duplicate of the entire array.
  * If the input array is empty, returns null.
  * 
  * Params:
  *   values = The array to extract elements from.
  *   numberOfValues = The number of elements to extract from the start of the array.
  * 
  * Returns:
  *   An array containing the first 'numberOfValues' elements, a duplicate of the entire array if it has fewer than 'numberOfValues' elements, or null if the array is empty.
  */
T[] firstMany(T)(T[] values, size_t numberOfValues) {
  if (values.length == 0) {
    return null;
  }

  return values.length > numberOfValues
    ? values[0 .. numberOfValues].dup : values.dup;
}
///
unittest {
  // Test: firstMany with size less than array length
  int[] array1 = [10, 20, 30, 40, 50];
  auto result1 = array1.firstMany(3);
  assert(result1.equal([10, 20, 30]));

  // Test: firstMany with size equal to array length
  int[] array2 = [1, 2, 3];
  auto result2 = array2.firstMany(3);
  assert(result2.equal([1, 2, 3]));

  // Test: firstMany with size greater than array length
  int[] array3 = [7, 8];
  auto result3 = array3.firstMany(5);
  assert(result3.equal([7, 8]));

  // Test: firstMany with empty array
  int[] array4 = [];
  auto result4 = array4.firstMany(2);
  assert(result4.isEmpty);

  // Test: firstMany with size zero
  int[] array5 = [1, 2, 3];
  auto result5 = array5.firstMany(0);
  assert(result5.isEmpty);

  // Test: firstMany with strings
  string[] array6 = ["a", "b", "c", "d"];
  auto result6 = array6.firstMany(2);
  assert(result6.equal(["a", "b"]));
}
// #endregion firstMany

// #region firstAny
/**
  * Returns an array of elements from the input array that are present in the anyValues array.
  * 
  * Params:
  *   values = The array to filter.
  *   anyValues = The array containing values to match against.
  * 
  * Returns:
  *   An array of elements from values that are also in anyValues.
  */
T[] firstAny(T)(T[] values, T[] anyValues) {
  return values.firstAny((T value) => anyValues.canFind(value));
}
///
unittest {
  // Test: firstAny with some matching values
  int[] values = [1, 2, 3, 4, 5];
  int[] anyValues = [2, 4, 6];
  auto result = firstAny(values, anyValues);
  assert(result.equal([2, 4]));

  // Test: firstAny with no matching values
  int[] values2 = [7, 8, 9];
  int[] anyValues2 = [1, 2, 3];
  auto result2 = firstAny(values2, anyValues2);
  assert(result2.length == 0);

  // Test: firstAny with all matching values
  int[] values3 = [1, 2, 3];
  int[] anyValues3 = [1, 2, 3];
  auto result3 = firstAny(values3, anyValues3);
  assert(result3.equal([1, 2, 3]));

  // Test: firstAny with empty values
  int[] values4 = [];
  int[] anyValues4 = [1, 2, 3];
  auto result4 = firstAny(values4, anyValues4);
  assert(result4.length == 0);

  // Test: firstAny with empty anyValues
  int[] values5 = [1, 2, 3];
  int[] anyValues5 = [];
  auto result5 = firstAny(values5, anyValues5);
  assert(result5.length == 0);

  // Test: firstAny with strings
  string[] values6 = ["apple", "banana", "cherry"];
  string[] anyValues6 = ["banana", "date"];
  auto result6 = firstAny(values6, anyValues6);
  assert(result6.equal(["banana"]));
}

/** 
  * Returns an array of elements from the input array that satisfy the provided delegate function.
  * 
  * Params:
  *   values = The array to filter.
  *   firstFunc = A delegate function that takes an element and returns a boolean indicating if it satisfies the condition.
  * 
  * Returns:
  *   An array of elements that satisfy the condition defined by firstFunc.
  */
T[] firstAny(T)(T[] values, bool delegate(T) @safe firstFunc) {
  return values.filter!(value => firstFunc(value)).array;
}
// #endregion firstAny

// #region first(Func)
/**
  * Returns the first element in the array that satisfies the provided delegate function.
  * If no element satisfies the function, returns the specified default value or T.init if not provided.
  * 
  * Params:
  *   values = The array to search through.
  *   firstFunc = A delegate function that takes an element and returns a boolean indicating if it satisfies the condition.
  *   defaultValue = The value to return if no element satisfies the condition (default is T.init).
  * 
  * Returns:
  *   The first element that satisfies the condition or the default value if none do.
  */
T first(T)(T[] values, bool delegate(T) @safe firstFunc, T defaultValue = T.init) {
  foreach (item; values) {
    if (firstFunc(item)) {
      return item;
    }
  }
  return defaultValue;
}
///
unittest {
  // Test: first with a condition that matches an element
  int[] array1 = [1, 2, 3, 4, 5];
  assert(array1.first((int value) => value % 2 == 0) == 2);

  // Test: first with strings
  string[] array3 = ["apple", "banana", "cherry"];
  assert(array3.first((string value) => value.startsWith("b")) == "banana");

  // Test: first with no matching elements and default value
  string[] array4 = ["apple", "cherry"];
  assert(array4.first((string value) => value.startsWith("b"), "none") == "none");
}
// #endregion first(Func)
