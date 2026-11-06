/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.ui5.i18ns.loader;

import uim.ui5;

import std.algorithm.searching : find;
import std.array : split;
import std.json : JSONType, JSONValue, parseJSON;
import std.path : baseName, extension, stripExtension;
import std.string : representation;
import std.utf : UTFException, validate;

mixin(ShowModule!());

@safe:

/// Language file formats that can be loaded into an I18nStore
enum I18nFormat {
  unknown,
  json,
  properties,
  po,
  mo
}

/// Deepest nesting accepted in a JSON language file, as the parser recurses and fibers have small stacks
enum int maxI18nJsonDepth = 64;

/// Detects the format of a language file from its extension (case-insensitive)
I18nFormat detectI18nFormat(string fileName) {
  switch (fileName.extension.toLower) {
    case ".json":
      return I18nFormat.json;
    case ".properties":
      return I18nFormat.properties;
    case ".po":
      return I18nFormat.po;
    case ".mo":
      return I18nFormat.mo;
    default:
      return I18nFormat.unknown;
  }
}

/// Normalizes a locale to the UI5 file name form, e.g. "de-at" to "de_AT".
/// Returns: the normalized locale, or null if the value is not a valid locale
string normalizeI18nLocale(string value) {
  import std.ascii : isAlpha, isAlphaNum;
  import std.algorithm.searching : all;

  auto parts = value.strip.replace("-", "_").split("_");
  foreach (i, part; parts) {
    immutable bool validPart = i == 0
      ? part.length >= 2 && part.length <= 3 && part.all!isAlpha
      : part.length >= 2 && part.length <= 8 && part.all!isAlphaNum;
    if (!validPart) {
      return null;
    }
    if (i == 0) {
      parts[i] = part.toLower;
    } else if (part.length == 2) {
      parts[i] = part.toUpper;
    }
  }
  return parts.join("_");
}

/// Derives the locale from a file name, e.g. "i18n_de_AT.properties" to "de_AT".
/// Only two-letter languages are recognized, so that names like "main.json" do not count as a locale.
/// Returns: the locale, or null for a default bundle like "i18n.properties"
string i18nLocaleFromFileName(string fileName) {
  import std.ascii : isLower, isUpper;
  import std.algorithm.searching : all;

  auto parts = fileName.baseName.stripExtension.replace("-", "_").replace(".", "_").split("_");
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

/// Parses a language file into a bundle.
///
/// The locale comes from the locale parameter, otherwise from the Language header of a .po or .mo file,
/// otherwise from the file name. Without any of these the result is the default bundle (empty locale).
///
/// Throws: I18nParseException if the format is unknown, the locale invalid or the content malformed
I18nStore loadI18nFile(string fileName, const(ubyte)[] content, string locale = null) {
  string normalized;
  if (locale.length > 0) {
    normalized = normalizeI18nLocale(locale);
    if (normalized.length == 0) {
      throw new I18nParseException("Invalid locale '%s'".format(locale));
    }
  }

  I18nStore bundle;
  final switch (detectI18nFormat(fileName)) {
    case I18nFormat.json:
      bundle = parseI18nJson(content, normalized);
      break;
    case I18nFormat.properties:
      bundle = parseProperties(decodeProperties(content), normalized);
      break;
    case I18nFormat.po:
      bundle = parsePo(content, normalized);
      break;
    case I18nFormat.mo:
      bundle = parseMo(content, normalized);
      break;
    case I18nFormat.unknown:
      throw new I18nParseException("Unsupported language file '%s'".format(fileName));
  }

  if (bundle.locale.length == 0) {
    bundle.locale(i18nLocaleFromFileName(fileName));
  }
  return bundle;
}

// #region text decoding
private const(ubyte)[] stripBom(const(ubyte)[] content) {
  return content.length >= 3 && content[0] == 0xEF && content[1] == 0xBB && content[2] == 0xBF
    ? content[3 .. $] : content;
}

private bool isValidUtf8(string text) {
  try {
    validate(text);
    return true;
  } catch (UTFException) {
    return false;
  }
}

private string decodeUtf8(const(ubyte)[] bytes) {
  auto text = (cast(const(char)[])bytes).idup;
  if (!isValidUtf8(text)) {
    throw new I18nParseException("Content is not valid UTF-8");
  }
  return text;
}

private string decodeLatin1(const(ubyte)[] bytes) {
  auto result = appender!string;
  foreach (b; bytes) {
    result.put(cast(dchar)b);
  }
  return result.data;
}

/// Decodes bytes of a gettext charset. "CHARSET" is the placeholder of an unfilled .pot template.
private string decodeCharset(const(ubyte)[] bytes, string charset) {
  switch (charset.toLower) {
    case "":
    case "charset":
    case "utf-8":
    case "utf8":
    case "ascii":
    case "us-ascii":
      return decodeUtf8(bytes);
    case "iso-8859-1":
    case "iso8859-1":
    case "latin1":
      return decodeLatin1(bytes);
    default:
      throw new I18nParseException("Unsupported charset '%s'".format(charset));
  }
}

/// .properties files are UTF-8 in current tools, but ISO-8859-1 by the original Java definition
private string decodeProperties(const(ubyte)[] content) {
  auto bytes = stripBom(content);
  auto text = (cast(const(char)[])bytes).idup;
  return isValidUtf8(text) ? text : decodeLatin1(bytes);
}

/// Reads the charset from a gettext header. Works on bytes, as the text cannot be decoded before it is known.
private string gettextCharset(const(ubyte)[] header) {
  import std.ascii : isAlphaNum;

  auto contentType = header.find("Content-Type:".representation);
  auto rest = contentType.find("charset=".representation);
  if (rest.length == 0 || contentType[0 .. $ - rest.length].find(cast(ubyte)'\n').length > 0) {
    return null;
  }
  rest = rest["charset=".length .. $];

  size_t end;
  while (end < rest.length
    && (isAlphaNum(rest[end]) || rest[end] == '-' || rest[end] == '_' || rest[end] == '.')) {
    end++;
  }
  return decodeLatin1(rest[0 .. end]);
}

/// Reads the locale from the Language field of a gettext header, e.g. "de_AT.UTF-8" gives "de_AT"
private string gettextLanguage(string header) {
  foreach (line; header.split("\n")) {
    auto separator = line.indexOf(':');
    if (separator > 0 && line[0 .. separator].strip.toLower == "language") {
      auto value = line[separator + 1 .. $].strip;
      foreach (i, c; value) {
        if (c == '.' || c == '@') {
          value = value[0 .. i];
          break;
        }
      }
      return normalizeI18nLocale(value);
    }
  }
  return null;
}
// #endregion text decoding

// #region JSON
/// Parses a JSON language file. Nested objects and arrays are flattened to dotted keys,
/// so {"app": {"title": "x"}} gives the key "app.title". Keys are sorted, as JSON objects are unordered.
///
/// This uses std.json and not vibe.data.json, whose parser has no depth limit
/// and runs off the end of its input on a truncated number such as {"a":-
///
/// Throws: I18nParseException on malformed JSON, or if the root is not an object
I18nStore parseI18nJson(const(ubyte)[] content, string locale = null) {
  auto text = decodeUtf8(stripBom(content));

  JSONValue root;
  try {
    root = parseJSON(text, maxI18nJsonDepth);
  } catch (Exception e) { // JSONException, or ConvException for a number out of range
    throw new I18nParseException("Invalid JSON: " ~ e.msg);
  }
  if (root.type != JSONType.object) {
    throw new I18nParseException("The root of a JSON language file must be an object");
  }

  auto bundle = new I18nStore(locale);
  flattenJson(bundle, null, root);
  return bundle;
}

private void flattenJson(I18nStore bundle, string prefix, JSONValue value) {
  switch (value.type) {
    case JSONType.object:
      auto members = value.objectNoRef;
      foreach (name; members.keys.sort) {
        flattenJson(bundle, prefix.length > 0 ? prefix ~ "." ~ name : name, members[name]);
      }
      break;
    case JSONType.array:
      foreach (i, item; value.arrayNoRef) {
        flattenJson(bundle, "%s.%d".format(prefix, i), item);
      }
      break;
    case JSONType.null_:
      break;
    case JSONType.string:
      if (prefix.length > 0) {
        bundle.set(prefix, value.str);
      }
      break;
    default: // Numbers and booleans
      if (prefix.length > 0) {
        bundle.set(prefix, value.toString);
      }
  }
}
// #endregion JSON

// #region gettext
/// Adds a gettext message. An untranslated message is skipped, as msgfmt does.
///
/// The bundle is flat, so a msgctxt becomes a prefix ("menu.Open") and plural form n > 0
/// is stored under "key[n]". The key itself holds the singular form.
private void addGettextMessage(I18nStore bundle, string context, string id, const string[] forms) {
  if (forms.length == 0 || forms[0].length == 0) {
    return;
  }
  immutable key = context.length > 0 ? context ~ "." ~ id : id;
  bundle.set(key, forms[0]);
  foreach (i, form; forms[1 .. $]) {
    if (form.length > 0) {
      bundle.set("%s[%d]".format(key, i + 1), form);
    }
  }
}

/// Parses a gettext .po file. Fuzzy and obsolete messages are skipped, as msgfmt does.
/// Throws: I18nParseException on malformed content, with the line number
I18nStore parsePo(const(ubyte)[] content, string locale = null) {
  enum Section {
    none,
    context,
    id,
    plural,
    form
  }

  struct Message {
    string context;
    string id;
    string[] forms;
    bool hasId;
    bool fuzzy;
  }

  auto bytes = stripBom(content);
  auto text = decodeCharset(bytes, gettextCharset(bytes));

  auto bundle = new I18nStore(locale);
  string language;
  Message message;
  Section section;
  size_t lineNumber;

  void fail(string problem) {
    throw new I18nParseException("Line %d: %s".format(lineNumber, problem));
  }

  // A message ends with the first line after its msgstr that is not a continuation
  void finishMessage() {
    if (section != Section.form) {
      return;
    }
    if (message.id.length == 0 && message.context.length == 0) {
      if (message.forms.length > 0) {
        language = gettextLanguage(message.forms[0]);
      }
    } else if (!message.fuzzy) {
      addGettextMessage(bundle, message.context, message.id, message.forms);
    }
    message = Message.init;
    section = Section.none;
  }

  foreach (rawLine; text.split("\n")) {
    lineNumber++;
    auto line = rawLine.strip;
    if (line.length == 0) {
      continue;
    }
    if (line[0] == '#') {
      finishMessage();
      if (line.startsWith("#,")) {
        foreach (flag; line[2 .. $].split(",")) {
          message.fuzzy = message.fuzzy || flag.strip == "fuzzy";
        }
      }
      continue;
    }

    auto quote = line.indexOf('"');
    if (quote < 0) {
      fail("Expected a quoted string");
    }
    auto keyword = line[0 .. quote].strip;
    auto value = unquotePo(line[quote .. $], lineNumber);

    if (keyword.length == 0) {
      final switch (section) {
        case Section.none:
          fail("String without a keyword");
          break;
        case Section.context:
          message.context ~= value;
          break;
        case Section.id:
          message.id ~= value;
          break;
        case Section.plural:
          break; // The bundle is keyed by msgid
        case Section.form:
          message.forms[$ - 1] ~= value;
          break;
      }
    } else if (keyword == "msgctxt") {
      finishMessage();
      if (section != Section.none) {
        fail("msgctxt inside a message");
      }
      message.context = value;
      section = Section.context;
    } else if (keyword == "msgid") {
      finishMessage();
      if (message.hasId) {
        fail("msgid without msgstr");
      }
      message.id = value;
      message.hasId = true;
      section = Section.id;
    } else if (keyword == "msgid_plural") {
      if (section != Section.id) {
        fail("msgid_plural without msgid");
      }
      section = Section.plural;
    } else if (keyword == "msgstr" || keyword.startsWith("msgstr[")) {
      if (!message.hasId) {
        fail("msgstr without msgid");
      }
      // Plural forms must be consecutive, which also bounds the size of the forms array
      immutable expected = keyword == "msgstr" ? "msgstr" : "msgstr[%d]".format(message.forms.length);
      if (keyword != expected || (keyword == "msgstr" && message.forms.length > 0)) {
        fail("Unexpected '%s'".format(keyword));
      }
      message.forms ~= value;
      section = Section.form;
    } else {
      fail("Unknown keyword '%s'".format(keyword));
    }
  }

  lineNumber++;
  finishMessage();
  if (message.hasId) {
    fail("msgid without msgstr");
  }
  if (bundle.locale.length == 0) {
    bundle.locale(language);
  }
  return bundle;
}

/// Removes the quotes of a .po string and resolves its C escapes
private string unquotePo(string quoted, size_t lineNumber) {
  void fail(string problem) {
    throw new I18nParseException("Line %d: %s".format(lineNumber, problem));
  }

  auto result = appender!string;
  size_t i = 1;
  while (i < quoted.length) {
    immutable char c = quoted[i];
    if (c == '"') {
      if (i != quoted.length - 1) {
        fail("Text after the closing quote");
      }
      return result.data;
    }
    if (c != '\\') {
      result.put(c);
      i++;
      continue;
    }
    if (i + 1 >= quoted.length) {
      break;
    }
    switch (quoted[i + 1]) {
      case 'n':
        result.put('\n');
        break;
      case 't':
        result.put('\t');
        break;
      case 'r':
        result.put('\r');
        break;
      case 'a':
        result.put('\a');
        break;
      case 'b':
        result.put('\b');
        break;
      case 'f':
        result.put('\f');
        break;
      case 'v':
        result.put('\v');
        break;
      case '"':
        result.put('"');
        break;
      case '\\':
        result.put('\\');
        break;
      default:
        fail("Unsupported escape sequence \\%s".format(quoted[i + 1]));
    }
    i += 2;
  }
  fail("Missing closing quote");
  assert(0);
}

/// Parses a compiled gettext .mo file. Offsets come from the file, so all of them are checked.
/// Throws: I18nParseException on a truncated or malformed file
I18nStore parseMo(const(ubyte)[] content, string locale = null) {
  enum size_t headerSize = 20;
  enum size_t tableEntrySize = 8;

  if (content.length < headerSize) {
    throw new I18nParseException("File is too short for a .mo header");
  }

  bool bigEndian;
  if (content[0 .. 4] == [0xDE, 0x12, 0x04, 0x95]) {
    bigEndian = false;
  } else if (content[0 .. 4] == [0x95, 0x04, 0x12, 0xDE]) {
    bigEndian = true;
  } else {
    throw new I18nParseException("Not a .mo file");
  }

  uint read32(size_t position) {
    auto b = content[position .. position + 4];
    return bigEndian
      ? (cast(uint)b[0] << 24) | (b[1] << 16) | (b[2] << 8) | b[3]
      : (cast(uint)b[3] << 24) | (b[2] << 16) | (b[1] << 8) | b[0];
  }

  if (read32(4) >> 16 > 1) {
    throw new I18nParseException("Unsupported .mo revision");
  }
  immutable ulong count = read32(8);
  immutable ulong originals = read32(12);
  immutable ulong translations = read32(16);
  if (originals + count * tableEntrySize > content.length
    || translations + count * tableEntrySize > content.length) {
    throw new I18nParseException("String table exceeds the file");
  }

  // Entries may point anywhere, so many of them could share one large string. Without
  // this budget a small file could expand to far more memory than its own size.
  ulong budget = content.length;
  const(ubyte)[] stringAt(ulong table, size_t index) {
    immutable position = cast(size_t)(table + index * tableEntrySize);
    immutable ulong length = read32(position);
    immutable ulong offset = read32(position + 4);
    if (offset + length > content.length) {
      throw new I18nParseException("String %d exceeds the file".format(index));
    }
    if (length > budget) {
      throw new I18nParseException("Strings overlap");
    }
    budget -= length;
    return content[cast(size_t)offset .. cast(size_t)(offset + length)];
  }

  auto ids = new const(ubyte)[][cast(size_t)count];
  auto values = new const(ubyte)[][cast(size_t)count];
  string charset;
  foreach (i; 0 .. cast(size_t)count) {
    ids[i] = stringAt(originals, i);
    values[i] = stringAt(translations, i);
    if (ids[i].length == 0) {
      charset = gettextCharset(values[i]);
    }
  }

  auto bundle = new I18nStore(locale);
  string language;
  foreach (i; 0 .. cast(size_t)count) {
    auto translation = decodeCharset(values[i], charset);
    if (ids[i].length == 0) {
      language = gettextLanguage(translation);
      continue;
    }

    // An original is "context EOT msgid NUL msgid_plural", a translation is "form NUL form ..."
    auto original = decodeCharset(ids[i], charset);
    string context;
    auto separator = original.indexOf('\x04');
    if (separator >= 0) {
      context = original[0 .. separator];
      original = original[separator + 1 .. $];
    }
    auto end = original.indexOf('\0');
    addGettextMessage(bundle, context, end >= 0 ? original[0 .. end] : original, translation.split("\0"));
  }

  if (bundle.locale.length == 0) {
    bundle.locale(language);
  }
  return bundle;
}
// #endregion gettext

version (unittest) {
  import std.exception : assertThrown;

  private const(ubyte)[] bytes(string text) {
    return text.representation;
  }

  /// Builds a .mo file with the strings stored right behind the tables
  private ubyte[] buildMo(string[2][] messages, bool bigEndian = false) {
    ubyte[] put32(uint value) {
      ubyte[] b = [
        cast(ubyte)value, cast(ubyte)(value >> 8), cast(ubyte)(value >> 16), cast(ubyte)(value >> 24)
      ];
      return bigEndian ? [b[3], b[2], b[1], b[0]] : b;
    }

    immutable uint count = cast(uint)messages.length;
    immutable uint originals = 28;
    immutable uint translations = originals + count * 8;
    uint offset = translations + count * 8;

    ubyte[] tables, strings;
    foreach (column; 0 .. 2) {
      foreach (message; messages) {
        tables ~= put32(cast(uint)message[column].length) ~ put32(offset);
        strings ~= message[column].representation ~ cast(ubyte)0;
        offset += message[column].length + 1;
      }
    }
    return put32(0x950412de) ~ put32(0) ~ put32(count) ~ put32(originals) ~ put32(translations)
      ~ put32(0) ~ put32(0) ~ tables ~ strings;
  }
}

/// Format and locale detection
unittest {
  assert(detectI18nFormat("i18n_de.properties") == I18nFormat.properties);
  assert(detectI18nFormat("de.PO") == I18nFormat.po);
  assert(detectI18nFormat("/a/b/de.mo") == I18nFormat.mo);
  assert(detectI18nFormat("de.json") == I18nFormat.json);
  assert(detectI18nFormat("de.txt") == I18nFormat.unknown);
  assert(detectI18nFormat("po") == I18nFormat.unknown);

  assert(normalizeI18nLocale("de") == "de");
  assert(normalizeI18nLocale("DE-at") == "de_AT");
  assert(normalizeI18nLocale("zh_Hant_TW") == "zh_Hant_TW");
  assert(normalizeI18nLocale("../de") is null);
  assert(normalizeI18nLocale("de_") is null);
  assert(normalizeI18nLocale("d") is null);

  assert(i18nLocaleFromFileName("i18n_de.properties") == "de");
  assert(i18nLocaleFromFileName("i18n_de_AT.properties") == "de_AT");
  assert(i18nLocaleFromFileName("en-US.json") == "en_US");
  assert(i18nLocaleFromFileName("messages.fr.po") == "fr");
  assert(i18nLocaleFromFileName("de.mo") == "de");
  assert(i18nLocaleFromFileName("i18n.properties") is null);
  assert(i18nLocaleFromFileName("main.json") is null);
}

/// .properties
unittest {
  auto parsed = parseProperties("# Comment\nappTitle=My App\ngreeting=Hello {0}\n\nempty=\n");
  assert(parsed.length == 3);
  assert(parsed.get("appTitle") == "My App");
  assert(parsed.get("greeting") == "Hello {0}");
  assert(parsed.get("empty") == "");

  // java.util.Properties syntax
  parsed = parseProperties("a: 1\r\nb 2\r\nc\\:d = 3\nlong = one \\\n    two\nflag\n! comment\n");
  assert(parsed.get("a") == "1");
  assert(parsed.get("b") == "2");
  assert(parsed.get("c:d") == "3");
  assert(parsed.get("long") == "one two");
  assert(parsed.has("flag") && parsed.get("flag") == "");
  assert(parsed.length == 5);

  // Even backslashes at the end do not continue the line
  assert(parseProperties("a=b\\\\\nc=d").get("a") == `b\`);
  // A file may end in the middle of an escape or a continuation
  assert(parseProperties("a\\").has("a"));
  assert(parseProperties("a=b\\").get("a") == "b");

  // Unicode: BMP, surrogate pairs, a lone surrogate, and non-ASCII after a backslash
  assert(unescapeProperties(`ü`) == "ü");
  assert(unescapeProperties(`😀`) == "😀");
  assert(unescapeProperties(`\uD83Dx`) == "�x");
  assert(unescapeProperties(`\ü`) == "ü");
  assert(unescapeProperties(`a\rb`) == "a\rb");
  assertThrown!I18nParseException(unescapeProperties(`\u12`));
  assertThrown!I18nParseException(unescapeProperties(`\u12G4`));

  // Round trips through toString, with keys and values that need escaping
  auto original = new I18nStore("de")
    .set("Hello world: #1", "Übersicht = 😀")
    .set("!key", "  leading\ttab\r\nend  ")
    .set("back\\slash", "x\\");
  auto copy = parseProperties(original.toString, "de");
  assert(copy.keys == original.keys);
  foreach (key; original.keys) {
    assert(copy.get(key) == original.get(key), key);
  }

  // Encoding of uploaded files
  assert(loadI18nFile("de.properties", cast(ubyte[])[0xEF, 0xBB, 0xBF, 'a', '=', 0xC3, 0xBC]).get("a") == "ü");
  assert(loadI18nFile("de.properties", cast(ubyte[])['a', '=', 0xFC]).get("a") == "ü"); // ISO-8859-1
}

/// JSON
unittest {
  auto parsed = loadI18nFile("i18n_de.json", bytes(`{
    "z": "Ü", "app": {"title": "T", "tabs": ["a", {"b": "c"}]}, "n": 5, "yes": true, "skip": null
  }`));
  assert(parsed.locale == "de");
  assert(parsed.keys == ["app.tabs.0", "app.tabs.1.b", "app.title", "n", "yes", "z"]);
  assert(parsed.get("app.title") == "T");
  assert(parsed.get("app.tabs.1.b") == "c");
  assert(parsed.get("n") == "5");
  assert(parsed.get("yes") == "true");
  assert(parsed.get("z") == "Ü");

  assertThrown!I18nParseException(parseI18nJson(bytes(`["a"]`)));
  assertThrown!I18nParseException(parseI18nJson(bytes(`{"a":`)));
  assertThrown!I18nParseException(parseI18nJson(bytes("")));
  assertThrown!I18nParseException(parseI18nJson(cast(ubyte[])['{', '"', 0xFF, '"', ':', '1', '}']));

  // Truncated numbers crash vibe.data.json, which is why this parser does not use it
  foreach (bad; [`{"a":-`, `{"a":1e`, `{"a":1.`, `{"a":1e+`, `-`]) {
    assertThrown!I18nParseException(parseI18nJson(bytes(bad)), bad);
  }
  // std.json reports a number out of range with a ConvException
  assertThrown!I18nParseException(parseI18nJson(bytes(`{"a":1e999}`)));

  // Deep nesting is rejected by the depth limit of the parser
  import std.array : replicate;
  assertThrown!I18nParseException(parseI18nJson(bytes("[".replicate(1_000_000))));
  assertThrown!I18nParseException(parseI18nJson(bytes(`{"a":` .replicate(1_000_000))));
  // Brackets in strings do not count
  assert(parseI18nJson(bytes(`{"a":"` ~ "[".replicate(1000) ~ `\""}`)).length == 1);
}

/// .po
unittest {
  auto po = `# Translator comment
msgid ""
msgstr ""
"Project-Id-Version: x\n"
"Language: de_AT.UTF-8\n"
"Content-Type: text/plain; charset=UTF-8\n"

#: src/a.c:1
msgid "Hello world"
msgstr "Hallo Welt"

msgid ""
"multi "
"line"
msgstr ""
"mehr\n"
"zeilig \"x\" \\ \t"

msgctxt "menu"
msgid "Open"
msgstr "Öffnen"

msgid "One file"
msgid_plural "%d files"
msgstr[0] "Eine Datei"
msgstr[1] "%d Dateien"
msgstr[2] ""

msgid "untranslated"
msgstr ""

#, c-format, fuzzy
msgid "guess"
msgstr "Vermutung"

#, c-format
msgid "sure"
msgstr "sicher"

#~ msgid "old"
#~ msgstr "alt"
`;
  auto parsed = parsePo(bytes(po));
  assert(parsed.locale == "de_AT");
  assert(parsed.keys == ["Hello world", "multi line", "menu.Open", "One file", "One file[1]", "sure"]);
  assert(parsed.get("Hello world") == "Hallo Welt");
  assert(parsed.get("multi line") == "mehr\nzeilig \"x\" \\ \t");
  assert(parsed.get("menu.Open") == "Öffnen");
  assert(parsed.get("One file") == "Eine Datei");
  assert(parsed.get("One file[1]") == "%d Dateien");

  // An explicit locale wins over the header, and the header over the file name
  assert(parsePo(bytes(po), "fr").locale == "fr");
  assert(loadI18nFile("fr.po", bytes(po)).locale == "de_AT");
  assert(loadI18nFile("fr.po", bytes("msgid \"a\"\nmsgstr \"b\"\n")).locale == "fr");
  assert(loadI18nFile("x.po", bytes("msgid \"a\"\r\nmsgstr \"b\"\r\n")).get("a") == "b");

  // Charsets
  auto latin1 = `msgid ""
msgstr "Content-Type: text/plain; charset=ISO-8859-1\n"
msgid "a"
msgstr "`.representation ~ cast(ubyte)0xFC ~ `"`.representation;
  assert(parsePo(latin1).get("a") == "ü");
  assertThrown!I18nParseException(parsePo(bytes(
    "msgid \"\"\nmsgstr \"Content-Type: text/plain; charset=KOI8-R\\n\"\n")));
  assertThrown!I18nParseException(parsePo(cast(ubyte[])['m', 's', 'g', 0xFF]));

  // Malformed files
  foreach (bad; [
    `msgstr "a"`, `msgid "a"`, `msgid "a" "b`, `msgid "a`, `msgid "a\`, `msgid "\q"`, `"a"`, `nonsense`,
    `foo "a"`, "msgid \"a\"\nmsgid \"b\"\nmsgstr \"c\"", "msgid \"a\"\nmsgstr[1] \"b\"",
    "msgid \"a\"\nmsgstr[99999999] \"b\"", "msgid \"a\"\nmsgstr[x] \"b\"", "msgid \"a\"\nmsgstr \"b\"\nmsgid_plural \"c\"",
  ]) {
    assertThrown!I18nParseException(parsePo(bytes(bad)), bad);
  }
}

/// .mo
unittest {
  string[2][] messages = [
    ["", "Language: de\nContent-Type: text/plain; charset=UTF-8\n"],
    ["Hello", "Hallo"],
    ["One file\0%d files", "Eine Datei\0%d Dateien"],
    ["menu\x04Open", "Öffnen"],
  ];

  foreach (bigEndian; [false, true]) {
    auto parsed = parseMo(buildMo(messages, bigEndian));
    assert(parsed.locale == "de");
    assert(parsed.keys == ["Hello", "One file", "One file[1]", "menu.Open"]);
    assert(parsed.get("Hello") == "Hallo");
    assert(parsed.get("One file[1]") == "%d Dateien");
    assert(parsed.get("menu.Open") == "Öffnen");
  }

  // Patched afterwards, as a D string literal cannot hold the ISO-8859-1 byte
  auto file = buildMo([["", "Content-Type: text/plain; charset=ISO-8859-1\n"], ["a", "?"]]);
  file[$ - 2] = 0xFC;
  assert(parseMo(file).get("a") == "ü");

  // Malformed files must fail cleanly, whichever field is damaged
  auto valid = buildMo(messages);
  assertThrown!I18nParseException(parseMo(null));
  assertThrown!I18nParseException(parseMo(valid[0 .. 19]));
  assertThrown!I18nParseException(parseMo(bytes("this is not a .mo file at all")));

  foreach (position; [8, 12, 16, 28, 32]) { // Count, table offsets, first string length and offset
    auto damaged = valid.dup;
    damaged[position .. position + 4] = 0xFF;
    assertThrown!I18nParseException(parseMo(damaged));
  }
  auto newerRevision = valid.dup;
  newerRevision[6] = 2;
  assertThrown!I18nParseException(parseMo(newerRevision));

  // Truncating never reads out of bounds
  foreach (length; 0 .. valid.length) {
    try {
      parseMo(valid[0 .. length]);
    } catch (I18nParseException) {
    }
  }

  // Many entries sharing one large string must not expand in memory
  auto bomb = buildMo([["a", "b"], ["c", "d"]]);
  auto table = 28 + 2 * 8; // Translation table
  bomb[table + 8 .. table + 16] = bomb[table .. table + 8];
  bomb[table] = 40;
  bomb[table + 8] = 40;
  assertThrown!I18nParseException(parseMo(bomb));
}

/// All formats give the same bundle
unittest {
  auto fromProperties = loadI18nFile("i18n_de.properties", bytes("title=Titel\n"));
  auto fromJson = loadI18nFile("i18n_de.json", bytes(`{"title":"Titel"}`));
  auto fromPo = loadI18nFile("i18n_de.po", bytes("msgid \"title\"\nmsgstr \"Titel\"\n"));
  auto fromMo = loadI18nFile("i18n_de.mo", buildMo([["title", "Titel"]]));
  foreach (bundle; [fromProperties, fromJson, fromPo, fromMo]) {
    assert(bundle.locale == "de");
    assert(bundle.toString == "title=Titel\n");
  }

  assertThrown!I18nParseException(loadI18nFile("de.txt", bytes("x")));
  assertThrown!I18nParseException(loadI18nFile("de.po", bytes(""), "../x"));
  assert(loadI18nFile("i18n.properties", bytes("a=b")).locale == "");
}
