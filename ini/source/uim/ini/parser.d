/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.ini.parser;

import uim.ini;
import std.algorithm : startsWith;
import std.string : strip, indexOf, stripLeft;

@safe:

/**
 * Parser for INI files.
 */
class DINIParser : UIMObject {
  protected bool _allowComments = true;
  protected bool _allowGlobalProperties = true;
  protected string _commentChar = ";";

  this() {
    super();
  }

  // Configuration
  void allowComments(bool value) { _allowComments = value; }
  void allowGlobalProperties(bool value) { _allowGlobalProperties = value; }
  void commentChar(string value) { _commentChar = value; }

  /**
   * Parse INI content from string.
   */
  DINIDocument parse(string content) {
    auto doc = new DINIDocument();
    DINISection currentSection = null;
    size_t lineNumber = 0;

    foreach (line; content.split("\n")) {
      lineNumber++;
      line = line.strip();

      // Skip empty lines
      if (line.length == 0) {
        continue;
      }

      // Skip comment lines
      if (_allowComments && line.startsWith(_commentChar)) {
        continue;
      }

      // Section header
      if (line.startsWith("[") && line.endsWith("]")) {
        auto sectionName = line[1 .. $ - 1].strip();
        if (sectionName.length == 0) {
          throw new INIParseException("Empty section name", lineNumber);
        }
        currentSection = doc.section(sectionName);
        continue;
      }

      // Property line
      auto equalPos = line.indexOf("=");
      if (equalPos < 0) {
        // Not a valid property line, skip or throw
        continue;
      }

      auto key = line[0 .. equalPos].strip();
      auto valueStr = line[equalPos + 1 .. $].strip();

      // Remove inline comments
      if (_allowComments) {
        auto commentPos = valueStr.indexOf(_commentChar);
        if (commentPos >= 0) {
          valueStr = valueStr[0 .. commentPos].strip();
        }
      }

      if (key.length == 0) {
        throw new INIParseException("Empty property key", lineNumber);
      }

      // Add to current section or global
      if (currentSection !is null) {
        currentSection.set(key, valueStr);
      } else {
        if (_allowGlobalProperties) {
          doc.setGlobal(key, valueStr);
        } else {
          throw new INIParseException("Global properties not allowed: " ~ key, lineNumber);
        }
      }
    }

    return doc;
  }

  /**
   * Parse INI file from disk.
   */
  DINIDocument parseFile(string filePath) {
    import std.file : readText;
    
    try {
      string content = readText(filePath);
      return parse(content);
    } catch (Exception e) {
      throw new INIException("Failed to read file: " ~ filePath ~ " - " ~ e.msg);
    }
  }
}

// Convenience functions
DINIDocument parseINI(string content) {
  auto parser = new DINIParser();
  return parser.parse(content);
}

DINIDocument parseINIFile(string filePath) {
  auto parser = new DINIParser();
  return parser.parseFile(filePath);
}

unittest {
  auto content = `
[Database]
host=localhost
port=5432
user=admin

[Server]
host=0.0.0.0
port=8080
debug=true
`;

  auto doc = parseINI(content);
  assert(doc.hasSection("Database"));
  assert(doc.get("Database", "host") == "localhost");
  assert(doc.getInt("Database", "port") == 5432);
  assert(doc.getBool("Server", "debug") == true);
}
