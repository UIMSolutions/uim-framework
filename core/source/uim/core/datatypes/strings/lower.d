/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.lower;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Converts all characters in the given texts to lower case.
  *
  * Params:
  *   texts = The texts to convert to lower case.
  *
  * Returns:
  *   An array of texts converted to lower case.
  */
string[] lower(string[] texts) {
  return texts
    .map!(text => text.toLower)
    .array;
}
///
unittest {
  auto result = lower(["Hello World", "FOO bar", "MiXeD CaSe"]);
  assert(result.length == 3);
  assert(result[0] == "hello world");
  assert(result[1] == "foo bar");     
  assert(result[2] == "mixed case");
}

/** 
  * Converts all characters in the given text to lower case.
  *
  * Params:
  *   text = The text to convert to lower case.
  *
  * Returns:
  *   The text converted to lower case.
  */
string lower(string text) {
  return text.toLower;
}
///
unittest {
  assert(lower("Hello World") == "hello world");
  assert(lower("FOO bar") == "foo bar");
  assert(lower("MiXeD CaSe") == "mixed case");
}