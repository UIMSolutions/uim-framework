/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.slab;

import uim.bim;

@safe:

/**
 * BIM slab/floor element.
 */
class DBIMSlab : DBIMElement, IBIMBuildingElement {
  protected IBIMMaterial[] _materials;
  protected double[] _thicknesses;
  protected double _area;
  protected string _slabType; // "Floor", "Roof", "Foundation"
  protected bool _isLoadBearing;
  protected string _fireResistance;

  this() {
    super("Slab");
    _slabType = "Floor";
    _isLoadBearing = true;
  }

  IBIMMaterial[] materials() {
    return _materials.dup;
  }

  void addMaterial(IBIMMaterial material, double thickness) {
    if (material !is null) {
      _materials ~= material;
      _thicknesses ~= thickness;
    }
  }

  bool isLoadBearing() {
    return _isLoadBearing;
  }

  void isLoadBearing(bool value) {
    _isLoadBearing = value;
  }

  string fireResistance() {
    return _fireResistance;
  }

  void fireResistance(string value) {
    _fireResistance = value;
  }

  double area() {
    return _area;
  }

  void area(double value) {
    _area = value;
  }

  string slabType() {
    return _slabType;
  }

  void slabType(string value) {
    _slabType = value;
  }

  double totalThickness() {
    import std.algorithm : sum;
    return _thicknesses.sum;
  }
}

unittest {
  auto slab = new DBIMSlab();
  assert(slab !is null);
  assert(slab.elementType == "Slab");
  assert(slab.slabType == "Floor");
}
