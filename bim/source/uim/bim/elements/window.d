/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.elements.window;

import uim.bim;

@safe:

/**
 * BIM window element.
 */
class DBIMWindow : DBIMElement, IBIMBuildingElement {
  protected IBIMMaterial[] _materials;
  protected double _width;
  protected double _height;
  protected string _glazingType;
  protected double _uValue; // Thermal transmittance
  protected bool _isOperable;

  this() {
    super("Window");
    _glazingType = "Double";
    _uValue = 1.5; // Default U-value
    _isOperable = true;
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
    return false;
  }

  string fireResistance() {
    return "None"; // Windows typically don't have fire resistance
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

  string glazingType() {
    return _glazingType;
  }

  void glazingType(string value) {
    _glazingType = value;
  }

  double uValue() {
    return _uValue;
  }

  void uValue(double value) {
    _uValue = value;
  }

  bool isOperable() {
    return _isOperable;
  }

  void isOperable(bool value) {
    _isOperable = value;
  }

  double area() {
    return _width * _height;
  }
}

unittest {
  auto window = new DBIMWindow();
  assert(window !is null);
  assert(window.elementType == "Window");
  window.width = 1.2;
  window.height = 1.5;
  assert(window.area == 1.8);
}
