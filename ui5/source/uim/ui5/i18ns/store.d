/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.i18ns.store;

import uim.ui5;

import std.ascii : isDigit, isHexDigit;

mixin(ShowModule!());

@safe:

/// Thrown when the content of a language file cannot be parsed.
class I18nParseException : Exception {
  mixin basicExceptionCtors;
}

/// A UI5 i18n resource bundle (content of an i18n.properties file).
class I18nStore {
  this(string locale = null) {
    _locale = locale;
  }

  /// The locale of the bundle, e.g. "de" (empty = default bundle)
  string locale() const {
    return _locale;
  }

  /// Sets the locale of the bundle (fluent interface)
  auto locale(string value) {
    _locale = value;
    return this;
  }

  /// Sets a text entry, e.g. set("appTitle", "My App") (fluent interface)
  auto set(string key, string value) {
    if (key !in _entries) {
      _order ~= key;
    }
    _entries[key] = value;
    return this;
  }

  /// Sets a text entry with placeholders, e.g. setWithPlaceholders("greeting", "Hello {0}") (fluent interface)
  auto setWithPlaceholders(string key, string value) {
    return set(key, value);
  }

  /// Adds a comment line (fluent interface)
  auto comment(string text) {
    _comments[_order.length] = text;
    return this;
  }

  /// Copies all entries of another bundle, replacing existing keys (fluent interface)
  auto merge(const I18nStore other) {
    foreach (key; other._order) {
      set(key, other._entries[key]);
    }
    return this;
  }

  /// Removes an entry (fluent interface)
  auto remove(string key) {
    _entries.remove(key);
    _order = _order.filter!(k => k != key).array;
    return this;
  }

  /// Checks whether a key exists
  bool has(string key) const {
    return (key in _entries) !is null;
  }

  /// Returns the value of a key
  string get(string key) const {
    auto found = key in _entries;
    return found is null ? null : *found;
  }

  /// All keys in insertion order
  string[] keys() const {
    return _order.dup;
  }

  /// Number of entries
  size_t length() const {
    return _entries.length;
  }

  /// The file name of the bundle, e.g. "i18n_de.properties" for locale "de"
  string fileName(string baseName = "i18n") const {
    return _locale.length > 0
      ? "%s_%s.properties".format(baseName, _locale)
      : "%s.properties".format(baseName);
  }

  /// Renders the bundle as .properties file content
  override string toString() const {
    auto result = appender!string;
    foreach (i, key; _order) {
      if (auto commentText = i in _comments) {
        result.put("# " ~ *commentText ~ "\n");
      }
      if (auto value = key in _entries) {
        result.put("%s=%s\n".format(escapePropertiesKey(key), escapeProperties(*value)));
      }
    }
    return result.data;
  }

  private string _locale;
  private string[string] _entries;
  private string[] _order;
  private string[size_t] _comments;
}

/// Creates an i18n store, e.g. ui5I18nStore("de")
I18nStore ui5I18nStore(string locale = null) {
  return new I18nStore(locale);
}

/// Escapes a value for a .properties file (special characters and non-ASCII)
string escapeProperties(string value) {
  auto result = appender!string;
  bool leading = true;
  foreach (dchar c; value) {
    if (leading && isPropertiesSpace(c)) {
      result.put('\\'); // Otherwise the parser would strip it as separator whitespace
    } else {
      leading = false;
    }
    putPropertiesChar(result, c);
  }
  return result.data;
}

/// Escapes a key for a .properties file. Unlike values, keys end at the first unescaped separator.
string escapePropertiesKey(string key) {
  auto result = appender!string;
  foreach (dchar c; key) {
    if (c == ' ' || c == ':' || c == '#' || c == '!') {
      result.put('\\');
    }
    putPropertiesChar(result, c);
  }
  return result.data;
}

private void putPropertiesChar(ref Appender!string result, dchar c) {
  switch (c) {
    case '\\':
      result.put("\\\\");
      break;
    case '\n':
      result.put("\\n");
      break;
    case '\r':
      result.put("\\r");
      break;
    case '\t':
      result.put("\\t");
      break;
    case '\f':
      result.put("\\f");
      break;
    case '=':
      result.put("\\=");
      break;
    default:
      if (c > 0xFFFF) { // \uXXXX holds UTF-16 code units, so this needs a surrogate pair
        immutable uint offset = cast(uint)c - 0x10000;
        result.put("\\u%04X\\u%04X".format(0xD800 + (offset >> 10), 0xDC00 + (offset & 0x3FF)));
      } else if (c > 127) {
        result.put("\\u%04X".format(cast(uint)c));
      } else {
        result.put(c);
      }
  }
}

private bool isPropertiesSpace(dchar c) {
  return c == ' ' || c == '\t' || c == '\f';
}

private string skipPropertiesSpace(string text) {
  size_t i;
  while (i < text.length && isPropertiesSpace(text[i])) {
    i++;
  }
  return text[i .. $];
}

/// True if a line ends with an unescaped backslash, which continues it on the next line
private bool isContinued(string line) {
  size_t backslashes;
  while (backslashes < line.length && line[$ - 1 - backslashes] == '\\') {
    backslashes++;
  }
  return backslashes % 2 == 1;
}

/// Splits at \n, \r\n and \r only: other Unicode line separators are ordinary text in a value
private string[] physicalLines(string content) {
  string[] lines;
  size_t start;
  foreach (i, c; content) {
    if (c == '\r' && i + 1 < content.length && content[i + 1] == '\n') {
      continue;
    }
    if (c == '\n' || c == '\r') {
      lines ~= content[start .. i - (c == '\n' && i > start && content[i - 1] == '\r' ? 1 : 0)];
      start = i + 1;
    }
  }
  lines ~= content[start .. $];
  return lines;
}

/// Parses .properties content into a bundle.
/// Follows java.util.Properties: keys end at '=', ':' or whitespace, and a trailing backslash continues the line.
/// Throws: I18nParseException on a malformed \uXXXX escape
I18nStore parseProperties(string content, string locale = null) {
  auto bundle = new I18nStore(locale);
  auto lines = physicalLines(content);
  for (size_t i; i < lines.length; i++) {
    string line = skipPropertiesSpace(lines[i]);
    if (line.length == 0) {
      continue;
    }
    if (line[0] == '#' || line[0] == '!') {
      bundle.comment(line[1 .. $].strip);
      continue;
    }
    while (isContinued(line)) {
      line = line[0 .. $ - 1];
      if (++i < lines.length) {
        line ~= skipPropertiesSpace(lines[i]);
      }
    }

    size_t keyEnd;
    while (keyEnd < line.length) {
      immutable char c = line[keyEnd];
      if (c == '=' || c == ':' || isPropertiesSpace(c)) {
        break;
      }
      keyEnd += c == '\\' ? 2 : 1;
    }
    keyEnd = keyEnd > line.length ? line.length : keyEnd;

    string rest = skipPropertiesSpace(line[keyEnd .. $]);
    if (rest.length > 0 && (rest[0] == '=' || rest[0] == ':')) {
      rest = skipPropertiesSpace(rest[1 .. $]);
    }
    if (keyEnd > 0) {
      bundle.set(unescapeProperties(line[0 .. keyEnd]), unescapeProperties(rest));
    }
  }
  return bundle;
}

/// Reads the four hex digits of a \uXXXX escape starting at position start
private uint parseUnicodeEscape(string value, size_t start) {
  if (start + 4 > value.length) {
    throw new I18nParseException("Incomplete \\u escape in '%s'".format(value));
  }
  uint result;
  foreach (c; value[start .. start + 4]) {
    if (!c.isHexDigit) {
      throw new I18nParseException("Invalid \\u escape in '%s'".format(value));
    }
    result = result * 16 + (c.isDigit ? c - '0' : (c | 0x20) - 'a' + 10);
  }
  return result;
}

/// Unescapes a .properties value
/// Throws: I18nParseException on a malformed \uXXXX escape
string unescapeProperties(string value) {
  auto result = appender!string;
  size_t i;
  while (i < value.length) {
    if (value[i] == '\\' && i + 1 < value.length) {
      switch (value[i + 1]) {
        case 'n':
          result.put('\n');
          i += 2;
          break;
        case 'r':
          result.put('\r');
          i += 2;
          break;
        case 't':
          result.put('\t');
          i += 2;
          break;
        case 'f':
          result.put('\f');
          i += 2;
          break;
        case 'u':
          dchar decoded = cast(dchar)parseUnicodeEscape(value, i + 2);
          i += 6;
          if (decoded >= 0xD800 && decoded <= 0xDBFF && value[i .. $].startsWith("\\u")) {
            immutable uint low = parseUnicodeEscape(value, i + 2);
            if (low >= 0xDC00 && low <= 0xDFFF) {
              decoded = cast(dchar)(0x10000 + ((decoded - 0xD800) << 10) + (low - 0xDC00));
              i += 6;
            }
          }
          result.put(decoded >= 0xD800 && decoded <= 0xDFFF ? cast(dchar)0xFFFD : decoded);
          break;
        default: // '\\', '=', ':', ' ', ... stand for themselves
          i++;
          immutable size_t start = i;
          i += value[i .. $].stride; // One whole character, which may be multi-byte
          result.put(value[start .. i]);
      }
    } else {
      result.put(value[i]);
      i++;
    }
  }
  return result.data;
}
// ///
// unittest {
//   // bundle basics
//   auto bundle = new I18nStore;
//   assert(bundle.locale is null);
//   assert(bundle.length == 0);
//   assert(bundle.fileName == "i18n.properties");

//   bundle.set("appTitle", "My App").set("saveButton", "Save");
//   assert(bundle.length == 2);
//   assert(bundle.has("appTitle"));
//   assert(!bundle.has("missing"));
//   assert(bundle.get("appTitle") == "My App");
//   assert(bundle.get("missing") is null);
//   assert(bundle.keys == ["appTitle", "saveButton"]);
//   assert(bundle.toString == "appTitle=My App\nsaveButton=Save\n");

//   // localized bundle
//   auto german = I18nStore("de");
//   assert(german.locale == "de");
//   assert(german.fileName == "i18n_de.properties");
//   assert(german.fileName("texts") == "texts_de.properties");

//   // placeholders
//   bundle.setWithPlaceholders("greeting", "Hello {0}, you have {1} tasks");
//   assert(bundle.get("greeting") == "Hello {0}, you have {1} tasks");

//   // comments
//   auto commented = I18nStore()
//     .comment("Application texts")
//     .set("appTitle", "My App");
//   assert(commented.toString == "# Application texts\nappTitle=My App\n");

//   // remove
//   bundle.remove("saveButton");
//   assert(!bundle.has("saveButton"));
//   assert(bundle.keys == ["appTitle", "greeting"]);

//   // escaping
//   assert(escapeProperties("a=b") == `a\=b`);
//   assert(escapeProperties("a\\b") == `a\\b`);
//   assert(escapeProperties("ü") == `\u00FC`); // ü is U+00FC
//   assert(escapeProperties("line\nbreak") == `line\nbreak`);

//   // unescaping
//   assert(unescapeProperties(`a\=b`) == "a=b");
//   assert(unescapeProperties(`a\\b`) == `a\b`);
//   assert(unescapeProperties(`\u00FC`) == "ü");
//   assert(unescapeProperties(`line\nbreak`) == "line\nbreak");

//   // parsing
//   auto parsed = parseProperties("# Comment\nappTitle=My App\ngreeting=Hello {0}\n\nempty=\n");
//   assert(parsed.length == 3);
//   assert(parsed.get("appTitle") == "My App");
//   assert(parsed.get("greeting") == "Hello {0}");
//   assert(parsed.get("empty") == "");

//   // round trip with unicode
//   auto original = I18nStore("de").set("title", "Übersicht");
//   assert(parseProperties(original.toString, "de").get("title") == "Übersicht");
// }
