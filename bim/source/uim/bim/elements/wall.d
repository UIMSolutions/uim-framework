/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.wall;

import uim.bim;

@safe:

/**
 * BIM wall element.
 */
class DBIMWall : DBIMElement, IBIMBuildingElement {
  protected IBIMMaterial[] _materials;
  protected double[] _thicknesses;
  protected bool _isLoadBearing;
  protected string _fireResistance;
  protected double _height;
  protected double _length;

  this() {
    super("Wall");
    _isLoadBearing = false;
    _fireResistance = "None";
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

  double height() {
    return _height;
  }

  void height(double value) {
    _height = value;
  }

  double length() {
    return _length;
  }

  void length(double value) {
    _length = value;
  }

  double totalThickness() {
    import std.algorithm : sum;
    return _thicknesses.sum;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto height = "height" in initData) {
      _height = height.get!double;
    }

    if (auto length = "length" in initData) {
      _length = length.get!double;
    }

    if (auto loadBearing = "isLoadBearing" in initData) {
      _isLoadBearing = loadBearing.get!bool;
    }

    return true;
  }
}

unittest {
  auto wall = new DBIMWall();
  assert(wall !is null);
  assert(wall.elementType == "Wall");
  wall.height = 3.0;
  wall.length = 5.0;
  assert(wall.height == 3.0);
  assert(wall.length == 5.0);
}
