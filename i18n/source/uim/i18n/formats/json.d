/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.formats.json;

import uim.i18n;

import std.algorithm.sorting : sort;
import std.array : split;
import std.json : JSONType, JSONValue, parseJSON;
import std.string : format;

mixin(ShowModule!());

@safe:

/// Deepest nesting accepted in a JSON language file, as the parser recurses and fibers have small stacks
enum int maxI18nJsonDepth = 64;

/// Parses a JSON language file. Nested objects and arrays are flattened to dotted keys, so
/// {"app": {"title": "x"}} gives the key "app.title". Keys are sorted, as JSON objects are unordered.
/// A plural message is written as {"key": "first form", "key[1]": "second form"}.
///
/// This uses std.json and not vibe.data.json, whose parser has no depth limit
/// and runs off the end of its input on a truncated number such as {"a":-
///
/// Params:
///   content = the file
///   locale = the locale of the catalog
///   root = dotted path of the object that holds the messages, for APIs that wrap them, e.g. "data.messages"
/// Throws: I18nParseException on malformed JSON, or if the root is not an object
I18nCatalog parseJsonCatalog(const(ubyte)[] content, string locale = null, string root = null) {
  auto value = parseJsonText(content);
  if (root.length > 0) {
    foreach (name; root.split(".")) {
      if (value.type != JSONType.object || name !in value.objectNoRef) {
        throw new I18nParseException("JSON has no member '%s'".format(root));
      }
      value = value.objectNoRef[name];
    }
  }
  if (value.type != JSONType.object) {
    throw new I18nParseException("The root of a JSON language file must be an object");
  }

  string[2][] entries;
  flatten(entries, null, value);

  auto catalog = new I18nCatalog(locale);
  addFlatEntries(catalog, entries);
  return catalog;
}

/// Reads a list of locales, which is either an array of strings or an object with the locales as keys.
/// Entries that are not valid locales are ignored.
/// Throws: I18nParseException on malformed JSON or another root
string[] parseJsonLocales(const(ubyte)[] content) {
  auto value = parseJsonText(content);

  string[] names;
  if (value.type == JSONType.array) {
    foreach (item; value.arrayNoRef) {
      if (item.type == JSONType.string) {
        names ~= item.str;
      }
    }
  } else if (value.type == JSONType.object) {
    names = value.objectNoRef.keys.sort.release;
  } else {
    throw new I18nParseException("A JSON locale list must be an array or an object");
  }

  string[] locales;
  foreach (name; names) {
    auto locale = normalizeLocale(name);
    if (locale.length > 0) {
      locales ~= locale;
    }
  }
  return locales;
}

private JSONValue parseJsonText(const(ubyte)[] content) {
  auto text = decodeUtf8(stripBom(content));
  try {
    return parseJSON(text, maxI18nJsonDepth);
  } catch (Exception e) { // JSONException, or ConvException for a number out of range
    throw new I18nParseException("Invalid JSON: " ~ e.msg);
  }
}

private void flatten(ref string[2][] entries, string prefix, JSONValue value) {
  void add(string text) {
    if (prefix.length > 0) {
      string[2] entry = [prefix, text];
      entries ~= entry;
    }
  }

  switch (value.type) {
    case JSONType.object:
      auto members = value.objectNoRef;
      foreach (name; members.keys.sort) {
        flatten(entries, prefix.length > 0 ? prefix ~ "." ~ name : name, members[name]);
      }
      break;
    case JSONType.array:
      foreach (i, item; value.arrayNoRef) {
        flatten(entries, "%s.%d".format(prefix, i), item);
      }
      break;
    case JSONType.null_:
      break;
    case JSONType.string:
      add(value.str);
      break;
    default: // Numbers and booleans
      add(value.toString);
  }
}

version (unittest) {
  import std.exception : assertThrown;
  import std.string : representation;

  private I18nCatalog parse(string text, string root = null) {
    return parseJsonCatalog(text.representation, null, root);
  }
}

///
unittest {
  auto parsed = parse(`{
    "z": "Ü", "app": {"title": "T", "tabs": ["a", {"b": "c"}]}, "n": 5, "yes": true, "skip": null
  }`);
  assert(parsed.get("app.title") == "T");
  assert(parsed.get("app.tabs.0") == "a");
  assert(parsed.get("app.tabs.1.b") == "c");
  assert(parsed.get("n") == "5");
  assert(parsed.get("yes") == "true");
  assert(parsed.get("z") == "Ü");
  assert(!parsed.has("skip"));
  assert(parsed.length == 6);

  assert(parse(`{"file": "one", "file[1]": "many"}`).forms("file") == ["one", "many"]);
}

/// Wrapped messages
unittest {
  auto text = `{"status": "ok", "data": {"messages": {"a": "b"}}, "list": []}`;
  auto parsed = parse(text, "data.messages");
  assert(parsed.length == 1 && parsed.get("a") == "b");

  assertThrown!I18nParseException(parse(text, "data.missing"));
  assertThrown!I18nParseException(parse(text, "status.x"));
  assertThrown!I18nParseException(parse(text, "list"));
}

/// Malformed files
unittest {
  import std.array : replicate;

  assertThrown!I18nParseException(parse(`["a"]`));
  assertThrown!I18nParseException(parse(""));
  assertThrown!I18nParseException(parseJsonCatalog(cast(ubyte[])['{', '"', 0xFF, '"', ':', '1', '}']));

  // Truncated numbers crash vibe.data.json, which is why this parser does not use it
  foreach (bad; [`{"a":-`, `{"a":1e`, `{"a":1.`, `{"a":1e+`, `-`, `{"a":`]) {
    assertThrown!I18nParseException(parse(bad), bad);
  }
  // std.json reports a number out of range with a ConvException
  assertThrown!I18nParseException(parse(`{"a":1e999}`));

  // Deep nesting is rejected by the depth limit of the parser
  assertThrown!I18nParseException(parse("[".replicate(1_000_000)));
  assertThrown!I18nParseException(parse(`{"a":`.replicate(1_000_000)));
  // Brackets in strings do not count
  assert(parse(`{"a":"` ~ "[".replicate(1000) ~ `\""}`).length == 1);
}

/// Locale lists
unittest {
  assert(parseJsonLocales(`["de-AT", "en", "../x", 5]`.representation) == ["de_AT", "en"]);
  assert(parseJsonLocales(`{"fr": {}, "de": {}}`.representation) == ["de", "fr"]);
  assertThrown!I18nParseException(parseJsonLocales(`"de"`.representation));
  assertThrown!I18nParseException(parseJsonLocales(`[`.representation));
}
