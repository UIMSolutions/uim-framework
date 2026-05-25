/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.geometry.placement;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * BimPlacement - Local placement of a BIM element within its container
 * coordinate system (IfcLocalPlacement / IfcAxis2Placement3D).
 */
struct BimPlacement {
  /// Origin of the local coordinate system
  BimPoint3D origin;

  /// Axis direction (default: Z-up)
  BimPoint3D axisZ = BimPoint3D(0, 0, 1);

  /// Reference direction (default: X-right)
  BimPoint3D axisX = BimPoint3D(1, 0, 0);

  /// Rotation around the Z-axis in degrees (shorthand for common 2D orientation)
  double rotationDeg = 0.0;

  Json toJson() const {
    auto obj = Json.emptyObject;
    obj["origin"]      = origin.toJson();
    obj["axisZ"]       = axisZ.toJson();
    obj["axisX"]       = axisX.toJson();
    obj["rotationDeg"] = Json(rotationDeg);
    return obj;
  }

  static BimPlacement fromJson(Json data) {
    BimPlacement p;
    if (data["origin"].type      == Json.Type.object_) p.origin      = BimPoint3D.fromJson(data["origin"]);
    if (data["axisZ"].type       == Json.Type.object_) p.axisZ       = BimPoint3D.fromJson(data["axisZ"]);
    if (data["axisX"].type       == Json.Type.object_) p.axisX       = BimPoint3D.fromJson(data["axisX"]);
    if (data["rotationDeg"].type == Json.Type.float_)  p.rotationDeg = data["rotationDeg"].get!double;
    return p;
  }
}
