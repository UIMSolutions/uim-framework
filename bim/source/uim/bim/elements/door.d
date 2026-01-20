/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.door;

import uim.bim;

@safe:

/**
 * BIM door element.
 */
class DBIMDoor : DBIMElement, IBIMBuildingElement {
  protected IBIMMaterial[] _materials;
  protected double _width;
  protected double _height;
  protected string _openingType; // "Single", "Double", "Sliding", etc.
  protected bool _isFire rated;
  protected string _fireResistance;

  this() {
    super("Door");
    _openingType = "Single";
    _isFireRated = false;
  }

  IBIMMaterial[] materials() {
    return _materials.dup;
  }

  void addMaterial(IBIMMaterial material, double thickness = 0) {
    if (material !is null) {
      _materials ~= material;
    }
  }

  bool isLoadBearing() {
    return false; // Doors are typically not load-bearing
  }

  string fireResistance() {
    return _fireResistance;
  }

  void fireResistance(string value) {
    _fireResistance = value;
    _isFireRated = value != "None" && value.length > 0;
  }

  double width() {
    return _width;
  }

  void width(double value) {
    _width = value;
  }

  double height() {
    return _height;
  }

  void height(double value) {
    _height = value;
  }

  string openingType() {
    return _openingType;
  }

  void openingType(string value) {
    _openingType = value;
  }

  bool isFireRated() {
    return _isFireRated;
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (auto width = "width" in initData) {
      _width = width.get!double;
    }

    if (auto height = "height" in initData) {
      _height = height.get!double;
    }

    if (auto openingType = "openingType" in initData) {
      _openingType = openingType.get!string;
    }

    return true;
  }
}

unittest {
  auto door = new DBIMDoor();
  assert(door !is null);
  assert(door.elementType == "Door");
  door.width = 0.9;
  door.height = 2.1;
  assert(door.width == 0.9);
  assert(door.height == 2.1);
}
