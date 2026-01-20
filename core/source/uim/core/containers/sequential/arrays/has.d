/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.has;

import uim.core;

mixin(ShowModule!());

@safe:

/*
bool hasAll(T)(T[] values, in T[] checkValues...) {
  return values.hasAll(checkValues.dup);
}
///
unittest {
  // Test hasAll
  int[] arrInt = [1, 2, 3, 4, 5];
  assert(arrInt.hasAll(2, 3));
  assert(!arrInt.hasAll(2, 6));

  string[] arrStr = ["apple", "banana", "cherry"];
  assert(arrStr.hasAll("banana", "cherry"));
  assert(!arrStr.hasAll("banana", "date"));
}

/**
 * Checks if all specified values exist within the provided array.
 *
 * Params:
 *   values  = The array to search.
 *   checkValues = The values to look for in the array.
 *
 * Returns:
 *   `true` if all values are found in the array, `false` otherwise.
 */
bool hasAll(T)(T[] values, in T[] checkValues) {
  return checkValues.all!(value => values.canFind(value));
}
///
unittest {
  // Test hasAll
  int[] arrInt = [1, 2, 3, 4, 5];
  assert(arrInt.hasAll([2, 3]));
  assert(!arrInt.hasAll([2, 6]));

  string[] arrStr = ["apple", "banana", "cherry"];
  assert(arrStr.hasAll(["banana", "cherry"]));
  assert(!arrStr.hasAll(["banana", "date"]));
}

/**
 * Checks if any of the specified values exist within the provided array.
 *
 * Params:
 *   values  = The array to search.
 *   checkValues = The values to look for in the array.
 *
 * Returns:
 *   `true` if any value is found in the array, `false` otherwise.
 */
bool hasAny(T)(T[] values, in T[] checkValues) {
  return checkValues.any!(value => values.canFind(value));
}
///
unittest {
  int[] arrInt = [1, 2, 3, 4, 5];
  
  // Test hasAny
  assert(arrInt.hasAny([0, 3, 6]));
  assert(!arrInt.hasAny([0, 6]));

  // Test with string array
  string[] arrStr = ["apple", "banana", "cherry"];
  assert(arrStr.hasAny(["date", "cherry"]));
  assert(!arrStr.hasAny(["date", "fig"]));
}

bool hasAny(T)(T[] values, in T[] checkValues...) {
  return checkValues.any!(value => values.canFind(value));
}

unittest {
  int[] arrInt = [1, 2, 3, 4, 5];
  
  // Test hasAny
  assert(arrInt.hasAny(0, 3, 6));
  assert(!arrInt.hasAny(0, 6));

  // Test with string array
  string[] arrStr = ["apple", "banana", "cherry"];
  assert(arrStr.hasAny("date", "cherry"));
  assert(!arrStr.hasAny("date", "fig"));
}

// #region Values
/**
  * Checks if all specified values exist within the provided array.
  *
  * Params:
  *   values  = The array to search.
  *   checkValues = The values to look for in the array.
  *
  * Returns:
  *   `true` if all values are found in the array, `false` otherwise.
  */
bool hasAllValue(T)(T[] values, T[] checkValues) {
  return checkValues.all!(v => values.hasValue(v));
}
///
unittest {
  // Test hasAllValue
  int[] arrInt = [1, 2, 3, 4, 5];
  assert(arrInt.hasAllValue([2, 3]));
  assert(!arrInt.hasAllValue([2, 6]));

  // Test with string array
  string[] arrStr = ["apple", "banana", "cherry"];
  assert(arrStr.hasAllValue(["banana", "cherry"]));
  assert(!arrStr.hasAllValue(["banana", "date"]));
}

/** 
  * Checks if any of the specified values exist within the provided array.
  *
  * Params:
  *   values  = The array to search.
  *   checkValues = The values to look for in the array.
  *
  * Returns:
  *   `true` if any value is found in the array, `false` otherwise.
  */
bool hasAnyValue(T)(T[] values, T[] checkValues) {
  return checkValues.any!(v => values.hasValue(v));
}
///
unittest {
  int[] arrInt = [1, 2, 3, 4, 5];
  
  // Test hasAllValue
  assert(arrInt.hasAllValue([2, 3]));
  assert(!arrInt.hasAllValue([2, 6]));

  // Test hasAnyValue
  assert(arrInt.hasAnyValue([0, 3, 6]));
  assert(!arrInt.hasAnyValue([0, 6]));

  // Test with string array
  string[] arrStr = ["apple", "banana", "cherry"];
  assert(arrStr.hasAllValue(["banana", "cherry"]));
  assert(!arrStr.hasAllValue(["banana", "date"]));
  assert(arrStr.hasAnyValue(["date", "cherry"]));
  assert(!arrStr.hasAnyValue(["date", "fig"]));
}
/** 
  * Checks if the specified value exists within the provided array.
  *
  * Params:
  *   values  = The array to search.
  *   checkValue = The value to look for in the array.
  *
  * Returns:
  *   `true` if the value is found in the array, `false` otherwise.
  */
bool hasValue(T)(T[] values, T checkValue) {
  return values.any!(v => v == checkValue);
}
///
unittest {
  // Test with int array
  int[] arrInt = [1, 2, 3, 4, 5];
  assert(hasValue(arrInt, 3));
  assert(!hasValue(arrInt, 6));
  // Test with string array
  string[] arrStr = ["apple", "banana", "cherry"];
  assert(hasValue(arrStr, "banana"));
  assert(!hasValue(arrStr, "date"));

  // Test with empty array
  int[] emptyArr;
  assert(!hasValue(emptyArr, 1));

  // Test with custom type
  struct Point {
    int x, y;
  }

  Point[] points = [Point(1, 2), Point(3, 4)];
  assert(hasValue(points, Point(1, 2)));
  assert(!hasValue(points, Point(5, 6)));
}
// #endregion Values

