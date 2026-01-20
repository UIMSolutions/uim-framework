/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.startswith;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  Checks if all strings in the array start with the specified text.
  
  Params:
    values = The array of strings to check.
    text = The text to check for at the start of each string.
  
  Returns:
      True if all strings start with the specified text, false otherwise.
  */
bool allStartsWith(string[] values, string text) {
  if (text.length == 0 || values.length == 0) {
    return false;
  }

  return values.all!(value => startsWith(value, text));
}
///
unittest {
  auto testValues = ["apple_pie", "apple_crisp", "apple_sauce"];

  assert(allStartsWith(testValues[0 .. 2], "apple") == true);
  assert(allStartsWith(testValues, "apple") == true);
  assert(anyStartsWith(testValues, "apple") == true);
  assert(anyStartsWith(testValues, "banana") == false);
}

/**
  Checks if any string in the array starts with the specified text.
  
  Params:
    values = The array of strings to check.
    text = The text to check for at the start of each string.
  
  Returns:
      True if any string starts with the specified text, false otherwise.
  */
bool anyStartsWith(string[] values, string text) {
  if (text.length == 0 || values.length == 0) {
    return false;
  }

  return values.any!(value => startsWith(value, text));
}
///
unittest {
  auto testValues = ["apple_pie", "apple_crisp", "apple_sauce"];

  assert(allStartsWith(testValues[0 .. 2], "apple") == true);
  assert(allStartsWith(testValues, "apple") == true);
  assert(anyStartsWith(testValues, "apple") == true);
  assert(anyStartsWith(testValues, "banana") == false);
}
