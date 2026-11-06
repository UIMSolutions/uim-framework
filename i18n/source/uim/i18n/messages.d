/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.messages;

import uim.i18n;

import std.array : appender;
import std.conv : ConvException, to;

mixin(ShowModule!());

@safe:

/// Replaces {name} placeholders in one pass, so text from a value is never expanded again.
/// Placeholders without a value stay as they are.
private string substitute(string text, scope bool delegate(string name, out string value) @safe resolve) {
  import std.ascii : isAlphaNum;

  auto result = appender!string;
  size_t i;
  while (i < text.length) {
    if (text[i] == '{') {
      size_t end = i + 1;
      while (end < text.length && (text[end].isAlphaNum || text[end] == '_' || text[end] == '.' || text[end] == '-')) {
        end++;
      }
      string value;
      if (end > i + 1 && end < text.length && text[end] == '}' && resolve(text[i + 1 .. end], value)) {
        result.put(value);
        i = end + 1;
        continue;
      }
    }
    result.put(text[i]);
    i++;
  }
  return result.data;
}

/// Replaces the positional placeholders {0}, {1}, ... of a message.
string formatMessage(string text, const string[] arguments) {
  return substitute(text, (name, out value) {
    size_t index;
    try {
      index = name.to!size_t;
    } catch (ConvException) {
      return false;
    }
    if (index >= arguments.length) {
      return false;
    }
    value = arguments[index];
    return true;
  });
}

/// Replaces the named placeholders {name} of a message.
string formatMessage(string text, const string[string] arguments) {
  return substitute(text, (name, out value) {
    auto found = name in arguments;
    if (found is null) {
      return false;
    }
    value = *found;
    return true;
  });
}

/// Inserts the number of a plural message, which is written {n}, {0} or, in gettext files, %d.
string formatPluralMessage(string text, ulong n) {
  immutable number = n.to!string;

  auto result = appender!string;
  size_t i;
  while (i < text.length) {
    if (text[i] == '%' && i + 1 < text.length) {
      if (text[i + 1] == 'd') {
        result.put(number);
        i += 2;
        continue;
      }
      if (text[i + 1] == '%') { // An escaped percent sign, so a following d is plain text
        result.put("%%");
        i += 2;
        continue;
      }
    }
    result.put(text[i]);
    i++;
  }

  return substitute(result.data, (name, out value) {
    if (name != "n" && name != "0") {
      return false;
    }
    value = number;
    return true;
  });
}

///
unittest {
  assert(formatMessage("Hello {0}, you have {1} tasks", ["Ada", "3"]) == "Hello Ada, you have 3 tasks");
  assert(formatMessage("Hello {user}", ["user": "Ada"]) == "Hello Ada");

  // Unknown placeholders and plain braces stay
  assert(formatMessage("{0} {1} {x} {} { 0 } {", ["a"]) == "a {1} {x} {} { 0 } {");
  assert(formatMessage("{99999999999999999999999}", ["a"]) == "{99999999999999999999999}");
  assert(formatMessage("{a} {b}", ["a": "1"]) == "1 {b}");
  assert(formatMessage("", ["a"]) == "");

  // Values are not expanded again
  assert(formatMessage("{0} {1}", ["{1}", "x"]) == "{1} x");
  assert(formatMessage("{a}", ["a": "{a}"]) == "{a}");
  // Non-ASCII text
  assert(formatMessage("Größe {0} ✓", ["ü"]) == "Größe ü ✓");

  assert(formatPluralMessage("%d files", 3) == "3 files");
  assert(formatPluralMessage("{n} files, {0} total", 3) == "3 files, 3 total");
  assert(formatPluralMessage("100%% of %d, %s, 5%", 3) == "100%% of 3, %s, 5%");
  assert(formatPluralMessage("%%d", 3) == "%%d");
}
