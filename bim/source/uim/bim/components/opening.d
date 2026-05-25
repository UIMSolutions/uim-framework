/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.opening;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimOpening - Opening element (IfcOpeningElement).
 * Represents a void or recess in a wall, slab, or roof.
 */
class UIMBimOpening : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcOpeningElement"; }

  // #region geometry
  private double _width;
  double width() { return _width; }
  UIMBimOpening width(double value) { _width = value; return this; }

  private double _height;
  double height() { return _height; }
  UIMBimOpening height(double value) { _height = value; return this; }

  private double _depth;
  double depth() { return _depth; }
  UIMBimOpening depth(double value) { _depth = value; return this; }
  // #endregion geometry

  // #region type
  /// OPENING, RECESS, USERDEFINED, NOTDEFINED
  private string _predefinedType = "OPENING";
  string predefinedType() { return _predefinedType; }
  UIMBimOpening predefinedType(string value) { _predefinedType = value; return this; }

  /// globalId of the host element (wall, slab, etc.)
  private string _hostElementId;
  string hostElementId() { return _hostElementId; }
  UIMBimOpening hostElementId(string value) { _hostElementId = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["width"]          = Json(_width);
    obj["height"]         = Json(_height);
    obj["depth"]          = Json(_depth);
    obj["predefinedType"] = Json(_predefinedType);
    obj["hostElementId"]  = Json(_hostElementId);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["width"].type          == Json.Type.float_)  _width          = data["width"].get!double;
    if (data["height"].type         == Json.Type.float_)  _height         = data["height"].get!double;
    if (data["depth"].type          == Json.Type.float_)  _depth          = data["depth"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    if (data["hostElementId"].type  == Json.Type.string_) _hostElementId  = data["hostElementId"].get!string;
    return this;
  }
}
