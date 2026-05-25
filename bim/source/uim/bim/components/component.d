/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.components.component;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimComponent - Abstract base class for all physical building components.
 * Extends UIMBimElement with placement, material, and structural attributes.
 */
class UIMBimComponent : UIMBimElement, IBimComponent {
  this() { super(); }
  this(string name) { super(name); }

  override string ifcClass() { return "IfcBuildingElement"; }

  // #region placement
  private double _posX;
  double posX() { return _posX; }
  IBimComponent posX(double value) { _posX = value; return this; }

  private double _posY;
  double posY() { return _posY; }
  IBimComponent posY(double value) { _posY = value; return this; }

  private double _posZ;
  double posZ() { return _posZ; }
  IBimComponent posZ(double value) { _posZ = value; return this; }

  private double _rotationZ;
  double rotationZ() { return _rotationZ; }
  IBimComponent rotationZ(double value) { _rotationZ = value; return this; }
  // #endregion placement

  // #region material
  private string _materialId;
  string materialId() { return _materialId; }
  IBimComponent materialId(string value) { _materialId = value; return this; }

  private string[] _layerMaterialIds;
  string[] layerMaterialIds() { return _layerMaterialIds.dup; }

  IBimComponent addLayerMaterialId(string id) {
    import std.algorithm : canFind;
    if (!_layerMaterialIds.canFind(id)) { _layerMaterialIds ~= id; }
    return this;
  }

  IBimComponent removeLayerMaterialId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _layerMaterialIds = _layerMaterialIds.filter!(m => m != id).array;
    return this;
  }
  // #endregion material

  // #region structural
  private bool _isLoadBearing;
  bool isLoadBearing() { return _isLoadBearing; }
  IBimComponent isLoadBearing(bool value) { _isLoadBearing = value; return this; }

  private bool _isExternal;
  bool isExternal() { return _isExternal; }
  IBimComponent isExternal(bool value) { _isExternal = value; return this; }
  // #endregion structural

  override Json toJson() {
    auto obj = super.toJson();
    obj["posX"]          = Json(_posX);
    obj["posY"]          = Json(_posY);
    obj["posZ"]          = Json(_posZ);
    obj["rotationZ"]     = Json(_rotationZ);
    obj["materialId"]    = Json(_materialId);
    obj["isLoadBearing"] = Json(_isLoadBearing);
    obj["isExternal"]    = Json(_isExternal);

    auto lArr = Json.emptyArray;
    foreach (id; _layerMaterialIds) { lArr ~= Json(id); }
    obj["layerMaterialIds"] = lArr;
    return obj;
  }

  override IBimElement fromJson(Json data) {
    super.fromJson(data);
    if (data["posX"].type          == Json.Type.float_)  _posX          = data["posX"].get!double;
    if (data["posY"].type          == Json.Type.float_)  _posY          = data["posY"].get!double;
    if (data["posZ"].type          == Json.Type.float_)  _posZ          = data["posZ"].get!double;
    if (data["rotationZ"].type     == Json.Type.float_)  _rotationZ     = data["rotationZ"].get!double;
    if (data["materialId"].type    == Json.Type.string_) _materialId    = data["materialId"].get!string;
    if (data["isLoadBearing"].type == Json.Type.bool_)   _isLoadBearing = data["isLoadBearing"].get!bool;
    if (data["isExternal"].type    == Json.Type.bool_)   _isExternal    = data["isExternal"].get!bool;
    if (data["layerMaterialIds"].type == Json.Type.array_) {
      _layerMaterialIds = null;
      foreach (id; data["layerMaterialIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _layerMaterialIds ~= id.get!string;
      }
    }
    return this;
  }
}
