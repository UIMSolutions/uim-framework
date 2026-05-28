/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.gis.models.feature;

import uim.gis;

mixin(ShowModule!());

@safe:

class UIMGISFeature : UIMObject, IGISFeature {
  private string _id;
  private GISGeometryType _geometryType = GISGeometryType.point;
  private GISPoint[] _coordinates;
  private string[string] _properties;

  this(string id = "", GISGeometryType geometryType = GISGeometryType.point, const(GISPoint)[] coordinates = null) {
    _id = id;
    _geometryType = geometryType;
    _coordinates = coordinates.dup;
  }

  string id() {
    return _id;
  }

  IGISFeature id(string value) {
    _id = value;
    return this;
  }

  GISGeometryType geometryType() {
    return _geometryType;
  }

  IGISFeature geometryType(GISGeometryType value) {
    _geometryType = value;
    return this;
  }

  GISPoint[] coordinates() {
    return _coordinates.dup;
  }

  IGISFeature coordinates(const(GISPoint)[] value) {
    _coordinates = value.dup;
    return this;
  }

  IGISFeature addCoordinate(GISPoint value) {
    _coordinates ~= value;
    return this;
  }

  string[string] properties() {
    return _properties.dup;
  }

  IGISFeature properties(string[string] value) {
    _properties = value.dup;
    return this;
  }

  IGISFeature setProperty(string key, string value) {
    if (key.length) {
      _properties[key] = value;
    }
    return this;
  }

  GISExtent extent() {
    return gisExtentFromCoordinates(_coordinates);
  }
}

IGISFeature GISFeature(string id = "", GISGeometryType geometryType = GISGeometryType.point, const(GISPoint)[] coordinates = null) {
  return new UIMGISFeature(id, geometryType, coordinates);
}

unittest {
  auto f = GISFeature("f-1", GISGeometryType.lineString, [GISPoint(1, 1, 0), GISPoint(5, 3, 0)]);
  f.setProperty("class", "road");

  assert(f.id() == "f-1");
  assert(f.extent().maxX == 5);
  assert(f.properties()["class"] == "road");
}
