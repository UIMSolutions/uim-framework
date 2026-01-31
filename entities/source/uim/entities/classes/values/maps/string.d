/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.maps.string;

import uim.entities;

mixin(ShowModule!());

@safe:
class StringValueMap : UIMValue {
  this() {
    super();
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  protected UIMValue[string] _items;

  StringValueMap opIndexAssign(UIMValue value, string key) {
    if (containsKey(key)) {
      _items[key] = value; 
    } else {
      _items[key] = value; }

    return this;
  }

  StringValueMap opIndexAssign(bool value, string key) {
    if (containsKey(key)) {
      _items[key].value(value ? "true" : "false"); 
    } else {
    _items[key] = new BooleanValue(value); }

    return this;
  }

  StringValueMap opIndexAssign(int value, string key) {
    if (containsKey(key)) {
      _items[key].value(to!string(value)); 
    } else {
    _items[key] = new DIntegerValue(value); }

    return this;
  }

  StringValueMap opIndexAssign(double value, string key) {
    if (containsKey(key)) {
      _items[key].value(to!string(value)); 
    } else {
    _items[key] = new DDoubleValue(value); }
    
    return this;
  }

  StringValueMap opIndexAssign(string value, string key) {    
     if (containsKey(key)) {
      _items[key].value(value); 
    } else {
     _items[key] = new DStringValue(value); }
    
    return this;
  }

  StringValueMap opIndexAssign(UUID value, string key) {
    if (containsKey(key)) {
      _items[key].value(value.toString); 
    } else {
      _items[key] = new DUUIDValue(value); }

    return this;
  }

  StringValueMap opIndexAssign(UIMValue[] values, string key) {
    if (containsKey(key)) {
      _items[key] = new ArrayValue(values); 
    } else {
      _items[key] = new ArrayValue(values); }

    return this;
  }

  UIMValue opIndex(this O)(string key) {
    return _items.get(key, null);
  }

  bool isEmpty() {
    return (_items.length == 0);    
  }

  size_t length() {
    return _items.length;    
  }

  string[] keys() {
    return _items.keys;
  }

  // containsKey - Returns true if this map contains a mapping for the specified key.
  bool containsKey(string key) {
    foreach(k; keys) {
      if (k == key) { return true; }
    }
    return false;
  }

  UIMValue[] values() {
    return _items.values;
  }

  /// containsValue - Returns true if this map maps one or more keys to the specified value.
  bool containsValue(UIMValue value) {
    foreach(v; values) {
      if (v == value) { return true; }
    }
    return false;
  }

  override UIMValue copy() {
    return new NullValue; // StringValueMap(attribute, toJson);
  }

  override Json toJson() {
    Json results = Json.emptyObject;

    foreach(key, value; _items) {
      results[key] = value.toJson;
    }

    return results;
  }

  override string toString() {
    string[] results;

    foreach(key, value; _items) {
      results ~= "%s:%s".format(key, value);
    }

    return "["~results.join(",") ~"]";
  }
}