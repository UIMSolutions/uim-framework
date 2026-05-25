/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.models.storey;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimStorey - Concrete implementation of IBimStorey (IfcBuildingStorey).
 */
class UIMBimStorey : UIMBimElement, IBimStorey {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcBuildingStorey"; }

  // #region elevation
  private double _elevation;
  double elevation() { return _elevation; }
  IBimStorey elevation(double value) { _elevation = value; return this; }

  private double _floorHeight;
  double floorHeight() { return _floorHeight; }
  IBimStorey floorHeight(double value) { _floorHeight = value; return this; }

  private double _netHeight;
  double netHeight() { return _netHeight; }
  IBimStorey netHeight(double value) { _netHeight = value; return this; }

  private int _storeyNumber;
  int storeyNumber() { return _storeyNumber; }
  IBimStorey storeyNumber(int value) { _storeyNumber = value; return this; }
  // #endregion elevation

  // #region spaces
  private string[] _spaceIds;
  string[] spaceIds() { return _spaceIds.dup; }

  IBimStorey addSpaceId(string id) {
    import std.algorithm : canFind;
    if (!_spaceIds.canFind(id)) { _spaceIds ~= id; }
    return this;
  }

  IBimStorey removeSpaceId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _spaceIds = _spaceIds.filter!(s => s != id).array;
    return this;
  }
  // #endregion spaces

  // #region components
  private string[] _componentIds;
  string[] componentIds() { return _componentIds.dup; }

  IBimStorey addComponentId(string id) {
    import std.algorithm : canFind;
    if (!_componentIds.canFind(id)) { _componentIds ~= id; }
    return this;
  }

  IBimStorey removeComponentId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _componentIds = _componentIds.filter!(c => c != id).array;
    return this;
  }
  // #endregion components

  // #region metrics
  private double _grossArea;
  double grossArea() { return _grossArea; }
  IBimStorey grossArea(double value) { _grossArea = value; return this; }

  private double _netArea;
  double netArea() { return _netArea; }
  IBimStorey netArea(double value) { _netArea = value; return this; }
  // #endregion metrics

  override Json toJson() {
    auto obj = super.toJson();
    obj["elevation"]    = Json(_elevation);
    obj["floorHeight"]  = Json(_floorHeight);
    obj["netHeight"]    = Json(_netHeight);
    obj["storeyNumber"] = Json(_storeyNumber);
    obj["grossArea"]    = Json(_grossArea);
    obj["netArea"]      = Json(_netArea);

    auto sArr = Json.emptyArray;
    foreach (id; _spaceIds) { sArr ~= Json(id); }
    obj["spaceIds"] = sArr;

    auto cArr = Json.emptyArray;
    foreach (id; _componentIds) { cArr ~= Json(id); }
    obj["componentIds"] = cArr;
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["elevation"].type    == Json.Type.float_) _elevation    = data["elevation"].get!double;
    if (data["floorHeight"].type  == Json.Type.float_) _floorHeight  = data["floorHeight"].get!double;
    if (data["netHeight"].type    == Json.Type.float_) _netHeight    = data["netHeight"].get!double;
    if (data["storeyNumber"].type == Json.Type.int_)   _storeyNumber = cast(int) data["storeyNumber"].get!long;
    if (data["grossArea"].type    == Json.Type.float_) _grossArea    = data["grossArea"].get!double;
    if (data["netArea"].type      == Json.Type.float_) _netArea      = data["netArea"].get!double;
    if (data["spaceIds"].type     == Json.Type.array_) {
      _spaceIds = null;
      foreach (id; data["spaceIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _spaceIds ~= id.get!string;
      }
    }
    if (data["componentIds"].type == Json.Type.array_) {
      _componentIds = null;
      foreach (id; data["componentIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _componentIds ~= id.get!string;
      }
    }
    return this;
  }
}
