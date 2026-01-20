/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.column;

import uim.bim;

@safe:

/**
 * BIM column element.
 */
class DBIMColumn : DBIMElement, IBIMBuildingElement {
  protected IBIMMaterial[] _materials;
  protected double _height;
  protected double _width;
  protected double _depth;
  protected string _profile; // "Rectangular", "Circular", "I-Beam", etc.
  protected string _fireResistance;

  this() {
    super("Column");
    _profile = "Rectangular";
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
    return true; // Columns are always load-bearing
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

  double width() {
    return _width;
  }

  void width(double value) {
    _width = value;
  }

  double depth() {
    return _depth;
  }

  void depth(double value) {
    _depth = value;
  }

  string profile() {
    return _profile;
  }

  void profile(string value) {
    _profile = value;
  }

  double crossSectionArea() {
    return _width * _depth;
  }
}

unittest {
  auto column = new DBIMColumn();
  assert(column !is null);
  assert(column.elementType == "Column");
  assert(column.isLoadBearing);
}
