/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.pairs;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  Combines two arrays into an array of pairs (tuples), where each pair consists of one element from the keys array and one from the values array.
  
  Params:
      keys = The array of keys.
      values = The array of values.
  
  Returns:
      An array of tuples, where each tuple contains a key and its corresponding value. The length of the resulting array is the minimum of the lengths of the input arrays.
  
  Example:
      auto keys = [1, 2, 3];
      auto values = ["a", "b", "c"];
      auto result = pairs(keys, values); // result is [(1, "a"), (2, "b"), (3, "c")]
  
  Note:
      If either input array is empty, the result will be an empty array.
  */
auto pairs(K, V)(K[] keys, V[] values) {
  auto minLength = min(keys.length, values.length);
  return keys.take(minLength).zip(values.take(minLength)).array;
}
/// 
unittest {
  // Test: pairs with equal length arrays
  int[] keys1 = [1, 2, 3];
  string[] values1 = ["a", "b", "c"];
  auto res1 = pairs(keys1, values1);
  // TODO assert(res1.equal([(1, "a"), (2, "b"), (3, "c")]));

  // Test: pairs with keys longer than values
  int[] keys2 = [1, 2, 3, 4];
  string[] values2 = ["a", "b"];
  auto res2 = pairs(keys2, values2);
  // TODO assert(res2.equal([(1, "a"), (2, "b")]));

  // Test: pairs with values longer than keys
  int[] keys3 = [1];
  string[] values3 = ["a", "b", "c"];
  auto res3 = pairs(keys3, values3);
  // TODO assert(res3.equal([(1, "a")]));

  // Test: pairs with empty keys
  int[] keys4 = [];
  string[] values4 = ["a", "b", "c"];
  auto res4 = pairs(keys4, values4);
  // TODO assert(res4.isEmpty);

  // Test: pairs with empty values
  int[] keys5 = [1, 2, 3];
  string[] values5 = [];
  auto res5 = pairs(keys5, values5);
  // TODO assert(res5.isEmpty);
}
