/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.i18ns.bundle;

import uim.ui5;

mixin(ShowModule!());

@safe:

/// A UI5 i18n resource bundle (content of an i18n.properties file).
class Ui5I18nBundle {
  this(string locale = null) {
    _locale = locale;
  }

  /// The locale of the bundle, e.g. "de" (empty = default bundle)
  string locale() const {
    return _locale;
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
        result.put("%s=%s\n".format(key, escapeProperties(*value)));
      }
    }
    return result.data;
  }

  private string _locale;
  private string[string] _entries;
  private string[] _order;
  private string[size_t] _comments;
}

/// Creates an i18n bundle, e.g. ui5I18nBundle("de")
Ui5I18nBundle ui5I18nBundle(string locale = null) {
  return new Ui5I18nBundle(locale);
}

/// Escapes a value for a .properties file (special characters and non-ASCII)
string escapeProperties(string value) {
  auto result = appender!string;
  foreach (dchar c; value) {
    switch (c) {
      case '\\':
        result.put("\\\\");
        break;
      case '\n':
        result.put("\\n");
        break;
      case '\t':
        result.put("\\t");
        break;
      case '=':
        result.put("\\=");
        break;
      default:
        if (c > 127) {
          result.put("\\u%04X".format(cast(uint)c));
        } else {
          result.put(c);
        }
    }
  }
  return result.data;
}

/// Parses .properties content into a bundle
Ui5I18nBundle parseProperties(string content, string locale = null) {
  auto bundle = new Ui5I18nBundle(locale);
  foreach (line; content.splitLines) {
    string trimmed = line.strip;
    if (trimmed.length == 0) {
      continue;
    }
    if (trimmed.startsWith("#") || trimmed.startsWith("!")) {
      bundle.comment(trimmed[1 .. $].strip);
      continue;
    }
    auto eqIndex = trimmed.countUntil('=');
    if (eqIndex > 0) {
      bundle.set(trimmed[0 .. eqIndex].strip, unescapeProperties(trimmed[eqIndex + 1 .. $].strip));
    }
  }
  return bundle;
}

/// Unescapes a .properties value
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
        case 't':
          result.put('\t');
          i += 2;
          break;
        case '\\':
          result.put('\\');
          i += 2;
          break;
        case '=':
          result.put('=');
          i += 2;
          break;
        case 'u':
          if (i + 6 <= value.length) {
            result.put(cast(dchar)value[i + 2 .. i + 6].to!uint(16));
            i += 6;
          } else {
            result.put(value[i]);
            i++;
          }
          break;
        default:
          result.put(value[i + 1]);
          i += 2;
      }
    } else {
      result.put(value[i]);
      i++;
    }
  }
  return result.data;
}

///
unittest {
  // bundle basics
  auto bundle = new Ui5I18nBundle;
  assert(bundle.locale is null);
  assert(bundle.length == 0);
  assert(bundle.fileName == "i18n.properties");

  bundle.set("appTitle", "My App").set("saveButton", "Save");
  assert(bundle.length == 2);
  assert(bundle.has("appTitle"));
  assert(!bundle.has("missing"));
  assert(bundle.get("appTitle") == "My App");
  assert(bundle.get("missing") is null);
  assert(bundle.keys == ["appTitle", "saveButton"]);
  assert(bundle.toString == "appTitle=My App\nsaveButton=Save\n");

  // localized bundle
  auto german = ui5I18nBundle("de");
  assert(german.locale == "de");
  assert(german.fileName == "i18n_de.properties");
  assert(german.fileName("texts") == "texts_de.properties");

  // placeholders
  bundle.setWithPlaceholders("greeting", "Hello {0}, you have {1} tasks");
  assert(bundle.get("greeting") == "Hello {0}, you have {1} tasks");

  // comments
  auto commented = ui5I18nBundle()
    .comment("Application texts")
    .set("appTitle", "My App");
  assert(commented.toString == "# Application texts\nappTitle=My App\n");

  // remove
  bundle.remove("saveButton");
  assert(!bundle.has("saveButton"));
  assert(bundle.keys == ["appTitle", "greeting"]);

  // escaping
  assert(escapeProperties("a=b") == `a\=b`);
  assert(escapeProperties("a\\b") == `a\\b`);
  assert(escapeProperties("ü") == `\u00FC`); // ü is U+00FC
  assert(escapeProperties("line\nbreak") == `line\nbreak`);

  // unescaping
  assert(unescapeProperties(`a\=b`) == "a=b");
  assert(unescapeProperties(`a\\b`) == `a\b`);
  assert(unescapeProperties(`\u00FC`) == "ü");
  assert(unescapeProperties(`line\nbreak`) == "line\nbreak");

  // parsing
  auto parsed = parseProperties("# Comment\nappTitle=My App\ngreeting=Hello {0}\n\nempty=\n");
  assert(parsed.length == 3);
  assert(parsed.get("appTitle") == "My App");
  assert(parsed.get("greeting") == "Hello {0}");
  assert(parsed.get("empty") == "");

  // round trip with unicode
  auto original = ui5I18nBundle("de").set("title", "Übersicht");
  assert(parseProperties(original.toString, "de").get("title") == "Übersicht");
}
