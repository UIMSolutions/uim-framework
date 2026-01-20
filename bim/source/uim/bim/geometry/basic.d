/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.bim.geometry.basic;

import uim.bim;

@safe:

/**
 * Basic box geometry.
 */
class DBoxGeometry : IBIMGeometry {
  protected double _width;
  protected double _depth;
  protected double _height;

  this(double width, double depth, double height) {
    _width = width;
    _depth = depth;
    _height = height;
  }

  string geometryType() {
    return "Box";
  }

  BoundingBox boundingBox() {
    return BoundingBox(0, 0, 0, _width, _depth, _height);
  }

  double volume() {
    return _width * _depth * _height;
  }

  double surfaceArea() {
    return 2 * (_width * _depth + _width * _height + _depth * _height);
  }

  double width() { return _width; }
  double depth() { return _depth; }
  double height() { return _height; }
}

/**
 * Cylindrical geometry.
 */
class DCylinderGeometry : IBIMGeometry {
  protected double _radius;
  protected double _height;

  this(double radius, double height) {
    _radius = radius;
    _height = height;
  }

  string geometryType() {
    return "Cylinder";
  }

  BoundingBox boundingBox() {
    return BoundingBox(
      -_radius, -_radius, 0,
      _radius, _radius, _height
    );
  }

  double volume() {
    import std.math : PI;
    return PI * _radius * _radius * _height;
  }

  double surfaceArea() {
    import std.math : PI;
    return 2 * PI * _radius * (_radius + _height);
  }

  double radius() { return _radius; }
  double height() { return _height; }
}

unittest {
  auto box = new DBoxGeometry(2.0, 3.0, 4.0);
  assert(box.volume == 24.0);
  assert(box.geometryType == "Box");
}
