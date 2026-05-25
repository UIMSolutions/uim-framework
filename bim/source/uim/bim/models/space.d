/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.models.space;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimSpace - Concrete implementation of IBimSpace (IfcSpace).
 */
class UIMBimSpace : UIMBimElement, IBimSpace {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcSpace"; }

  // #region identity
  private string _spaceNumber;
  string spaceNumber() { return _spaceNumber; }
  IBimSpace spaceNumber(string value) { _spaceNumber = value; return this; }

  private string _predefinedType = "SPACE";
  string predefinedType() { return _predefinedType; }
  IBimSpace predefinedType(string value) { _predefinedType = value; return this; }

  private string _longName;
  string longName() { return _longName; }
  IBimSpace longName(string value) { _longName = value; return this; }
  // #endregion identity

  // #region metrics
  private double _grossFloorArea;
  double grossFloorArea() { return _grossFloorArea; }
  IBimSpace grossFloorArea(double value) { _grossFloorArea = value; return this; }

  private double _netFloorArea;
  double netFloorArea() { return _netFloorArea; }
  IBimSpace netFloorArea(double value) { _netFloorArea = value; return this; }

  private double _netHeight;
  double netHeight() { return _netHeight; }
  IBimSpace netHeight(double value) { _netHeight = value; return this; }

  private double _grossVolume;
  double grossVolume() { return _grossVolume; }
  IBimSpace grossVolume(double value) { _grossVolume = value; return this; }

  private double _netVolume;
  double netVolume() { return _netVolume; }
  IBimSpace netVolume(double value) { _netVolume = value; return this; }
  // #endregion metrics

  // #region components
  private string[] _componentIds;
  string[] componentIds() { return _componentIds.dup; }

  IBimSpace addComponentId(string id) {
    import std.algorithm : canFind;
    if (!_componentIds.canFind(id)) { _componentIds ~= id; }
    return this;
  }

  IBimSpace removeComponentId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _componentIds = _componentIds.filter!(c => c != id).array;
    return this;
  }
  // #endregion components

  override Json toJson() {
    auto obj = super.toJson();
    obj["spaceNumber"]    = Json(_spaceNumber);
    obj["predefinedType"] = Json(_predefinedType);
    obj["longName"]       = Json(_longName);
    obj["grossFloorArea"] = Json(_grossFloorArea);
    obj["netFloorArea"]   = Json(_netFloorArea);
    obj["netHeight"]      = Json(_netHeight);
    obj["grossVolume"]    = Json(_grossVolume);
    obj["netVolume"]      = Json(_netVolume);

    auto cArr = Json.emptyArray;
    foreach (id; _componentIds) { cArr ~= Json(id); }
    obj["componentIds"] = cArr;
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["spaceNumber"].type    == Json.Type.string_) _spaceNumber    = data["spaceNumber"].get!string;
    if (data["predefinedType"].type == Json.Type.string_) _predefinedType = data["predefinedType"].get!string;
    if (data["longName"].type       == Json.Type.string_) _longName       = data["longName"].get!string;
    if (data["grossFloorArea"].type == Json.Type.float_)  _grossFloorArea = data["grossFloorArea"].get!double;
    if (data["netFloorArea"].type   == Json.Type.float_)  _netFloorArea   = data["netFloorArea"].get!double;
    if (data["netHeight"].type      == Json.Type.float_)  _netHeight      = data["netHeight"].get!double;
    if (data["grossVolume"].type    == Json.Type.float_)  _grossVolume    = data["grossVolume"].get!double;
    if (data["netVolume"].type      == Json.Type.float_)  _netVolume      = data["netVolume"].get!double;
    if (data["componentIds"].type   == Json.Type.array_) {
      _componentIds = null;
      foreach (id; data["componentIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _componentIds ~= id.get!string;
      }
    }
    return this;
  }
}
