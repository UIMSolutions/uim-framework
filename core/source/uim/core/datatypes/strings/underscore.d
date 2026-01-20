/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.underscore;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  Converts dashes and spaces to underscores in the given text(s).
  
  Params:
      texts = The text(s) to convert.
  
  Returns:
      The converted text(s) with underscores.
  */
string[] underscore(string[] texts) {
  return texts.map!(text => text.underscore).array;
}
///
unittest {
  auto result = underscore(["hello-world", "foo bar"]);
  assert(result.length == 2);
  assert(result[0] == "hello_world");
  assert(result[1] == "foo_bar");
}

/**
  Converts dashes and spaces to underscores in the given text.
  
  Params:
      text = The text to convert.
  
  Returns:
      The converted text with underscores.
  */
string underscore(string text) {
  return delimit(std.string.replace(text, "-", "_"), "_");
}
///
unittest {
  assert(underscore("hello-world") == "hello_world");
  assert(underscore("foo bar") == "foo_bar");
}
