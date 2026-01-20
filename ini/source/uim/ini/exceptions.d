/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.ini.exceptions;

@safe:

/**
 * Base exception for INI operations.
 */
class INIException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__) {
    super(msg, file, line);
  }
}

/**
 * Exception thrown when parsing fails.
 */
class INIParseException : INIException {
  size_t lineNumber;

  this(string msg, size_t line = 0, string file = __FILE__, size_t codeLine = __LINE__) {
    this.lineNumber = line;
    string fullMsg = line > 0 
      ? "Parse error at line " ~ line.to!string ~ ": " ~ msg
      : "Parse error: " ~ msg;
    super(fullMsg, file, codeLine);
  }
}

/**
 * Exception thrown when a section is not found.
 */
class SectionNotFoundException : INIException {
  string sectionName;

  this(string section, string file = __FILE__, size_t line = __LINE__) {
    this.sectionName = section;
    super("Section not found: " ~ section, file, line);
  }
}

/**
 * Exception thrown when a property is not found.
 */
class PropertyNotFoundException : INIException {
  string propertyName;

  this(string property, string file = __FILE__, size_t line = __LINE__) {
    this.propertyName = property;
    super("Property not found: " ~ property, file, line);
  }
}
