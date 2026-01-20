/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.ini.section;

import uim.ini;

@safe:

/**
 * Represents a section in an INI file.
 */
class DINISection : UIMObject {
  protected string _name;
  protected DINIProperty[string] _properties;
  protected string _comment;

  this() {
    super();
  }

  this(string name, string comment = "") {
    this();
    _name = name;
    _comment = comment;
  }

  // Getters
  string name() { return _name; }
  string comment() { return _comment; }

  // Setters
  void name(string value) { _name = value; }
  void comment(string value) { _comment = value; }

  /**
   * Add or update a property.
   */
  DINISection set(string key, string value, string comment = "") {
    auto prop = new DINIProperty(key, value, comment);
    _properties[key] = prop;
    return this;
  }

  /**
   * Get a property value.
   */
  string get(string key, string defaultValue = "") {
    if (auto prop = key in _properties) {
      return prop.value;
    }
    return defaultValue;
  }

  /**
   * Get a property object.
   */
  DINIProperty getProperty(string key) {
    if (auto prop = key in _properties) {
      return *prop;
    }
    throw new PropertyNotFoundException(key);
  }

  /**
   * Check if property exists.
   */
  bool has(string key) {
    return (key in _properties) !is null;
  }

  /**
   * Remove a property.
   */
  bool remove(string key) {
    if (key in _properties) {
      _properties.remove(key);
      return true;
    }
    return false;
  }

  /**
   * Get all property keys.
   */
  string[] keys() {
    return _properties.keys;
  }

  /**
   * Get all properties.
   */
  DINIProperty[] properties() {
    return _properties.values;
  }

  /**
   * Get number of properties.
   */
  size_t count() {
    return _properties.length;
  }

  /**
   * Clear all properties.
   */
  void clear() {
    _properties.clear();
  }

  /**
   * Get value as integer.
   */
  int getInt(string key, int defaultValue = 0) {
    if (auto prop = key in _properties) {
      return prop.asInt(defaultValue);
    }
    return defaultValue;
  }

  /**
   * Get value as long.
   */
  long getLong(string key, long defaultValue = 0) {
    if (auto prop = key in _properties) {
      return prop.asLong(defaultValue);
    }
    return defaultValue;
  }

  /**
   * Get value as double.
   */
  double getDouble(string key, double defaultValue = 0.0) {
    if (auto prop = key in _properties) {
      return prop.asDouble(defaultValue);
    }
    return defaultValue;
  }

  /**
   * Get value as boolean.
   */
  bool getBool(string key, bool defaultValue = false) {
    if (auto prop = key in _properties) {
      return prop.asBool(defaultValue);
    }
    return defaultValue;
  }

  /**
   * Get value as array.
   */
  string[] getArray(string key, string separator = ",") {
    if (auto prop = key in _properties) {
      return prop.asArray(separator);
    }
    return [];
  }

  override string toString() const {
    return "[" ~ _name ~ "]";
  }
}

unittest {
  auto section = new DINISection("Database");
  section.set("host", "localhost");
  section.set("port", "5432");
  
  assert(section.get("host") == "localhost");
  assert(section.getInt("port") == 5432);
  assert(section.has("host"));
  assert(!section.has("user"));
}
