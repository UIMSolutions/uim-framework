module uim.core.containers.sequential.arrays.sub;

import uim.core;

mixin(ShowModule!());

@safe:

T[] sub(T)(T[] lhs, T rhs, bool multiple = false) {
  auto result = lhs.dup;
  if (multiple) {
    while (rhs.isIn(result))
      result = result.sub(rhs, false);
  } else
    foreach (i, value; result) {
      if (value == rhs) {
        result = result.remove(i);
        break;
      }
    }
  return result;
}
///
unittest {
  assert([1, 2, 3].sub(2) == [1, 3]);
  assert([1, 2, 3, 2].sub(2, true) == [1, 3]);
}

// sub(T)(T[] lhs, T[] rhs, bool multiple = false)
T[] sub(T)(T[] lhs, T[] rhs, bool multiple = false) {
  auto result = lhs.dup;
  rhs.each!(value => result = result.sub(value, multiple));
  return result;
}
/// 
unittest {
  assert([1, 2, 3].sub([2]) == [1, 3]);
  assert([1, 2, 3, 2].sub([2], true) == [1, 3]);
  assert([1, 2, 3, 2].sub([2, 3], true) == [1]);
  assert([1, 2, 3, 2, 3].sub([2, 3], true) == [1]);
}
// #endregion sub
