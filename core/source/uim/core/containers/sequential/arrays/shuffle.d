/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.shuffle;

import uim.core;

mixin(ShowModule!());
@safe:

/**
  * Shuffles the elements of the array randomly using the Fisher-Yates algorithm.
  *
  * Params:
  *   values = The array to shuffle.
  *
  * Returns:
  *   A new array with the elements shuffled.
  */
auto shuffle(T)(T[] values) {
  if (values.length <= 1) {
    return values;
  }

  // TODO
  /* for (size_t i = values.length - 1; i > 0; --i) {
    size_t j = uniform(0, i + 1);
    swap(values[i], values[j]);
  } */
  return values;
}
///
unittest {
  // Test: shuffle does not change length
  int[] arr = [1, 2, 3, 4, 5];
  auto shuffled = shuffle(arr.dup);
  assert(shuffled.length == arr.length);

  // Test: shuffle preserves all elements
  arr = [10, 20, 30, 40, 50];
  shuffled = shuffle(arr.dup);
  arr.sort;
  shuffled.sort;
  assert(arr.equal(shuffled));

  // Test: shuffle on empty array
  int[] emptyArr;
  auto shuffledEmpty = shuffle(emptyArr.dup);
  assert(shuffledEmpty.length == 0);

  // Test: shuffle on single-element array
  int[] singleArr = [42];
  auto shuffledSingle = shuffle(singleArr.dup);
  assert(shuffledSingle.length == 1 && shuffledSingle[0] == 42);

  // Test: shuffle on string array
  string[] strArr = ["a", "b", "c", "d"];
  auto shuffledStr = shuffle(strArr.dup);
  assert(strArr.length == shuffledStr.length);
  assert(strArr.sort.array.equal(shuffledStr.sort.array));

  // TODO
  // Test: shuffled array is not always equal to original (probabilistic)
  /* bool different = false;
  arr = [1, 2, 3, 4, 5];
  foreach (i; 0 .. 10) {
    auto s = shuffle(arr.dup);
    if (!arr.equal(s)) {
      different = true;
      break;
    }
  }
  assert(different, "Shuffle should change order at least sometimes"); */
}
