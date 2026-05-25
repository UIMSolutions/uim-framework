/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.models.building;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimBuilding - Concrete implementation of IBimBuilding (IfcBuilding).
 */
class UIMBimBuilding : UIMBimElement, IBimBuilding {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcBuilding"; }

  // #region address
  private string _buildingAddress;
  string buildingAddress() { return _buildingAddress; }
  IBimBuilding buildingAddress(string value) { _buildingAddress = value; return this; }

  private string _yearOfConstruction;
  string yearOfConstruction() { return _yearOfConstruction; }
  IBimBuilding yearOfConstruction(string value) { _yearOfConstruction = value; return this; }

  private bool _isLandmarked;
  bool isLandmarked() { return _isLandmarked; }
  IBimBuilding isLandmarked(bool value) { _isLandmarked = value; return this; }
  // #endregion address

  // #region storeys
  private string[] _storeyIds;
  string[] storeyIds() { return _storeyIds.dup; }

  IBimBuilding addStoreyId(string id) {
    import std.algorithm : canFind;
    if (!_storeyIds.canFind(id)) { _storeyIds ~= id; }
    return this;
  }

  IBimBuilding removeStoreyId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _storeyIds = _storeyIds.filter!(s => s != id).array;
    return this;
  }
  // #endregion storeys

  // #region metrics
  private double _grossFloorArea;
  double grossFloorArea() { return _grossFloorArea; }
  IBimBuilding grossFloorArea(double value) { _grossFloorArea = value; return this; }

  private double _netFloorArea;
  double netFloorArea() { return _netFloorArea; }
  IBimBuilding netFloorArea(double value) { _netFloorArea = value; return this; }

  private double _height;
  double height() { return _height; }
  IBimBuilding height(double value) { _height = value; return this; }

  private int _numberOfStoreys;
  int numberOfStoreys() { return _numberOfStoreys; }
  IBimBuilding numberOfStoreys(int value) { _numberOfStoreys = value; return this; }
  // #endregion metrics

  override Json toJson() {
    auto obj = super.toJson();
    obj["buildingAddress"]   = Json(_buildingAddress);
    obj["yearOfConstruction"]= Json(_yearOfConstruction);
    obj["isLandmarked"]      = Json(_isLandmarked);
    obj["grossFloorArea"]    = Json(_grossFloorArea);
    obj["netFloorArea"]      = Json(_netFloorArea);
    obj["height"]            = Json(_height);
    obj["numberOfStoreys"]   = Json(_numberOfStoreys);

    auto arr = Json.emptyArray;
    foreach (id; _storeyIds) { arr ~= Json(id); }
    obj["storeyIds"] = arr;
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["buildingAddress"].type    == Json.Type.string_) _buildingAddress    = data["buildingAddress"].get!string;
    if (data["yearOfConstruction"].type == Json.Type.string_) _yearOfConstruction = data["yearOfConstruction"].get!string;
    if (data["isLandmarked"].type       == Json.Type.bool_)   _isLandmarked       = data["isLandmarked"].get!bool;
    if (data["grossFloorArea"].type     == Json.Type.float_)  _grossFloorArea     = data["grossFloorArea"].get!double;
    if (data["netFloorArea"].type       == Json.Type.float_)  _netFloorArea       = data["netFloorArea"].get!double;
    if (data["height"].type             == Json.Type.float_)  _height             = data["height"].get!double;
    if (data["numberOfStoreys"].type    == Json.Type.int_)    _numberOfStoreys    = cast(int) data["numberOfStoreys"].get!long;
    if (data["storeyIds"].type          == Json.Type.array_) {
      _storeyIds = null;
      foreach (id; data["storeyIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _storeyIds ~= id.get!string;
      }
    }
    return this;
  }
}
