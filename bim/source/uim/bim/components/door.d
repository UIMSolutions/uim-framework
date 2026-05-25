/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.door;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimDoor - Door element (IfcDoor).
 */
class UIMBimDoor : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcDoor"; }

  // #region geometry
  /// Overall door height in metres
  private double _overallHeight;
  double overallHeight() { return _overallHeight; }
  UIMBimDoor overallHeight(double value) { _overallHeight = value; return this; }

  /// Overall door width in metres
  private double _overallWidth;
  double overallWidth() { return _overallWidth; }
  UIMBimDoor overallWidth(double value) { _overallWidth = value; return this; }
  // #endregion geometry

  // #region type
  /// DOOR, GATE, TRAPDOOR, NOTDEFINED
  private string _predefinedType = "DOOR";
  string predefinedType() { return _predefinedType; }
  UIMBimDoor predefinedType(string value) { _predefinedType = value; return this; }

  /// SINGLE_SWING_LEFT, SINGLE_SWING_RIGHT, DOUBLE_DOOR_SINGLE_SWING, etc.
  private string _operationType = "SINGLE_SWING_LEFT";
  string operationType() { return _operationType; }
  UIMBimDoor operationType(string value) { _operationType = value; return this; }

  private bool _isFireRated;
  bool isFireRated() { return _isFireRated; }
  UIMBimDoor isFireRated(bool value) { _isFireRated = value; return this; }

  private string _fireRating;
  string fireRating() { return _fireRating; }
  UIMBimDoor fireRating(string value) { _fireRating = value; return this; }

  private bool _isAccessible;
  bool isAccessible() { return _isAccessible; }
  UIMBimDoor isAccessible(bool value) { _isAccessible = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["overallHeight"]  = Json(_overallHeight);
    obj["overallWidth"]   = Json(_overallWidth);
    obj["predefinedType"] = Json(_predefinedType);
    obj["operationType"]  = Json(_operationType);
    obj["isFireRated"]    = Json(_isFireRated);
    obj["fireRating"]     = Json(_fireRating);
    obj["isAccessible"]   = Json(_isAccessible);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["overallHeight"].type  == Json.Type.float_)  _overallHeight  = data["overallHeight"].get!double;
    if (data["overallWidth"].type   == Json.Type.float_)  _overallWidth   = data["overallWidth"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    if (data["operationType"].type  == Json.Type.string_) _operationType  = data["operationType"].get!string;
    if (data["isFireRated"].type    == Json.Type.bool_)   _isFireRated    = data["isFireRated"].get!bool;
    if (data["fireRating"].type     == Json.Type.string_) _fireRating     = data["fireRating"].get!string;
    if (data["isAccessible"].type   == Json.Type.bool_)   _isAccessible   = data["isAccessible"].get!bool;
    return this;
  }
}
