/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.upper;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Converts all characters in the given texts to upper case.
  *
  * Params:
  *   texts = The texts to convert to upper case.
  *
  * Returns:
  *   An array of texts converted to upper case.
  */
string[] upper(string[] texts) {
  return texts
    .map!(text => text.toUpper)
    .array;
}
///
unittest {
  auto result = ["Hello World", "foo BAR", "MiXeD CaSe"].upper;
  assert(result.length == 3);
  assert(result[0] == "HELLO WORLD");
  assert(result[1] == "FOO BAR");     
  assert(result[2] == "MIXED CASE");  
}

/**
  * Converts all characters in the given text to upper case.
  *
  * Params:
  *   text = The text to convert to upper case.
  *
  * Returns:
  *   The text converted to upper case.
  */
string upper(string text) {
  return text.toUpper;
}
///
unittest {
  assert("Hello World".upper == "HELLO WORLD");
  assert("foo BAR".upper == "FOO BAR");
  assert("MiXeD CaSe".upper == "MIXED CASE");
}