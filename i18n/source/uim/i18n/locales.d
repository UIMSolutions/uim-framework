/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.locales;

import uim.i18n;

import std.algorithm.searching : all, canFind;
import std.algorithm.sorting : sort;
import std.algorithm.mutation : SwapStrategy;
import std.array : join, replace, split;
import std.conv : ConvException, to;
import std.path : baseName, stripExtension;
import std.string : indexOf, lastIndexOf, strip, toLower, toUpper;

mixin(ShowModule!());

@safe:

/// Most entries of an Accept-Language header that are looked at. The header comes from the client.
enum size_t maxAcceptedLanguages = 32;

/// Normalizes a locale to the canonical form of this library, e.g. "de-at" to "de_AT" and
/// "zh-hant-tw" to "zh_Hant_TW". POSIX suffixes are dropped, so "de_AT.UTF-8" and "de_AT@euro" give "de_AT".
///
/// The result only holds letters, digits and "_", so it is safe to use in URLs and file names.
/// Returns: the normalized locale, or null if the value is not a valid locale
string normalizeLocale(string value) {
  import std.ascii : isAlpha, isAlphaNum, isDigit;

  auto text = value.strip;
  foreach (i, c; text) {
    if (c == '.' || c == '@') {
      text = text[0 .. i];
      break;
    }
  }

  auto parts = text.replace("-", "_").split("_");
  if (parts.length == 0) {
    return null;
  }
  foreach (i, part; parts) {
    immutable bool valid = i == 0
      ? part.length >= 2 && part.length <= 3 && part.all!isAlpha
      : part.length >= 2 && part.length <= 8 && part.all!isAlphaNum;
    if (!valid) {
      return null;
    }
    if (i == 0) {
      parts[i] = part.toLower;
    } else if (part.length == 2) {
      parts[i] = part.toUpper; // Region
    } else if (part.length == 4 && part.all!isAlpha) {
      parts[i] = part[0 .. 1].toUpper ~ part[1 .. $].toLower; // Script
    }
  }
  return parts.join("_");
}

/// The language of a normalized locale, e.g. "de" for "de_AT"
string localeLanguage(string locale) {
  auto separator = locale.indexOf('_');
  return separator < 0 ? locale : locale[0 .. separator];
}

/// The BCP 47 form of a normalized locale, e.g. "de-AT" for "de_AT"
string localeTag(string locale) {
  return locale.replace("_", "-");
}

/// The locales to search for a normalized locale, most specific first, e.g. ["de_AT", "de"] for "de_AT"
string[] localeChain(string locale) {
  string[] chain;
  auto current = locale;
  while (current.length > 0) {
    chain ~= current;
    auto separator = current.lastIndexOf('_');
    current = separator < 0 ? null : current[0 .. separator];
  }
  return chain;
}

/// Derives the locale from a file name, e.g. "i18n_de_AT.properties" to "de_AT".
/// Only two-letter languages are recognized, so that names like "main.json" do not count as a locale.
/// Returns: the locale, or null if the name holds none, like "i18n.properties"
string localeFromFileName(string fileName) {
  import std.ascii : isLower, isUpper;

  auto name = fileName.baseName;
  auto stem = name.stripExtension;
  if (stem == name) {
    return null; // Not only a name without extension, but also a hidden file like ".po"
  }

  auto parts = stem.replace("-", "_").replace(".", "_").split("_");
  bool isLanguage(string part) {
    return part.length == 2 && part.all!isLower;
  }

  if (parts.length == 0) {
    return null;
  }
  auto last = parts[$ - 1];
  if (isLanguage(last)) {
    return last;
  }
  if (parts.length >= 2 && last.length == 2 && last.all!isUpper && isLanguage(parts[$ - 2])) {
    return parts[$ - 2] ~ "_" ~ last;
  }
  return null;
}

/// Picks the best of the available locales for an Accept-Language header.
///
/// A requested locale matches exactly, then through its parents ("de_AT" accepts "de"), and
/// finally through its children ("de" accepts "de_AT"). Malformed entries are ignored.
/// Returns: the chosen locale, or null if nothing matches
string negotiateLocale(string acceptLanguage, const string[] available) {
  struct Request {
    string locale;
    double quality;
  }

  Request[] requests;
  foreach (entry; acceptLanguage.split(",")) {
    if (requests.length == maxAcceptedLanguages) {
      break;
    }
    auto fields = entry.split(";");
    if (fields.length == 0) {
      continue;
    }
    auto locale = normalizeLocale(fields[0]);
    if (locale.length == 0) {
      continue; // This includes "*": the caller falls back to its default anyway
    }

    double quality = 1;
    foreach (field; fields[1 .. $]) {
      auto parameter = field.strip;
      if (parameter.length > 2 && parameter[0 .. 2] == "q=") {
        try {
          quality = parameter[2 .. $].to!double;
        } catch (ConvException) {
          quality = 0;
        }
      }
    }
    if (quality > 0 && quality <= 1) { // Also false for NaN
      requests ~= Request(locale, quality);
    }
  }
  requests.sort!((a, b) => a.quality > b.quality, SwapStrategy.stable);

  auto sorted = available.dup.sort.release;
  foreach (request; requests) {
    foreach (candidate; localeChain(request.locale)) {
      if (sorted.canFind(candidate)) {
        return candidate;
      }
    }
    foreach (locale; sorted) {
      if (localeChain(locale).canFind(request.locale)) {
        return locale;
      }
    }
  }
  return null;
}

/// Normalizing
unittest {
  assert(normalizeLocale("de") == "de");
  assert(normalizeLocale("DE-at") == "de_AT");
  assert(normalizeLocale("zh_hant_tw") == "zh_Hant_TW");
  assert(normalizeLocale(" pt-BR ") == "pt_BR");
  assert(normalizeLocale("de_AT.UTF-8") == "de_AT");
  assert(normalizeLocale("de_DE@euro") == "de_DE");
  assert(normalizeLocale("es-419") == "es_419");

  foreach (bad; ["", " ", "d", "de_", "_de", "../de", "de/AT", "de_A", "toolong", "d3", "de%2F", "de_AT/../x"]) {
    assert(normalizeLocale(bad) is null, bad);
  }
}

/// Parts of a locale
unittest {
  assert(localeLanguage("de_AT") == "de");
  assert(localeLanguage("de") == "de");
  assert(localeTag("zh_Hant_TW") == "zh-Hant-TW");
  assert(localeChain("zh_Hant_TW") == ["zh_Hant_TW", "zh_Hant", "zh"]);
  assert(localeChain("de") == ["de"]);
  assert(localeChain(null).length == 0);
}

/// Locales in file names
unittest {
  assert(localeFromFileName("i18n_de.properties") == "de");
  assert(localeFromFileName("i18n_de_AT.properties") == "de_AT");
  assert(localeFromFileName("en-US.json") == "en_US");
  assert(localeFromFileName("messages.fr.po") == "fr");
  assert(localeFromFileName("/a/b/de.mo") == "de");
  assert(localeFromFileName("i18n.properties") is null);
  assert(localeFromFileName("main.json") is null);
  assert(localeFromFileName(".po") is null);
}

/// Accept-Language
unittest {
  auto available = ["de", "en", "fr_CA"];
  assert(negotiateLocale("de", available) == "de");
  assert(negotiateLocale("de-AT,en;q=0.8", available) == "de"); // Through the parent
  assert(negotiateLocale("fr", available) == "fr_CA"); // Through a child
  assert(negotiateLocale("en;q=0.5, de;q=0.9", available) == "de"); // Quality order
  assert(negotiateLocale("en;q=0.5, de ; q=0.9", available) == "de");
  assert(negotiateLocale("es, en", available) == "en"); // Later entries count
  assert(negotiateLocale("de;q=0, en", available) == "en"); // q=0 means "not acceptable"

  assert(negotiateLocale("es", available) is null);
  assert(negotiateLocale("*", available) is null);
  assert(negotiateLocale("", available) is null);
  assert(negotiateLocale("de", null) is null);
  foreach (bad; ["de;q=x", "de;q=nan", "de;q=2", ";;;", ",,,", "de;q="]) {
    assert(negotiateLocale(bad, ["en"]) is null, bad);
  }
}
