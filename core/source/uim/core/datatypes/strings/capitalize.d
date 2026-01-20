/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.capitalize;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Capitalizes the first character of each text in the given array of texts.
  *
  * Params:
  *   texts = The texts to capitalize.
  *
  * Returns:
  *   An array of texts with the first character capitalized.
  */
string[] capitalize(string[] texts) {
  return texts
    .map!(text => std.string.capitalize(text))
    .array;
}
///
unittest {
  auto result = capitalize(["hello", "world", "uim"]);
  assert(result.length == 3);
  assert(result[0] == "Hello");
  assert(result[1] == "World");
  assert(result[2] == "Uim");
}
