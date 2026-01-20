/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.core.property;

import uim.bim;

@safe:

/**
 * BIM property class for storing element properties.
 */
class DBIMProperty : UIMObject, IBIMProperty {
  protected Json _value;
  protected string _unit;
  protected string _dataType;

  this() {
    super();
    _value = Json(null);
    _dataType = "string";
  }

  this(string name, Json value, string unit = "", string dataType = "string") {
    this();
    this.name = name;
    _value = value;
    _unit = unit;
    _dataType = dataType;
  }

  Json value() {
    return _value;
  }

  void value(Json val) {
    _value = val;
  }

  string unit() {
    return _unit;
  }

  string dataType() {
    return _dataType;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto val = "value" in initData) {
      _value = *val;
    }

    if (auto unit = "unit" in initData) {
      _unit = unit.get!string;
    }

    if (auto dataType = "dataType" in initData) {
      _dataType = dataType.get!string;
    }

    return true;
  }
}

unittest {
  auto prop = new DBIMProperty("Height", Json(3.5), "m", "double");
  assert(prop !is null);
  assert(prop.name == "Height");
  assert(prop.value.get!double == 3.5);
  assert(prop.unit == "m");
}
