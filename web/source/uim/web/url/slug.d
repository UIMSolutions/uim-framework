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
    } else if (!lastWasSeparator) {
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
  if (value.length == 0) {
    return false;
  }
  if (value.startsWith(separator) || value.endsWith(separator)) {
    return false;
  }
  bool lastWasSeparator = false;
  foreach (dchar c; value) {
    if (c.isSlugChar) {
      lastWasSeparator = false;
    } else if (value.length > 0 && separator.canFind(cast(char)c)) {
      if (lastWasSeparator) {
        return false;
      }
      lastWasSeparator = true;
    } else {
      return false;
    }
  }
  return true;
}

private bool isSlugChar(dchar c) {
  return (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9');
}

/// Transliterates a non-ASCII character (e.g. German umlauts), returns null if unknown
private string transliterate(dchar c) {
  switch (c) {
    // German
    case 'ä': return "ae";
    case 'ö': return "oe";
    case 'ü': return "ue";
    case 'ß': return "ss";
    // French and others
    case 'à', 'á', 'â', 'ã', 'å': return "a";
    case 'è', 'é', 'ê', 'ë': return "e";
    case 'ì', 'í', 'î', 'ï': return "i";
    case 'ò', 'ó', 'ô', 'õ': return "o";
    case 'ù', 'ú', 'û': return "u";
    case 'ç': return "c";
    case 'ñ': return "n";
    case 'ý', 'ÿ': return "y";
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
}
