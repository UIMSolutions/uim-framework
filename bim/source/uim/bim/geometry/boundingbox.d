/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.geometry.boundingbox;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * BimBoundingBox - Axis-Aligned Bounding Box (AABB) for a BIM element.
 * Defined by its minimum and maximum corner points.
 */
struct BimBoundingBox {
  BimPoint3D min;
  BimPoint3D max;

  double width()  const { return max.x - min.x; }
  double depth()  const { return max.y - min.y; }
  double height() const { return max.z - min.z; }

  double volume() const { return width() * depth() * height(); }

  bool contains(BimPoint3D p) const {
    return p.x >= min.x && p.x <= max.x
        && p.y >= min.y && p.y <= max.y
        && p.z >= min.z && p.z <= max.z;
  }

  bool intersects(BimBoundingBox other) const {
    return max.x >= other.min.x && min.x <= other.max.x
        && max.y >= other.min.y && min.y <= other.max.y
        && max.z >= other.min.z && min.z <= other.max.z;
  }

  Json toJson() const {
    auto obj = Json.emptyObject;
    obj["min"] = min.toJson();
    obj["max"] = max.toJson();
    return obj;
  }

  static BimBoundingBox fromJson(Json data) {
    BimBoundingBox bb;
    if (data["min"].type == Json.Type.object_) bb.min = BimPoint3D.fromJson(data["min"]);
    if (data["max"].type == Json.Type.object_) bb.max = BimPoint3D.fromJson(data["max"]);
    return bb;
  }
}
