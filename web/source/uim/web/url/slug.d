/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.web.url.slug;

import uim.web;

mixin(ShowModule!());

@safe:

/// Converts a string to a URL-friendly slug, e.g. slugify("Hello World!") -> "hello-world"
string slugify(string value, string separator = "-") {
  auto result = appender!string;
  bool lastWasSeparator = true; // suppress leading separator

  foreach (dchar c; value.toLower) {
    if (c.isSlugChar) {
      result.put(c);
      lastWasSeparator = false;
    } else if (auto replacement = c.transliterate) {
      result.put(replacement);
      lastWasSeparator = false;
    } else if (!c.isCombiningMark && !lastWasSeparator) {
      result.put(separator);
      lastWasSeparator = true;
    }
  }

  string slug = result.data;
  if (slug.endsWith(separator)) {
    slug = slug[0 .. $ - separator.length];
  }
  return slug;
}

/// Checks whether a string is a valid slug (lowercase alphanumeric with separators)
bool isSlug(string value, string separator = "-") {
  auto words = separator.length > 0 ? value.split(separator) : [value];
  return words.length > 0 && words.all!(word => word.length > 0 && word.all!isSlugChar);
}

private bool isSlugChar(dchar c) {
  return (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9');
}

// Combining marks carry no letter of their own, e.g. the accent of a decomposed "é"
private bool isCombiningMark(dchar c) {
  return c >= 0x0300 && c <= 0x036F;
}

/// Transliterates a non-ASCII character (e.g. German umlauts), returns null if unknown
private string transliterate(dchar c) {
  switch (c) {
    // German
    case 'ä': return "ae";
    case 'ö': return "oe";
    case 'ü': return "ue";
    case 'ß': return "ss";
    // Latin letters with diacritics
    case 'à', 'á', 'â', 'ã', 'å', 'ā', 'ă', 'ą': return "a";
    case 'ç', 'ć', 'č': return "c";
    case 'ď', 'đ', 'ð': return "d";
    case 'è', 'é', 'ê', 'ë', 'ē', 'ė', 'ę', 'ě': return "e";
    case 'ğ': return "g";
    case 'ì', 'í', 'î', 'ï', 'ī', 'ı': return "i";
    case 'ł': return "l";
    case 'ñ', 'ń', 'ň': return "n";
    case 'ò', 'ó', 'ô', 'õ', 'ø', 'ō', 'ő': return "o";
    case 'ř': return "r";
    case 'ś', 'ş', 'š': return "s";
    case 'ť', 'ţ': return "t";
    case 'ù', 'ú', 'û', 'ū', 'ů', 'ű': return "u";
    case 'ý', 'ÿ': return "y";
    case 'ź', 'ż', 'ž': return "z";
    // ligatures
    case 'æ': return "ae";
    case 'œ': return "oe";
    case 'þ': return "th";
    default: return null;
  }
}

///
unittest {
  // basics
  assert(slugify("Hello World!") == "hello-world");
  assert(slugify("Already-Slug") == "already-slug");
  assert(slugify("  spaces  ") == "spaces");
  assert(slugify("a   b") == "a-b");
  assert(slugify("Numbers 123 ok") == "numbers-123-ok");
  assert(slugify("") == "");

  // special characters
  assert(slugify("C++ & D") == "c-d");
  assert(slugify("50% off!") == "50-off");

  // transliteration
  assert(slugify("Hällo Wörld") == "haello-woerld");
  assert(slugify("Müller") == "mueller");
  assert(slugify("Straße") == "strasse");
  assert(slugify("Café") == "cafe");
  assert(slugify("naïve") == "naive");

  // custom separator
  assert(slugify("Hello World", "_") == "hello_world");

  // validation
  assert(isSlug("hello-world"));
  assert(isSlug("simple"));
  assert(isSlug("a1-b2"));
  assert(!isSlug(""));
  assert(!isSlug("Hello-World"));
  assert(!isSlug("-leading"));
  assert(!isSlug("trailing-"));
  assert(!isSlug("double--dash"));
  assert(!isSlug("with space"));
  assert(!isSlug("with_underscore"));
  assert(isSlug("with_underscore", "_"));

  // non-ASCII characters are never mistaken for the separator (U+012D ends in the byte of '-')
  assert(!isSlug("a\u012Db"));

  // multi-character separators
  assert(isSlug("a--b", "--"));
  assert(!isSlug("a-b", "--"));
  assert(!isSlug("--a", "--"));

  // further languages and combining marks
  assert(slugify("Şükrü Iğdır İstanbul") == "suekrue-igdir-istanbul");
  assert(slugify("Łódź") == "lodz");
  assert(slugify("Dvořák Ærø") == "dvorak-aero");
  assert(slugify("Cafe\u0301 au lait") == "cafe-au-lait");
}
