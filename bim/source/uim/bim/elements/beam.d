/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.beam;

import uim.bim;

@safe:

/**
 * BIM beam element.
 */
class DBIMBeam : DBIMElement, IBIMBuildingElement {
  protected IBIMMaterial[] _materials;
  protected double _length;
  protected double _width;
  protected double _height;
  protected string _profile; // "Rectangular", "I-Beam", "T-Beam", etc.
  protected string _fireResistance;

  this() {
    super("Beam");
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
    return true; // Beams are always load-bearing
  }

  string fireResistance() {
    return _fireResistance;
  }

  void fireResistance(string value) {
    _fireResistance = value;
  }

  double length() {
    return _length;
  }

  void length(double value) {
    _length = value;
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

  string profile() {
    return _profile;
  }

  void profile(string value) {
    _profile = value;
  }

  double crossSectionArea() {
    return _width * _height;
  }

  double volume() {
    return _length * _width * _height;
  }
}

unittest {
  auto beam = new DBIMBeam();
  assert(beam !is null);
  assert(beam.elementType == "Beam");
  assert(beam.isLoadBearing);
}
