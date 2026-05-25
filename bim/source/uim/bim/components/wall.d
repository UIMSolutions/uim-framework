/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.wall;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimWall - Wall element (IfcWall / IfcWallStandardCase).
 */
class UIMBimWall : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcWall"; }

  // #region geometry
  /// Wall length in metres
  private double _length;
  double length() { return _length; }
  UIMBimWall length(double value) { _length = value; return this; }

  /// Wall height in metres
  private double _height;
  double height() { return _height; }
  UIMBimWall height(double value) { _height = value; return this; }

  /// Wall thickness in metres
  private double _thickness;
  double thickness() { return _thickness; }
  UIMBimWall thickness(double value) { _thickness = value; return this; }
  // #endregion geometry

  // #region type
  /// STANDARD, POLYGONAL, SHEAR, ELEMENTEDWALL, PLUMBINGWALL, USERDEFINED, NOTDEFINED
  private string _predefinedType = "STANDARD";
  string predefinedType() { return _predefinedType; }
  UIMBimWall predefinedType(string value) { _predefinedType = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["length"]         = Json(_length);
    obj["height"]         = Json(_height);
    obj["thickness"]      = Json(_thickness);
    obj["predefinedType"] = Json(_predefinedType);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["length"].type         == Json.Type.float_)  _length         = data["length"].get!double;
    if (data["height"].type         == Json.Type.float_)  _height         = data["height"].get!double;
    if (data["thickness"].type      == Json.Type.float_)  _thickness      = data["thickness"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    return this;
  }
}
