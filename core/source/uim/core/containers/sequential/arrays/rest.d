/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.rest;

import uim.core;

mixin(ShowModule!());
@safe:

auto rest(T)(T[] values...) {
  return test(values.dup);
}

/**
  Returns the tail of the array (all elements except the first).
  
  Params:
    values = The array whose tail is to be determined.
  
  Returns:
    The tail of the array, or null if the array has no elements.
  */
auto rest(T)(T[] values) {
  return values.length > 1 
    ? values[1 .. $]
    : null;
}
///
unittest {
  assert([2, 3, 4] == [1, 2, 3, 4].rest);
  assert([2.0, 3.0, 4.0] == [1.0, 2.0, 3.0, 4.0].rest);
  assert(["b", "c", "d"] == ["a", "b", "c", "d"].rest);

  assert(null == [1].rest);
  assert(null == [1.0].rest);
  assert(null == ["a"].rest);

  assert(null == [].rest);
}