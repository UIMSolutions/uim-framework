/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.stair;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimStair - Stair element (IfcStair).
 */
class UIMBimStair : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcStair"; }

  // #region geometry
  private int _numberOfRisers;
  int numberOfRisers() { return _numberOfRisers; }
  UIMBimStair numberOfRisers(int value) { _numberOfRisers = value; return this; }

  private int _numberOfTreads;
  int numberOfTreads() { return _numberOfTreads; }
  UIMBimStair numberOfTreads(int value) { _numberOfTreads = value; return this; }

  /// Riser height in metres
  private double _riserHeight;
  double riserHeight() { return _riserHeight; }
  UIMBimStair riserHeight(double value) { _riserHeight = value; return this; }

  /// Tread depth in metres
  private double _treadDepth;
  double treadDepth() { return _treadDepth; }
  UIMBimStair treadDepth(double value) { _treadDepth = value; return this; }

  /// Stair width in metres
  private double _width;
  double width() { return _width; }
  UIMBimStair width(double value) { _width = value; return this; }
  // #endregion geometry

  // #region type
  /// STRAIGHT_RUN_STAIR, TWO_STRAIGHT_RUN_STAIR, QUARTER_WINDING_STAIR, SPIRAL_STAIR, etc.
  private string _predefinedType = "STRAIGHT_RUN_STAIR";
  string predefinedType() { return _predefinedType; }
  UIMBimStair predefinedType(string value) { _predefinedType = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["numberOfRisers"]  = Json(_numberOfRisers);
    obj["numberOfTreads"]  = Json(_numberOfTreads);
    obj["riserHeight"]     = Json(_riserHeight);
    obj["treadDepth"]      = Json(_treadDepth);
    obj["width"]           = Json(_width);
    obj["predefinedType"]  = Json(_predefinedType);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["numberOfRisers"].type  == Json.Type.int_)    _numberOfRisers = cast(int) data["numberOfRisers"].get!long;
    if (data["numberOfTreads"].type  == Json.Type.int_)    _numberOfTreads = cast(int) data["numberOfTreads"].get!long;
    if (data["riserHeight"].type     == Json.Type.float_)  _riserHeight    = data["riserHeight"].get!double;
    if (data["treadDepth"].type      == Json.Type.float_)  _treadDepth     = data["treadDepth"].get!double;
    if (data["width"].type           == Json.Type.float_)  _width          = data["width"].get!double;
    if (data["predefinedType"].type  == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    return this;
  }
}
