/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.camelize;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  * Camelizes the given array of texts by removing the specified delimiter and capitalizing the first letter of each word.
  *
  * Params:
  *   texts = An array of texts to camelize.
  *   delimiter = The delimiter used to separate words in the input texts. Default is "_".
  *
  * Returns:
  *   An array of camelized texts.
  */
string[] camelize(string[] texts, string delimiter = "_") {
  return texts.map!(text => text.camelize(delimiter)).array;
}
///
unittest {
  auto result = camelize(["hello_world", "foo_bar"], "_");
  assert(result.length == 2);
  assert(result[0] == "helloWorld");
  assert(result[1] == "fooBar");
}

/**
  * Camelizes the given text by removing the specified delimiter and capitalizing the first letter of each word.
  *
  * Params:
  *   text = The text to camelize.
  *   delimiter = The delimiter used to separate words in the input text. Default is "_".
  *
  * Returns:
  *   The camelized text.
  */
string camelize(string text, string delimiter = "_") {
  // Handle empty string case
  if (text.length == 0) { 
    return "";
  }

  // 1. Split the string by common delimiters
  // Can be refined to handle multiple delimiters at once if needed
  auto words = text.split!(c => c == '_' || c == '-' || c == ' ');
  if (words.length == 0) {
    return "";
  }

  // 2. Start with the first word in lowercase
  string part1  = words[0].toLower();

  // 3. Capitalize subsequent words and append
  string part2 = words.length > 1 ? words[1 .. $].map!(word => word.capitalize()).join("") : "";

  return  part1 ~ part2;
}
///
unittest {
  assert(camelize("hello_world", "_") == "helloWorld");
  assert(camelize("foo-bar", "-") == "fooBar");
  assert(camelize("multiple delimiters here", " ") == "multipleDelimitersHere");
}
