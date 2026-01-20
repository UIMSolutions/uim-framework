/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.materials.material;

import uim.bim;

@safe:

/**
 * BIM material class.
 */
class DBIMMaterial : UIMObject, IBIMMaterial {
  protected Json[string] _properties;
  protected double _thermalConductivity;
  protected double _density;
  protected double _costPerUnit;
  protected string _unit = "m3";

  this() {
    super();
  }

  this(string name) {
    this();
    this.name = name;
  }

  Json[string] materialProperties() {
    return _properties.dup;
  }

  void setProperty(string key, Json value) {
    _properties[key] = value;
  }

  double thermalConductivity() {
    return _thermalConductivity;
  }

  void thermalConductivity(double value) {
    _thermalConductivity = value;
  }

  double density() {
    return _density;
  }

  void density(double value) {
    _density = value;
  }

  double costPerUnit() {
    return _costPerUnit;
  }

  void costPerUnit(double value) {
    _costPerUnit = value;
  }

  string unit() {
    return _unit;
  }

  void unit(string u) {
    _unit = u;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto tc = "thermalConductivity" in initData) {
      _thermalConductivity = tc.get!double;
    }

    if (auto density = "density" in initData) {
      _density = density.get!double;
    }

    if (auto cost = "costPerUnit" in initData) {
      _costPerUnit = cost.get!double;
    }

    return true;
  }
}

// Common material presets
DBIMMaterial createConcrete() {
  auto material = new DBIMMaterial("Concrete");
  material.density = 2400; // kg/m³
  material.thermalConductivity = 1.7; // W/(m·K)
  material.costPerUnit = 150; // USD per m³
  return material;
}

DBIMMaterial createSteel() {
  auto material = new DBIMMaterial("Steel");
  material.density = 7850; // kg/m³
  material.thermalConductivity = 50; // W/(m·K)
  material.costPerUnit = 800; // USD per m³
  return material;
}

DBIMMaterial createBrick() {
  auto material = new DBIMMaterial("Brick");
  material.density = 1800; // kg/m³
  material.thermalConductivity = 0.7; // W/(m·K)
  material.costPerUnit = 100; // USD per m³
  return material;
}

unittest {
  auto concrete = createConcrete();
  assert(concrete !is null);
  assert(concrete.name == "Concrete");
  assert(concrete.density == 2400);
}
