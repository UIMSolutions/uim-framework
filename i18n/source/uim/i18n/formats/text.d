/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.formats.text;

import uim.i18n;

import std.algorithm.iteration : map;
import std.algorithm.searching : all;
import std.array : appender;
import std.conv : to;
import std.string : endsWith, format, lastIndexOf;
import std.utf : UTFException, validate;

mixin(ShowModule!());

@safe:

/// Removes a UTF-8 byte order mark
package(uim.i18n) const(ubyte)[] stripBom(const(ubyte)[] content) {
  return content.length >= 3 && content[0] == 0xEF && content[1] == 0xBB && content[2] == 0xBF
    ? content[3 .. $] : content;
}

package(uim.i18n) bool isValidUtf8(string text) {
  try {
    validate(text);
    return true;
  } catch (UTFException) {
    return false;
  }
}

/// Throws: I18nParseException if the bytes are not valid UTF-8
package(uim.i18n) string decodeUtf8(const(ubyte)[] bytes) {
  auto text = (cast(const(char)[])bytes).idup;
  if (!isValidUtf8(text)) {
    throw new I18nParseException("Content is not valid UTF-8");
  }
  return text;
}

package(uim.i18n) string decodeLatin1(const(ubyte)[] bytes) {
  auto result = appender!string;
  foreach (b; bytes) {
    result.put(cast(dchar)b);
  }
  return result.data;
}

/// Splits "key[2]" into "key" and 2.
/// Returns: false if the key has no valid form index
private bool splitPluralKey(string key, out string base, out size_t index) {
  import std.ascii : isDigit;

  auto open = key.lastIndexOf('[');
  if (open <= 0 || !key.endsWith("]") || key.length - open < 3 || key.length - open > 5) {
    return false;
  }
  auto digits = key[open + 1 .. $ - 1];
  if (!digits.all!isDigit) {
    return false;
  }
  base = key[0 .. open];
  index = digits.to!size_t;
  return index < maxPluralForms;
}

/// Adds key/value pairs of a format without plural syntax. The form n of a plural message is written
/// "key[n]" next to the plain "key", which holds the first form. Without "key", it is an ordinary key.
package(uim.i18n) void addFlatEntries(I18nCatalog catalog, const string[2][] entries) {
  bool[string] plain;
  foreach (entry; entries) {
    plain[entry[0]] = true;
  }

  string[2][] plurals;
  foreach (entry; entries) {
    string base;
    size_t index;
    if (splitPluralKey(entry[0], base, index) && base in plain) {
      plurals ~= entry;
    } else {
      catalog.set(entry[0], entry[1]);
    }
  }

  foreach (entry; plurals) {
    string base;
    size_t index;
    splitPluralKey(entry[0], base, index);
    auto forms = catalog.forms(base);
    if (forms.length <= index) {
      forms.length = index + 1;
    }
    forms[index] = entry[1];
    catalog.setPlural(base, forms);
  }
}

///
unittest {
  auto catalog = new I18nCatalog;
  string[2][] entries = [
    ["file[1]", "files"], ["file", "file"], ["file[3]", "many"], ["other[1]", "x"], ["a[64]", "y"], ["a", "z"],
    ["b[1000]", "w"], ["b", "v"], ["c[x]", "u"], ["c", "t"], ["[1]", "s"]
  ];
  addFlatEntries(catalog, entries);

  assert(catalog.forms("file") == ["file", "files", null, "many"]);
  assert(catalog.get("other[1]") == "x"); // No "other", so this is no plural
  assert(catalog.get("a[64]") == "y"); // Index out of range
  assert(catalog.get("b[1000]") == "w");
  assert(catalog.get("c[x]") == "u");
  assert(catalog.get("[1]") == "s");
}
