/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.gis.interfaces.geometry;

@safe:

enum GISGeometryType : ubyte {
  point = 0,
  lineString = 1,
  polygon = 2,
  multiPoint = 3,
  multiLineString = 4,
  multiPolygon = 5,
  geometryCollection = 6
}

struct GISPoint {
  double x;
  double y;
  double z;
}

struct GISExtent {
  double minX;
  double minY;
  double maxX;
  double maxY;
}

interface IGISFeature {
  string id();
  IGISFeature id(string value);

  GISGeometryType geometryType();
  IGISFeature geometryType(GISGeometryType value);

  GISPoint[] coordinates();
  IGISFeature coordinates(const(GISPoint)[] value);
  IGISFeature addCoordinate(GISPoint value);

  string[string] properties();
  IGISFeature properties(string[string] value);
  IGISFeature setProperty(string key, string value);

  GISExtent extent();
}

alias GISFeatureHandler = void delegate(IGISFeature feature) @safe;

interface IGISClient {
  bool connect();
  bool disconnect();
  bool connected() const;
  string endpoint() const;

  bool addFeature(IGISFeature feature);
  IGISFeature featureById(string featureId);
  IGISFeature[] features();

  IGISFeature[] queryByExtent(GISExtent extent);
  IGISFeature[] queryByProperty(string key, string value);
  bool streamByExtent(GISExtent extent, GISFeatureHandler handler);
}
