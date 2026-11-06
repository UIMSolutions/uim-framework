/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.formats.gettext;

import uim.i18n;

import std.algorithm.searching : all, find;
import std.array : appender, split;
import std.string : format, indexOf, representation, startsWith, strip, toLower;

mixin(ShowModule!());

@safe:

// #region header
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

/// The header entry of a .po file, which is the first entry if it has an empty msgid. An ordinary
/// message may mention "charset=" in its text, and that must not count.
/// Returns: the bytes up to the end of the header, or null if the file has no header
private const(ubyte)[] poHeaderBytes(const(ubyte)[] bytes) {
  const(ubyte)[] skipSpace(const(ubyte)[] text) {
    while (text.length > 0 && (text[0] == ' ' || text[0] == '\t' || text[0] == '\r' || text[0] == '\n')) {
      text = text[1 .. $];
    }
    return text;
  }

  auto first = bytes.find("msgid".representation);
  if (first.length == 0) {
    return null;
  }
  first = first["msgid".length .. $];

  // A long msgid also starts with "", but it goes on with a string instead of msgstr
  auto id = skipSpace(first);
  if (!id.startsWith(`""`.representation) || !skipSpace(id[2 .. $]).startsWith("msgstr".representation)) {
    return null;
  }
  return bytes[0 .. $ - first.find("\nmsgid".representation).length];
}

/// Reads a field of a decoded gettext header
private string gettextHeaderField(string header, string name) {
  foreach (line; header.split("\n")) {
    auto separator = line.indexOf(':');
    if (separator > 0 && line[0 .. separator].strip.toLower == name) {
      return line[separator + 1 .. $].strip;
    }
  }
  return null;
}

/// Takes over locale and plural rule from a decoded gettext header.
/// Throws: I18nParseException on a malformed Plural-Forms field
private void applyGettextHeader(I18nCatalog catalog, string header) {
  if (catalog.locale.length == 0) {
    catalog.locale(normalizeLocale(gettextHeaderField(header, "language")));
  }

  auto pluralForms = gettextHeaderField(header, "plural-forms");
  // "nplurals=INTEGER; plural=EXPRESSION;" is the placeholder of an unfilled .pot template
  if (pluralForms.length > 0 && pluralForms.indexOf("INTEGER") < 0) {
    catalog.pluralRule(I18nPluralRule.parse(pluralForms));
  }
}

/// Adds a gettext message. An untranslated message is skipped, as msgfmt does.
private void addGettextMessage(I18nCatalog catalog, string context, string id, string pluralId, string[] forms) {
  if (forms.all!(form => form.length == 0)) {
    return;
  }
  catalog.add(I18nMessage(id, context, pluralId, forms));
}
// #endregion header

// #region po
/// Parses a gettext .po file. Fuzzy and obsolete messages are skipped, as msgfmt does.
/// Throws: I18nParseException on malformed content, with the line number
I18nCatalog parsePo(const(ubyte)[] content, string locale = null) {
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
    string pluralId;
    string[] forms;
    bool hasId;
    bool fuzzy;
  }

  auto bytes = stripBom(content);
  auto text = decodeCharset(bytes, gettextCharset(poHeaderBytes(bytes)));

  auto catalog = new I18nCatalog(locale);
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
      applyGettextHeader(catalog, message.forms[0]);
    } else if (!message.fuzzy) {
      addGettextMessage(catalog, message.context, message.id, message.pluralId, message.forms);
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
          message.pluralId ~= value;
          break;
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
      message.pluralId = value;
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
  return catalog;
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
// #endregion po

// #region mo
/// Parses a compiled gettext .mo file. Offsets come from the file, so all of them are checked.
/// Throws: I18nParseException on a truncated or malformed file
I18nCatalog parseMo(const(ubyte)[] content, string locale = null) {
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

  auto catalog = new I18nCatalog(locale);
  foreach (i; 0 .. cast(size_t)count) {
    auto translation = decodeCharset(values[i], charset);
    if (ids[i].length == 0) {
      applyGettextHeader(catalog, translation);
      continue;
    }

    // An original is "context EOT msgid NUL msgid_plural", a translation is "form NUL form ..."
    auto original = decodeCharset(ids[i], charset);
    string context, pluralId;
    auto separator = original.indexOf('\x04');
    if (separator >= 0) {
      context = original[0 .. separator];
      original = original[separator + 1 .. $];
    }
    auto end = original.indexOf('\0');
    if (end >= 0) {
      pluralId = original[end + 1 .. $];
      original = original[0 .. end];
    }
    addGettextMessage(catalog, context, original, pluralId, translation.split("\0"));
  }
  return catalog;
}
// #endregion mo

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

/// .po
unittest {
  auto po = `# Translator comment
msgid ""
msgstr ""
"Project-Id-Version: x\n"
"Language: de_AT.UTF-8\n"
"Content-Type: text/plain; charset=UTF-8\n"
"Plural-Forms: nplurals=3; plural=(n==1 ? 0 : n==2 ? 1 : 2);\n"

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

msgid "no forms"
msgid_plural "none"
msgstr[0] ""
msgstr[1] ""

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
  assert(parsed.pluralRule.count == 3);
  assert(parsed.length == 5);
  assert(parsed.get("Hello world") == "Hallo Welt");
  assert(parsed.get("multi line") == "mehr\nzeilig \"x\" \\ \t");
  assert(parsed.get("Open", "menu") == "Öffnen");
  assert(!parsed.has("Open"));
  assert(parsed.forms("One file") == ["Eine Datei", "%d Dateien", ""]);
  assert(parsed.messages[3].pluralKey == "%d files");
  assert(parsed.get("sure") == "sicher");
  assert(!parsed.has("untranslated") && !parsed.has("no forms") && !parsed.has("guess") && !parsed.has("old"));

  // An explicit locale wins over the header
  assert(parsePo(bytes(po), "fr").locale == "fr");
  assert(parsePo(bytes("msgid \"a\"\r\nmsgstr \"b\"\r\n")).get("a") == "b");
}

/// Headers
unittest {
  // Without a rule, the catalog uses the default of its locale
  assert(parsePo(bytes("msgid \"a\"\nmsgstr \"b\"\n"), "ru").pluralRule.count == 3);

  // A .pot template still has placeholders
  auto template_ = `msgid ""
msgstr ""
"Language: \n"
"Content-Type: text/plain; charset=CHARSET\n"
"Plural-Forms: nplurals=INTEGER; plural=EXPRESSION;\n"
`;
  assert(parsePo(bytes(template_)).locale == "");

  // A broken rule is an error and not silently ignored, as it would select wrong forms
  assertThrown!I18nParseException(parsePo(bytes(
    "msgid \"\"\nmsgstr \"Plural-Forms: nplurals=2; plural=(n;\\n\"\n")));

  // Only the header decides on the charset, not the text of a message
  assert(parsePo(bytes(`msgid "a"
msgstr "Content-Type: text/plain; charset=KOI8-R"

msgid "b"
msgstr "c"
`)).length == 2);
  assert(parsePo(bytes(`msgid "x"
msgstr "y"

msgid "Content-Type: text/plain; charset=KOI8-R"
msgstr "z"
`)).length == 2);
  assert(parsePo(bytes(`msgid ""
"long id"
msgstr "Content-Type: text/plain; charset=KOI8-R"
`)).get("long id").length > 0);
  assert(parsePo(bytes(`msgid ""
msgstr "Project-Id-Version: x\n"

msgid "a"
msgstr "Content-Type: text/plain; charset=KOI8-R"
`)).length == 1);
}

/// Charsets
unittest {
  auto latin1 = `msgid ""
msgstr "Content-Type: text/plain; charset=ISO-8859-1\n"

msgid "a"
msgstr "`.representation ~ cast(ubyte)0xFC ~ `"`.representation;
  assert(parsePo(latin1).get("a") == "ü");

  assertThrown!I18nParseException(parsePo(bytes(
    "msgid \"\"\nmsgstr \"Content-Type: text/plain; charset=KOI8-R\\n\"\n")));
  assertThrown!I18nParseException(parsePo(cast(ubyte[])['m', 's', 'g', 0xFF]));
}

/// Malformed .po files
unittest {
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
    ["", "Language: de\nContent-Type: text/plain; charset=UTF-8\nPlural-Forms: nplurals=2; plural=(n != 1);\n"],
    ["Hello", "Hallo"],
    ["One file\0%d files", "Eine Datei\0%d Dateien"],
    ["menu\x04Open", "Öffnen"],
    ["menu\x04One\0Many", "Eins\0Viele"],
  ];

  foreach (bigEndian; [false, true]) {
    auto parsed = parseMo(buildMo(messages, bigEndian));
    assert(parsed.locale == "de");
    assert(parsed.length == 4);
    assert(parsed.get("Hello") == "Hallo");
    assert(parsed.forms("One file") == ["Eine Datei", "%d Dateien"]);
    assert(parsed.messages[1].pluralKey == "%d files");
    assert(parsed.get("Open", "menu") == "Öffnen");
    assert(parsed.forms("One", "menu") == ["Eins", "Viele"]);
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
