/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.containers.sequential.arrays.compact;

import uim.core;

mixin(ShowModule!());
@safe:

/** 
    Compacts an array by removing all `null` elements.

    Params:
        arr = The array to compact.

    Returns:
        A new array with all `null` elements removed.

    Example:
    ```d
    import uim.core.containers.sequential.arrays.compact : compact;

    auto arr = [1, null, 2, null, 3];
    auto compactedArr = compact(arr); // Result: [1, 2, 3]
    ```

    Note:
        This function works for arrays of reference types where `null` is a valid value.
*/
auto compact(T)(T[] arr) {
  return arr.filter!(x => x !is null).array;
}
///
unittest {
  version (show_test) writeln("Testing compact function");

  /* 
  auto arr = [1, null, 2, null, 3];
  auto compactedArr = compact(arr);
  assert(compactedArr.length == 3);
  assert(compactedArr[0] == 1);
  assert(compactedArr[1] == 2);
  assert(compactedArr[2] == 3);
  */
}
