/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.ini.property;

import uim.ini;

@safe:

/**
 * Represents a single property (key-value pair) in an INI file.
 */
class DINIProperty : UIMObject {
  protected string _key;
  protected string _value;
  protected string _comment;

  this() {
    super();
  }

  this(string key, string value, string comment = "") {
    this();
    _key = key;
    _value = value;
    _comment = comment;
  }

  // Getters
  string key() { return _key; }
  string value() { return _value; }
  string comment() { return _comment; }

  // Setters
  void key(string value) { _key = value; }
  void value(string value) { _value = value; }
  void comment(string value) { _comment = value; }

  /**
   * Get value as string.
   */
  string asString() {
    return _value;
  }

  /**
   * Get value as integer.
   */
  long asLong(long defaultValue = 0) {
    try {
      return _value.to!long;
    } catch (Exception) {
      return defaultValue;
    }
  }

  /**
   * Get value as integer.
   */
  int asInt(int defaultValue = 0) {
    try {
      return _value.to!int;
    } catch (Exception) {
      return defaultValue;
    }
  }

  /**
   * Get value as double.
   */
  double asDouble(double defaultValue = 0.0) {
    try {
      return _value.to!double;
    } catch (Exception) {
      return defaultValue;
    }
  }

  /**
   * Get value as boolean.
   */
  bool asBool(bool defaultValue = false) {
    auto lower = _value.toLower();
    if (lower == "true" || lower == "yes" || lower == "1" || lower == "on") {
      return true;
    }
    if (lower == "false" || lower == "no" || lower == "0" || lower == "off") {
      return false;
    }
    return defaultValue;
  }

  /**
   * Get value as array of strings (comma-separated).
   */
  string[] asArray(string separator = ",") {
    import std.algorithm : map;
    import std.array : array, split;
    import std.string : strip;
    
    return _value.split(separator).map!(s => s.strip()).array;
  }

  override string toString() const {
    return _key ~ "=" ~ _value;
  }
}

unittest {
  auto prop = new DINIProperty("port", "8080");
  assert(prop.asInt() == 8080);
  assert(prop.asString() == "8080");
  
  auto boolProp = new DINIProperty("enabled", "true");
  assert(boolProp.asBool() == true);
}
