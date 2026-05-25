/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.beam;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimBeam - Beam element (IfcBeam).
 */
class UIMBimBeam : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcBeam"; }

  // #region geometry
  /// Span length in metres
  private double _span;
  double span() { return _span; }
  UIMBimBeam span(double value) { _span = value; return this; }

  /// Cross-section width in metres
  private double _width;
  double width() { return _width; }
  UIMBimBeam width(double value) { _width = value; return this; }

  /// Cross-section depth (height) in metres
  private double _depth;
  double depth() { return _depth; }
  UIMBimBeam depth(double value) { _depth = value; return this; }
  // #endregion geometry

  // #region type
  /// BEAM, JOIST, HOLLOWCORE, LINTEL, SPANDREL, T_BEAM, USERDEFINED, NOTDEFINED
  private string _predefinedType = "BEAM";
  string predefinedType() { return _predefinedType; }
  UIMBimBeam predefinedType(string value) { _predefinedType = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["span"]           = Json(_span);
    obj["width"]          = Json(_width);
    obj["depth"]          = Json(_depth);
    obj["predefinedType"] = Json(_predefinedType);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["span"].type           == Json.Type.float_)  _span           = data["span"].get!double;
    if (data["width"].type          == Json.Type.float_)  _width          = data["width"].get!double;
    if (data["depth"].type          == Json.Type.float_)  _depth          = data["depth"].get!double;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    return this;
  }
}
