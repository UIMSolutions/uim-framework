/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.endswith;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  Checks if all strings in the array end with the specified text.
  
  Params:
      values = The array of strings to check.
      text = The text to check for at the end of each string.
  
  Returns:
      true if all strings end with the specified text, false otherwise.
  */
bool allEndsWith(string[] values, string text) {
  if (text.length == 0 || values.length == 0) {
    return false;
  }

  return values.all!(value => endsWith(value, text));
}
///
unittest {
  auto testValues = ["filename.txt", "document.txt", "image.png"];

  assert(allEndsWith(testValues[0 .. 2], ".txt") == true);
  assert(allEndsWith(testValues, ".txt") == false);
  assert(anyEndsWith(testValues, ".png") == true);
  assert(anyEndsWith(testValues, ".pdf") == false);
}

/**
  Checks if any string in the array ends with the specified text.
  
  Params:
      values = The array of strings to check.
      text = The text to check for at the end of each string.
  
  Returns:
      true if any string ends with the specified text, false otherwise.
  */
bool anyEndsWith(string[] values, string text) {
  if (text.length == 0 || values.length == 0) {
    return false;
  }

  return values.any!(value => endsWith(value, text));
}
///
unittest {
  auto testValues = ["filename.txt", "document.txt", "image.png"];

  assert(allEndsWith(testValues[0 .. 2], ".txt") == true);
  assert(allEndsWith(testValues, ".txt") == false);
  assert(anyEndsWith(testValues, ".png") == true);
  assert(anyEndsWith(testValues, ".pdf") == false);
}