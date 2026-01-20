/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.strings.striptext;

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
string[] stripText(string[] texts, string[] stripchars = null) {
  return texts
    .map!(text => stripText(text, stripchars))
    .array;
}
///
unittest {
  auto results = ["  foo  ", "--bar--", "..baz.."].stripText([" ", "-", "."]);
  assert(results.length == 3);
  assert(results[0] == "foo");
  assert(results[1] == "bar");
  assert(results[2] == "baz");
}

/**
  * Strips the specified characters from both ends of the given text.
  *
  * Params:
  *   text = The text to strip.
  *   stripchars = The characters to strip. If null or empty, whitespace is stripped.
  *
  * Returns:
  *   The stripped text.
  */
string stripText(string text, string[] stripchars = null) {
  if (text.length == 0) {
    return text;
  }

  if (stripchars.length == 0) {
    return text.strip;
  }

  foreach (c; stripchars) {
    text = text.strip(c);
  }

  return text;
}
///
unittest {
  assert("  hello  ".stripText == "hello");
  assert("--hello--".stripText(["-"]) == "hello");
  assert("..hello..".stripText(["."]) == "hello");
  assert("..--hello--..".stripText([".", "-"]) == "hello");
}

/** 
  * Strips the specified characters from the left side of the given texts.
  *
  * Params:
  *   texts = The texts to strip.
  *   stripchars = The characters to strip. If null or empty, whitespace is stripped.
  *
  * Returns:
  *   An array of stripped texts.
  */
string[] stripTextLeft(string[] texts, string[] stripchars = null) {
  return texts
    .map!(text => stripTextLeft(text, stripchars))
    .array;
}
///
unittest {
  auto results = ["  foo  ", "--bar--", "..baz.."].stripTextLeft([" ", "-", "."]);
  assert(results.length == 3);
  assert(results[0] == "foo  ");
  assert(results[1] == "bar--");
  assert(results[2] == "baz..");
}

/** 
  * Strips the specified characters from the left side of the given text.
  *
  * Params:
  *   text = The text to strip.
  *   stripchars = The characters to strip. If null or empty, whitespace is stripped.
  *
  * Returns:
  *   The stripped text.
  */
string stripTextLeft(string text, string[] stripchars = null) {
  if (text.isEmpty) {
    return null;
  }
  if (stripchars.isEmpty) {
    return stripLeft(text);
  }
  foreach (c; stripchars) {
    text = stripLeft(text, c);
  }
  return text;
}
///
unittest {
  assert("  hello  ".stripTextLeft == "hello  ");
  assert("--hello--".stripTextLeft(["-"]) == "hello--");
  assert("..hello..".stripTextLeft(["."]) == "hello..");
  assert("..--hello--..".stripTextLeft([".", "-"]) == "hello--..");
}

/** 
  * Strips the specified characters from the right side of the given texts.
  *
  * Params:
  *   texts = The texts to strip.
  *   stripchars = The characters to strip. If null or empty, whitespace is stripped.
  *
  * Returns:
  *   An array of stripped texts.
  */
string[] stripTextRight(string[] texts, string[] stripchars = null) {
  return texts
    .map!(text => stripTextRight(text, stripchars))
    .array;
}
///
unittest {
  auto results = ["  foo  ", "--bar--", "..baz.."].stripTextRight([" ", "-", "."]);
  assert(results.length == 3);
  assert(results[0] == "  foo");
  assert(results[1] == "--bar");
  assert(results[2] == "..baz");
}

/** 
  * Strips the specified characters from the right side of the given text.
  *
  * Params:
  *   text = The text to strip.
  *   stripchars = The characters to strip. If null or empty, whitespace is stripped.
  *
  * Returns:
  *   The stripped text.
  */
string stripTextRight(string text, string[] stripchars = null) {
  if (text.isEmpty) {
    return null;
  }
  if (stripchars.isEmpty) {
    return stripRight(text);
  }
  foreach (c; stripchars) {
    text = stripRight(text, c);
  }
  return text;
}
///
unittest {
  assert("  hello  ".stripTextRight == "  hello");
  assert("--hello--".stripTextRight(["-"]) == "--hello");
  assert("..hello..".stripTextRight(["."]) == "..hello");
  assert("..--hello--..".stripTextRight([".", "-"]) == "..--hello");
}