/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.models.site;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimSite - Concrete implementation of IBimSite (IfcSite).
 */
class UIMBimSite : UIMBimElement, IBimSite {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcSite"; }

  // #region location
  private double _latitude  = 0.0;
  double latitude() { return _latitude; }
  IBimSite latitude(double value) { _latitude = value; return this; }

  private double _longitude = 0.0;
  double longitude() { return _longitude; }
  IBimSite longitude(double value) { _longitude = value; return this; }

  private double _elevation = 0.0;
  double elevation() { return _elevation; }
  IBimSite elevation(double value) { _elevation = value; return this; }

  private string _landTitleNumber;
  string landTitleNumber() { return _landTitleNumber; }
  IBimSite landTitleNumber(string value) { _landTitleNumber = value; return this; }

  private string _siteAddress;
  string siteAddress() { return _siteAddress; }
  IBimSite siteAddress(string value) { _siteAddress = value; return this; }
  // #endregion location

  // #region buildings
  private string[] _buildingIds;
  string[] buildingIds() { return _buildingIds.dup; }

  IBimSite addBuildingId(string id) {
    import std.algorithm : canFind;
    if (!_buildingIds.canFind(id)) { _buildingIds ~= id; }
    return this;
  }

  IBimSite removeBuildingId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _buildingIds = _buildingIds.filter!(b => b != id).array;
    return this;
  }
  // #endregion buildings

  override Json toJson() {
    auto obj = super.toJson();
    obj["latitude"]        = Json(_latitude);
    obj["longitude"]       = Json(_longitude);
    obj["elevation"]       = Json(_elevation);
    obj["landTitleNumber"] = Json(_landTitleNumber);
    obj["siteAddress"]     = Json(_siteAddress);

    auto arr = Json.emptyArray;
    foreach (id; _buildingIds) { arr ~= Json(id); }
    obj["buildingIds"] = arr;
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["latitude"].type        == Json.Type.float_)  _latitude        = data["latitude"].get!double;
    if (data["longitude"].type       == Json.Type.float_)  _longitude       = data["longitude"].get!double;
    if (data["elevation"].type       == Json.Type.float_)  _elevation       = data["elevation"].get!double;
    if (data["landTitleNumber"].type == Json.Type.string_) _landTitleNumber = data["landTitleNumber"].get!string;
    if (data["siteAddress"].type     == Json.Type.string_) _siteAddress     = data["siteAddress"].get!string;
    if (data["buildingIds"].type     == Json.Type.array_) {
      _buildingIds = null;
      foreach (id; data["buildingIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _buildingIds ~= id.get!string;
      }
    }
    return this;
  }
}
