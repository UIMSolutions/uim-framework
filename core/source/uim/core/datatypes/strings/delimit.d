/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.delimit;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  Converts dashes and spaces to the specified delimiter in the given text(s).
  
  Params:
      texts = The text(s) to convert.
      delimiter = The delimiter to use (default is underscore).
  
  Returns:
      The converted text(s) with the specified delimiter.
  */
string[] delimit(string[] texts, string delimiter = "_") pure {
  return texts.map!(text => text.delimit(delimiter)).array;
}
///
unittest {
  auto result = delimit(["hello-world", "foo bar"], "_");
  assert(result.length == 2);
  assert(result[0] == "hello_world");
  assert(result[1] == "foo_bar");
}

/** 
  Converts dashes and spaces to the specified delimiter in the given text.
  
  Params:
      text = The text to convert.
      delimiter = The delimiter to use (default is underscore).
  
  Returns:
      The converted text with the specified delimiter.
  */
string delimit(string text, string delimiter = "_") pure {
  string result = std.string.replace(text, "-", delimiter);
  result = std.string.replace(result, " ", delimiter);
  return result;
}
///
unittest {
  assert(delimit("hello-world", "_") == "hello_world");
  assert(delimit("foo bar", "-") == "foo-bar");
}
