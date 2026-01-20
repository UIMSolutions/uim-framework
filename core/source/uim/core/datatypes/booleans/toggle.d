module uim.core.datatypes.booleans.toggle;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  * Toggles each boolean value in the given array.
  *
  * Params:
  *   values = An array of boolean values to toggle.
  *
  * Returns:
  *   A new array with each boolean value toggled.
**/
bool[] toggle(bool[] values) {
  return values.map!(v => !v).array;
}

/**
  * Toggles a single boolean value.
  *
  * Params:
  *   value = The boolean value to toggle.
  *
  * Returns:
  *   The toggled boolean value.
**/
bool toggle(bool value) {
  return !value;
}
///
unittest {
  mixin(ShowTest!"Testing toggle function");

  auto boolArray = [true, false, true, true, false];
  auto toggledArray = boolArray.toggle();
  assert(toggledArray.length == boolArray.length);
  assert(toggledArray[0] == false);
  assert(toggledArray[1] == true);
  assert(toggledArray[2] == false);
  assert(toggledArray[3] == false);
  assert(toggledArray[4] == true);

  assert(toggle(true) == false);
  assert(toggle(false) == true);
}
