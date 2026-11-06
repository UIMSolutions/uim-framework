/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.i18n.formats.properties;

import uim.i18n;

import std.array : appender;
import std.string : format, startsWith;
import std.utf : stride;

mixin(ShowModule!());

@safe:

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

/// .properties files are UTF-8 in current tools, but ISO-8859-1 by the original Java definition
private string decodeProperties(const(ubyte)[] content) {
  auto bytes = stripBom(content);
  auto text = (cast(const(char)[])bytes).idup;
  return isValidUtf8(text) ? text : decodeLatin1(bytes);
}

/// Parses a .properties file.
/// Follows java.util.Properties: keys end at '=', ':' or whitespace, and a trailing backslash continues the line.
/// A plural message is written as "key=first form" and "key[1]=second form".
///
/// Throws: I18nParseException on a malformed \uXXXX escape
I18nCatalog parseProperties(const(ubyte)[] content, string locale = null) {
  string[2][] entries;

  auto lines = physicalLines(decodeProperties(content));
  for (size_t i; i < lines.length; i++) {
    string line = skipPropertiesSpace(lines[i]);
    if (line.length == 0 || line[0] == '#' || line[0] == '!') {
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
      string[2] entry = [unescapeProperties(line[0 .. keyEnd]), unescapeProperties(rest)];
      entries ~= entry;
    }
  }

  auto catalog = new I18nCatalog(locale);
  addFlatEntries(catalog, entries);
  return catalog;
}

/// Reads the four hex digits of a \uXXXX escape starting at position start
private uint parseUnicodeEscape(string value, size_t start) {
  import std.ascii : isDigit, isHexDigit;

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

/// Resolves the escapes of a .properties key or value
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

version (unittest) {
  import std.exception : assertThrown;
  import std.string : representation;

  private I18nCatalog parse(string text) {
    return parseProperties(text.representation);
  }
}

/// Syntax
unittest {
  auto parsed = parse("# Comment\nappTitle=My App\ngreeting=Hello {0}\n\nempty=\n");
  assert(parsed.length == 3);
  assert(parsed.get("appTitle") == "My App");
  assert(parsed.get("greeting") == "Hello {0}");
  assert(parsed.has("empty") && parsed.get("empty") == "");

  // java.util.Properties syntax
  parsed = parse("a: 1\r\nb 2\r\nc\\:d = 3\nlong = one \\\n    two\nflag\n! comment\n");
  assert(parsed.get("a") == "1");
  assert(parsed.get("b") == "2");
  assert(parsed.get("c:d") == "3");
  assert(parsed.get("long") == "one two");
  assert(parsed.has("flag") && parsed.get("flag") == "");
  assert(parsed.length == 5);

  // Even backslashes at the end do not continue the line
  assert(parse("a=b\\\\\nc=d").get("a") == `b\`);
  // A file may end in the middle of an escape or a continuation
  assert(parse("a\\").has("a"));
  assert(parse("a=b\\").get("a") == "b");
}

/// Plural messages
unittest {
  auto parsed = parse("file=one file\nfile[1]={n} files\n");
  assert(parsed.length == 1);
  assert(parsed.forms("file") == ["one file", "{n} files"]);
}

/// Escapes and encodings
unittest {
  assert(unescapeProperties(`ü`) == "ü");
  assert(unescapeProperties(`😀`) == "😀");
  assert(unescapeProperties(`\uD83Dx`) == "�x"); // A lone surrogate
  assert(unescapeProperties(`\ü`) == "ü");
  assert(unescapeProperties(`a\rb`) == "a\rb");
  assertThrown!I18nParseException(unescapeProperties(`\u12`));
  assertThrown!I18nParseException(unescapeProperties(`\u12G4`));
  assertThrown!I18nParseException(parse(`a=\u12`));

  assert(parseProperties(cast(ubyte[])[0xEF, 0xBB, 0xBF, 'a', '=', 0xC3, 0xBC]).get("a") == "ü"); // UTF-8 with BOM
  assert(parseProperties(cast(ubyte[])['a', '=', 0xFC]).get("a") == "ü"); // ISO-8859-1
}
