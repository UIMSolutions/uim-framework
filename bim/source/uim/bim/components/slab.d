/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.slab;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimSlab - Slab element (IfcSlab).
 * Covers floors, ceilings, roofs, and landing slabs.
 */
class UIMBimSlab : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcSlab"; }

  // #region geometry
  /// Slab thickness in metres
  private double _thickness;
  double thickness() { return _thickness; }
  UIMBimSlab thickness(double value) { _thickness = value; return this; }
  // #endregion geometry

  // #region type
  /// FLOOR, ROOF, LANDING, BASESLAB, USERDEFINED, NOTDEFINED
  private string _predefinedType = "FLOOR";
  string predefinedType() { return _predefinedType; }
  UIMBimSlab predefinedType(string value) { _predefinedType = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["thickness"]      = Json(_thickness);
    obj["predefinedType"] = Json(_predefinedType);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["thickness"].type      == Json.Type.float_)  _thickness      = data["thickness"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    return this;
  }
}
