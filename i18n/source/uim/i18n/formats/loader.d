/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.formats.loader;

import uim.i18n;

import std.algorithm.searching : canFind;
import std.path : extension;
import std.string : format, indexOf, strip, toLower;

mixin(ShowModule!());

@safe:

/// Language file formats
enum I18nFormat {
  unknown,
  properties,
  po,
  mo,
  json
}

/// Detects the format of a language file from its extension (case-insensitive)
I18nFormat detectI18nFormat(string fileName) {
  switch (fileName.extension.toLower) {
    case ".properties":
      return I18nFormat.properties;
    case ".po":
      return I18nFormat.po;
    case ".mo":
      return I18nFormat.mo;
    case ".json":
      return I18nFormat.json;
    default:
      return I18nFormat.unknown;
  }
}

/// Detects the format of a language file from a Content-Type value
I18nFormat detectI18nContentType(string contentType) {
  auto parameters = contentType.indexOf(';');
  switch ((parameters < 0 ? contentType : contentType[0 .. parameters]).strip.toLower) {
    case "text/x-java-properties":
    case "text/x-properties":
      return I18nFormat.properties;
    case "text/x-gettext-translation":
    case "text/x-po":
    case "application/x-po":
    case "application/x-gettext":
      return I18nFormat.po;
    case "application/x-gettext-translation":
    case "application/x-mo":
      return I18nFormat.mo;
    case "application/json":
    case "text/json":
      return I18nFormat.json;
    default:
      return I18nFormat.unknown;
  }
}

/// Parses a language file of a known format.
/// Throws: I18nParseException if the format is unknown or the content malformed
I18nCatalog parseCatalog(I18nFormat fileFormat, const(ubyte)[] content, string locale = null) {
  final switch (fileFormat) {
    case I18nFormat.properties:
      return parseProperties(content, locale);
    case I18nFormat.po:
      return parsePo(content, locale);
    case I18nFormat.mo:
      return parseMo(content, locale);
    case I18nFormat.json:
      return parseJsonCatalog(content, locale);
    case I18nFormat.unknown:
      throw new I18nParseException("Unsupported language file format");
  }
}

/// Parses a language file, whose format follows from its name.
///
/// The locale comes from the locale parameter, otherwise from the Language header of a .po or .mo
/// file, otherwise from the file name. Without any of these the catalog has an empty locale.
///
/// Throws: I18nParseException if the format is unknown, the locale invalid or the content malformed
I18nCatalog loadCatalog(string fileName, const(ubyte)[] content, string locale = null) {
  string normalized;
  if (locale.length > 0) {
    normalized = normalizeLocale(locale);
    if (normalized.length == 0) {
      throw new I18nParseException("Invalid locale '%s'".format(locale));
    }
  }

  immutable fileFormat = detectI18nFormat(fileName);
  if (fileFormat == I18nFormat.unknown) {
    throw new I18nParseException("Unsupported language file '%s'".format(fileName));
  }

  auto catalog = parseCatalog(fileFormat, content, normalized);
  if (catalog.locale.length == 0) {
    catalog.locale(localeFromFileName(fileName));
  }
  return catalog;
}

version (unittest) {
  import std.exception : assertThrown;
  import std.string : representation;
}

/// Format detection
unittest {
  assert(detectI18nFormat("i18n_de.properties") == I18nFormat.properties);
  assert(detectI18nFormat("de.PO") == I18nFormat.po);
  assert(detectI18nFormat("/a/b/de.mo") == I18nFormat.mo);
  assert(detectI18nFormat("de.json") == I18nFormat.json);
  assert(detectI18nFormat("de.txt") == I18nFormat.unknown);
  assert(detectI18nFormat("po") == I18nFormat.unknown);

  assert(detectI18nContentType("application/json; charset=utf-8") == I18nFormat.json);
  assert(detectI18nContentType("Text/X-Gettext-Translation") == I18nFormat.po);
  assert(detectI18nContentType("application/x-gettext-translation") == I18nFormat.mo);
  assert(detectI18nContentType("text/x-java-properties;charset=UTF-8") == I18nFormat.properties);
  assert(detectI18nContentType("text/html") == I18nFormat.unknown);
  assert(detectI18nContentType("") == I18nFormat.unknown);
}

/// Locale precedence: parameter, then file header, then file name
unittest {
  auto po = "msgid \"\"\nmsgstr \"Language: de_AT\\n\"\n\nmsgid \"a\"\nmsgstr \"b\"\n".representation;
  assert(loadCatalog("fr.po", po, "es-MX").locale == "es_MX");
  assert(loadCatalog("fr.po", po).locale == "de_AT");
  assert(loadCatalog("fr.po", "msgid \"a\"\nmsgstr \"b\"\n".representation).locale == "fr");
  assert(loadCatalog("i18n.properties", "a=b".representation).locale == "");
}

/// Rejected input
unittest {
  assertThrown!I18nParseException(loadCatalog("de.txt", "x".representation));
  assertThrown!I18nParseException(loadCatalog("de.po", "".representation, "../x"));
  assertThrown!I18nParseException(parseCatalog(I18nFormat.unknown, "x".representation));
}

/// All formats give the same message
unittest {
  foreach (file; [
    ["i18n_de.properties", "title=Titel\n"],
    ["i18n_de.json", `{"title":"Titel"}`],
    ["i18n_de.po", "msgid \"title\"\nmsgstr \"Titel\"\n"],
  ]) {
    auto catalog = loadCatalog(file[0], file[1].representation);
    assert(catalog.locale == "de");
    assert(catalog.length == 1 && catalog.get("title") == "Titel");
  }
}
