/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.humanize;

import uim.core;

mixin(ShowModule!());

@safe:

/**
  * Humanizes the given texts by replacing the specified delimiter with spaces and capitalizing each word.
  *
  * Params:
  *   texts = An array of strings to be humanized.
  *   delimiter = The delimiter used in the input strings (default is "_").
  *
  * Returns:
  *   An array of humanized strings.
  */
string[] humanize(string[] texts) {
  return texts.map!(text => humanize(text)).array;
}
///
unittest {
  auto result = ["hello_world", "foo-bar", "multipleDelimitersHere"].humanize;
  assert(result.length == 3);
  assert(result[0] == "Hello world");
  assert(result[1] == "Foo bar");
  assert(result[2] == "Multiple delimiters here");
}

/**
  * Humanizes the given text by replacing the specified delimiter with spaces and capitalizing each word.
  *
  * Params:
  *   text = The string to be humanized.
  *   delimiter = The delimiter used in the input string (default is "_").
  *
  * Returns:
  *   The humanized string.
  */
string humanize(string text) {
  if (text.empty)
    return "";

  // 1. Remove '_id' or '-id' suffixes
  if (text.endsWith("_id"))
    text = text[0 .. $ - 3];
  else if (text.endsWith("-id"))
    text = text[0 .. $ - 3];

  auto app = appender!string();
  bool isFirst = true;

  foreach (i, c; text) {
    // 2. Handle word boundaries (separators or camelCase)
    if (c == '_' || c == '-') {
      app.put(' ');
    } else if (i > 0 && isUpper(c) && !isUpper(text[i - 1])) {
      // Inserts a space before capital letters in camelCase strings
      app.put(' ');
      app.put(toLower(c));
    } else {
      // 3. Capitalize first letter, lowercase the rest
      if (isFirst) {
        app.put(toUpper(c));
        isFirst = false;
      } else {
        app.put(toLower(c));
      }
    }
  }

  // 4. Final cleaning: collapse multiple spaces if they exist
  return app.data.split.join(" ");
}
///
unittest {
  assert("hello_world".humanize == "Hello world");
  assert("foo-bar".humanize == "Foo bar");
  assert("multipleDelimitersHere".humanize == "Multiple delimiters here");
  assert("user_id".humanize == "User");
  assert("account-id".humanize == "Account");
}
