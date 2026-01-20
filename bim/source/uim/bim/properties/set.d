/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.properties.set;

import uim.bim;

@safe:

/**
 * Property set for grouping related properties.
 */
class DBIMPropertySet : UIMObject {
  protected IBIMProperty[string] _properties;
  protected string _setType;

  this() {
    super();
  }

  this(string name, string setType = "General") {
    this();
    this.name = name;
    _setType = setType;
  }

  void addProperty(IBIMProperty property) {
    if (property !is null) {
      _properties[property.name] = property;
    }
  }

  IBIMProperty getProperty(string name) {
    return _properties.get(name, null);
  }

  IBIMProperty[] allProperties() {
    return _properties.values;
  }

  bool hasProperty(string name) {
    return (name in _properties) !is null;
  }

  void removeProperty(string name) {
    _properties.remove(name);
  }

  string setType() {
    return _setType;
  }

  void setType(string type) {
    _setType = type;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto setType = "setType" in initData) {
      _setType = setType.get!string;
    }

    return true;
  }
}

unittest {
  auto propSet = new DBIMPropertySet("Thermal Properties", "Physical");
  auto prop = new DBIMProperty("U-Value", Json(1.5), "W/(m²·K)");
  
  propSet.addProperty(prop);
  assert(propSet.hasProperty("U-Value"));
  assert(propSet.getProperty("U-Value").value.get!double == 1.5);
}
