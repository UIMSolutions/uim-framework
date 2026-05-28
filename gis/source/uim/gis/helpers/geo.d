/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.gis.helpers.geo;

import uim.gis.interfaces.geometry;

@safe:

GISExtent gisExtentFromCoordinates(const(GISPoint)[] coordinates) {
  if (coordinates.length == 0) {
    return GISExtent(0, 0, 0, 0);
  }

  double minX = coordinates[0].x;
  double minY = coordinates[0].y;
  double maxX = coordinates[0].x;
  double maxY = coordinates[0].y;

  foreach (p; coordinates[1 .. $]) {
    if (p.x < minX) {
      minX = p.x;
    }
    if (p.y < minY) {
      minY = p.y;
    }
    if (p.x > maxX) {
      maxX = p.x;
    }
    if (p.y > maxY) {
      maxY = p.y;
    }
  }

  return GISExtent(minX, minY, maxX, maxY);
}

bool gisExtentContainsPoint(GISExtent extent, GISPoint p) {
  return p.x >= extent.minX && p.x <= extent.maxX && p.y >= extent.minY && p.y <= extent.maxY;
}

bool gisExtentIntersects(GISExtent a, GISExtent b) {
  if (a.maxX < b.minX || b.maxX < a.minX) {
    return false;
  }

  if (a.maxY < b.minY || b.maxY < a.minY) {
    return false;
  }

  return true;
}

unittest {
  auto points = [GISPoint(1, 2, 0), GISPoint(5, 7, 0), GISPoint(3, 4, 0)];
  auto e = gisExtentFromCoordinates(points);

  assert(e.minX == 1);
  assert(e.minY == 2);
  assert(e.maxX == 5);
  assert(e.maxY == 7);
  assert(gisExtentContainsPoint(e, GISPoint(3, 4, 0)));
  assert(!gisExtentContainsPoint(e, GISPoint(10, 10, 0)));
}
