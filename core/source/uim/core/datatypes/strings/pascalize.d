/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.pascalize;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  * Pascalizes the given array of texts by removing the specified delimiter and capitalizing the first letter of each word.
  *
  * Params:
  *   texts = An array of texts to pascalize.
  *   delimiter = The delimiter used to separate words in the input texts. Default is "_".
  *
  * Returns:
  *   An array of pascalized texts.
  */
string[] pascalize(string[] texts, string delimiter = "_") {
  return texts.map!(text => text.pascalize(delimiter)).array;
}
///
unittest {
  auto result = pascalize(["hello_world", "foo_bar"], "_");
  assert(result.length == 2);
  assert(result[0] == "HelloWorld");
  assert(result[1] == "FooBar");
}

/**
  * Pascalizes the given text by removing the specified delimiter and capitalizing the first letter of each word.
  *
  * Params:
  *   text = The text to pascalize.
  *   delimiter = The delimiter used to separate words in the input text. Default is "_".
  *
  * Returns:
  *   The pascalized text.
  */
string pascalize(string text, string delimiter = "_") {
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

  return words.map!(word => word.capitalize()).join("");
}
///
unittest {
  assert(pascalize("hello_world", "_") == "HelloWorld");
  assert(pascalize("foo-bar", "-") == "FooBar");
  assert(pascalize("multiple delimiters here", " ") == "MultipleDelimitersHere");
}
