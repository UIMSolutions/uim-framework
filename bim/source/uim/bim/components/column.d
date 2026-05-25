/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.column;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimColumn - Column element (IfcColumn).
 */
class UIMBimColumn : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcColumn"; }

  // #region geometry
  /// Column height in metres
  private double _height;
  double height() { return _height; }
  UIMBimColumn height(double value) { _height = value; return this; }

  /// Cross-section width in metres
  private double _width;
  double width() { return _width; }
  UIMBimColumn width(double value) { _width = value; return this; }

  /// Cross-section depth in metres
  private double _depth;
  double depth() { return _depth; }
  UIMBimColumn depth(double value) { _depth = value; return this; }

  /// Radius for circular sections in metres (0 means rectangular)
  private double _radius;
  double radius() { return _radius; }
  UIMBimColumn radius(double value) { _radius = value; return this; }
  // #endregion geometry

  // #region type
  /// COLUMN, PILASTER, USERDEFINED, NOTDEFINED
  private string _predefinedType = "COLUMN";
  string predefinedType() { return _predefinedType; }
  UIMBimColumn predefinedType(string value) { _predefinedType = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["height"]         = Json(_height);
    obj["width"]          = Json(_width);
    obj["depth"]          = Json(_depth);
    obj["radius"]         = Json(_radius);
    obj["predefinedType"] = Json(_predefinedType);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["height"].type         == Json.Type.float_)  _height         = data["height"].get!double;
    if (data["width"].type          == Json.Type.float_)  _width          = data["width"].get!double;
    if (data["depth"].type          == Json.Type.float_)  _depth          = data["depth"].get!double;
    if (data["radius"].type         == Json.Type.float_)  _radius         = data["radius"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    return this;
  }
}
