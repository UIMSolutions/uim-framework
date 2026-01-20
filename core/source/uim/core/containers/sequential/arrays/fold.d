/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.fold;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Folds an array from the left using a binary function.
  *
  * Params:
  *   values = The input array to be folded.
  *   initial = The initial accumulator value.
  *   foldFunc = A binary function that takes the current accumulator and an element, returning the new accumulator.
  *
  * Returns:
  *   The final accumulated value after folding the array.
  */
U foldLeft(T, U)(T[] values, U initial, U delegate(U, T) @safe foldFunc) {
  U accumulator = initial;
  foreach (item; values) {
    accumulator = foldFunc(accumulator, item);
  }
  return accumulator;
}
///
unittest {
  auto sum = foldLeft([1, 2, 3, 4], 0, (int acc, int item) => acc + item);
  assert(sum == 10);

  auto product = foldLeft([1, 2, 3, 4], 1, (int acc, int item) => acc * item);
  assert(product == 24);

  auto dif = foldLeft(["1", "2", "3", "4"], "1", (string acc,  string item) => acc ~ item);
  assert(dif == "11234");
}

/** 
  * Folds an array from the left using a binary function.
  *
  * Params:
  *   values = The input array to be folded.
  *   initial = The initial accumulator value.
  *   foldFunc = A binary function that takes the current accumulator and an element, returning the new accumulator.
  *
  * Returns:
  *   The final accumulated value after folding the array.
  */
U foldRight(T, U)(T[] values, U initial, U delegate(U, T) @safe foldFunc) {
  U accumulator = initial;
  foreach_reverse (item; values) {
    accumulator = foldFunc(accumulator, item);
  }
  return accumulator;
}
///
unittest {
  auto sum = foldRight([1, 2, 3, 4], 0, (int acc,  int item) => acc + item);
  assert(sum == 10);

  auto product = foldRight([1, 2, 3, 4], 1, (int acc,  int item) => acc * item);
  assert(product == 24);

  auto dif = foldRight(["1", "2", "3", "4"], "1", (string acc,  string item) => acc ~ item);
  assert(dif == "14321");
}
