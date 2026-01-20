/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.ini.document;

import uim.ini;

@safe:

/**
 * Represents a complete INI document.
 */
class DINIDocument : UIMObject {
  protected DINISection[string] _sections;
  protected DINIProperty[string] _globalProperties;
  protected string _header;

  this() {
    super();
  }

  // Getters
  string header() { return _header; }

  // Setters
  void header(string value) { _header = value; }

  /**
   * Add or get a section.
   */
  DINISection section(string name) {
    if (auto section = name in _sections) {
      return *section;
    }
    auto newSection = new DINISection(name);
    _sections[name] = newSection;
    return newSection;
  }

  /**
   * Get a section (throws if not found).
   */
  DINISection getSection(string name) {
    if (auto section = name in _sections) {
      return *section;
    }
    throw new SectionNotFoundException(name);
  }

  /**
   * Check if section exists.
   */
  bool hasSection(string name) {
    return (name in _sections) !is null;
  }

  /**
   * Remove a section.
   */
  bool removeSection(string name) {
    if (name in _sections) {
      _sections.remove(name);
      return true;
    }
    return false;
  }

  /**
   * Get all section names.
   */
  string[] sectionNames() {
    return _sections.keys;
  }

  /**
   * Get all sections.
   */
  DINISection[] sections() {
    return _sections.values;
  }

  /**
   * Set a global property (before any section).
   */
  DINIDocument setGlobal(string key, string value, string comment = "") {
    auto prop = new DINIProperty(key, value, comment);
    _globalProperties[key] = prop;
    return this;
  }

  /**
   * Get a global property value.
   */
  string getGlobal(string key, string defaultValue = "") {
    if (auto prop = key in _globalProperties) {
      return prop.value;
    }
    return defaultValue;
  }

  /**
   * Check if global property exists.
   */
  bool hasGlobal(string key) {
    return (key in _globalProperties) !is null;
  }

  /**
   * Get all global properties.
   */
  DINIProperty[] globalProperties() {
    return _globalProperties.values;
  }

  /**
   * Get a value from a specific section.
   */
  string get(string sectionName, string key, string defaultValue = "") {
    if (auto section = sectionName in _sections) {
      return section.get(key, defaultValue);
    }
    return defaultValue;
  }

  /**
   * Set a value in a specific section.
   */
  DINIDocument set(string sectionName, string key, string value) {
    section(sectionName).set(key, value);
    return this;
  }

  /**
   * Get integer value from section.
   */
  int getInt(string sectionName, string key, int defaultValue = 0) {
    if (auto section = sectionName in _sections) {
      return section.getInt(key, defaultValue);
    }
    return defaultValue;
  }

  /**
   * Get boolean value from section.
   */
  bool getBool(string sectionName, string key, bool defaultValue = false) {
    if (auto section = sectionName in _sections) {
      return section.getBool(key, defaultValue);
    }
    return defaultValue;
  }

  /**
   * Get double value from section.
   */
  double getDouble(string sectionName, string key, double defaultValue = 0.0) {
    if (auto section = sectionName in _sections) {
      return section.getDouble(key, defaultValue);
    }
    return defaultValue;
  }

  /**
   * Clear all sections and properties.
   */
  void clear() {
    _sections.clear();
    _globalProperties.clear();
    _header = "";
  }

  /**
   * Get total number of sections.
   */
  size_t sectionCount() {
    return _sections.length;
  }
}

unittest {
  auto doc = new DINIDocument();
  doc.set("Server", "host", "localhost");
  doc.set("Server", "port", "8080");
  
  assert(doc.get("Server", "host") == "localhost");
  assert(doc.getInt("Server", "port") == 8080);
  assert(doc.hasSection("Server"));
}
