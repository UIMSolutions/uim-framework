/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.window;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimWindow - Window element (IfcWindow).
 */
class UIMBimWindow : UIMBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcWindow"; }

  // #region geometry
  /// Overall window height in metres
  private double _overallHeight;
  double overallHeight() { return _overallHeight; }
  UIMBimWindow overallHeight(double value) { _overallHeight = value; return this; }

  /// Overall window width in metres
  private double _overallWidth;
  double overallWidth() { return _overallWidth; }
  UIMBimWindow overallWidth(double value) { _overallWidth = value; return this; }

  /// Sill height above floor level in metres
  private double _sillHeight;
  double sillHeight() { return _sillHeight; }
  UIMBimWindow sillHeight(double value) { _sillHeight = value; return this; }
  // #endregion geometry

  // #region type
  /// WINDOW, SKYLIGHT, LIGHTDOME, NOTDEFINED
  private string _predefinedType = "WINDOW";
  string predefinedType() { return _predefinedType; }
  UIMBimWindow predefinedType(string value) { _predefinedType = value; return this; }

  /// FIXED, HUNG, PIVOTHORIZONTAL, PIVOTVERTICAL, TILTANDTURNRIGHTHAND, etc.
  private string _partitioningType = "FIXED";
  string partitioningType() { return _partitioningType; }
  UIMBimWindow partitioningType(string value) { _partitioningType = value; return this; }

  /// Thermal transmittance (U-value) W/(m²·K)
  private double _uValue;
  double uValue() { return _uValue; }
  UIMBimWindow uValue(double value) { _uValue = value; return this; }

  /// Solar heat gain coefficient (0-1)
  private double _solarHeatGainCoefficient;
  double solarHeatGainCoefficient() { return _solarHeatGainCoefficient; }
  UIMBimWindow solarHeatGainCoefficient(double value) { _solarHeatGainCoefficient = value; return this; }
  // #endregion type

  override Json toJson() {
    auto obj = super.toJson();
    obj["overallHeight"]              = Json(_overallHeight);
    obj["overallWidth"]               = Json(_overallWidth);
    obj["sillHeight"]                 = Json(_sillHeight);
    obj["predefinedType"]             = Json(_predefinedType);
    obj["partitioningType"]           = Json(_partitioningType);
    obj["uValue"]                     = Json(_uValue);
    obj["solarHeatGainCoefficient"]   = Json(_solarHeatGainCoefficient);
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["overallHeight"].type            == Json.Type.float_)  _overallHeight            = data["overallHeight"].get!double;
    if (data["overallWidth"].type             == Json.Type.float_)  _overallWidth             = data["overallWidth"].get!double;
    if (data["sillHeight"].type               == Json.Type.float_)  _sillHeight               = data["sillHeight"].get!double;
    if (data["predefinedType"].type           == Json.Type.string_) _predefinedType           = data["predefinedType"].get!string;
    if (data["partitioningType"].type         == Json.Type.string_) _partitioningType         = data["partitioningType"].get!string;
    if (data["uValue"].type                   == Json.Type.float_)  _uValue                   = data["uValue"].get!double;
    if (data["solarHeatGainCoefficient"].type == Json.Type.float_)  _solarHeatGainCoefficient = data["solarHeatGainCoefficient"].get!double;
    return this;
  }
}
