/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.ini.writer;

import uim.ini;

@safe:

/**
 * Writer for INI files.
 */
class DINIWriter : UIMObject {
  protected bool _writeComments = true;
  protected bool _addSpacing = true;
  protected string _commentChar = ";";

  this() {
    super();
  }

  // Configuration
  void writeComments(bool value) { _writeComments = value; }
  void addSpacing(bool value) { _addSpacing = value; }
  void commentChar(string value) { _commentChar = value; }

  /**
   * Write INI document to string.
   */
  string write(DINIDocument doc) {
    string result;

    // Write header if present
    if (doc.header.length > 0) {
      result ~= _commentChar ~ " " ~ doc.header ~ "\n";
      if (_addSpacing) result ~= "\n";
    }

    // Write global properties
    auto globals = doc.globalProperties();
    if (globals.length > 0) {
      foreach (prop; globals) {
        if (_writeComments && prop.comment.length > 0) {
          result ~= _commentChar ~ " " ~ prop.comment ~ "\n";
        }
        result ~= prop.key ~ "=" ~ prop.value ~ "\n";
      }
      if (_addSpacing) result ~= "\n";
    }

    // Write sections
    auto sections = doc.sections();
    foreach (i, section; sections) {
      // Section header
      if (_writeComments && section.comment.length > 0) {
        result ~= _commentChar ~ " " ~ section.comment ~ "\n";
      }
      result ~= "[" ~ section.name ~ "]\n";

      // Section properties
      auto properties = section.properties();
      foreach (prop; properties) {
        if (_writeComments && prop.comment.length > 0) {
          result ~= _commentChar ~ " " ~ prop.comment ~ "\n";
        }
        result ~= prop.key ~ "=" ~ prop.value ~ "\n";
      }

      // Add spacing between sections
      if (_addSpacing && i < sections.length - 1) {
        result ~= "\n";
      }
    }

    return result;
  }

  /**
   * Write INI document to file.
   */
  void writeFile(DINIDocument doc, string filePath) {
    import std.file : write;
    
    try {
      string content = write(doc);
      std.file.write(filePath, content);
    } catch (Exception e) {
      throw new INIException("Failed to write file: " ~ filePath ~ " - " ~ e.msg);
    }
  }
}

// Convenience functions
string writeINI(DINIDocument doc) {
  auto writer = new DINIWriter();
  return writer.write(doc);
}

void writeINIFile(DINIDocument doc, string filePath) {
  auto writer = new DINIWriter();
  writer.writeFile(doc, filePath);
}

unittest {
  auto doc = new DINIDocument();
  doc.set("Database", "host", "localhost");
  doc.set("Database", "port", "5432");
  doc.set("Server", "port", "8080");

  auto content = writeINI(doc);
  assert(content.indexOf("[Database]") >= 0);
  assert(content.indexOf("host=localhost") >= 0);
}
