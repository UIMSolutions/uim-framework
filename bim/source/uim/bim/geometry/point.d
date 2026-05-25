/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.geometry.point;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * BimPoint3D - An immutable 3D point in a Cartesian coordinate system.
 * Coordinates are in metres.
 */
struct BimPoint3D {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;

  BimPoint3D opBinary(string op)(BimPoint3D rhs) const if (op == "+") {
    return BimPoint3D(x + rhs.x, y + rhs.y, z + rhs.z);
  }

  BimPoint3D opBinary(string op)(BimPoint3D rhs) const if (op == "-") {
    return BimPoint3D(x - rhs.x, y - rhs.y, z - rhs.z);
  }

  double distanceTo(BimPoint3D other) const {
    import std.math : sqrt;
    double dx = x - other.x;
    double dy = y - other.y;
    double dz = z - other.z;
    return sqrt(dx * dx + dy * dy + dz * dz);
  }

  Json toJson() const {
    auto obj = Json.emptyObject;
    obj["x"] = Json(x);
    obj["y"] = Json(y);
    obj["z"] = Json(z);
    return obj;
  }

  static BimPoint3D fromJson(Json data) {
    BimPoint3D p;
    if (data["x"].type == Json.Type.float_) p.x = data["x"].get!double;
    if (data["y"].type == Json.Type.float_) p.y = data["y"].get!double;
    if (data["z"].type == Json.Type.float_) p.z = data["z"].get!double;
    return p;
  }
}
