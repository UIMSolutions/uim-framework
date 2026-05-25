/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.roof;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimRoof - Roof element (IfcRoof).
 */
class UIMBimRoof : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcRoof"; }

  // #region geometry
  /// Roof pitch angle in degrees
  private double _pitchAngle;
  double pitchAngle() { return _pitchAngle; }
  UIMBimRoof pitchAngle(double value) { _pitchAngle = value; return this; }

  /// Overhang width in metres
  private double _overhang;
  double overhang() { return _overhang; }
  UIMBimRoof overhang(double value) { _overhang = value; return this; }
  // #endregion geometry

  // #region type
  /// FLAT_ROOF, SHED_ROOF, GABLE_ROOF, HIP_ROOF, HIPPED_GABLE_ROOF, GAMBREL_ROOF,
  /// MANSARD_ROOF, BARREL_ROOF, RAINBOW_ROOF, BUTTERFLY_ROOF, PAVILION_ROOF,
  /// DOME_ROOF, FREEFORM, NOTDEFINED
  private string _predefinedType = "FLAT_ROOF";
  string predefinedType() { return _predefinedType; }
  UIMBimRoof predefinedType(string value) { _predefinedType = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["pitchAngle"]     = Json(_pitchAngle);
    obj["overhang"]       = Json(_overhang);
    obj["predefinedType"] = Json(_predefinedType);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["pitchAngle"].type     == Json.Type.float_)  _pitchAngle     = data["pitchAngle"].get!double;
    if (data["overhang"].type       == Json.Type.float_)  _overhang       = data["overhang"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    return this;
  }
}
