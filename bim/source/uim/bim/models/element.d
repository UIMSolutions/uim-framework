/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.models.element;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimElement - Abstract base class for all BIM entities.
 * Provides IFC-compliant identity, property management, classification,
 * and parent/child relationship tracking.
 */
class UIMBimElement : UIMObject, IBimElement {
  this() {
    super();
    import std.uuid : randomUUID;
    _globalId = randomUUID().toString();
  }

  this(string name) {
    this();
    this.name(name);
  }

  // #region identity
  private string _globalId;
  string globalId() { return _globalId; }
  IBimElement globalId(string value) { _globalId = value; return this; }

  private string _name;
  string name() { return _name; }
  IBimElement name(string value) { _name = value; return this; }

  private string _description;
  string description() { return _description; }
  IBimElement description(string value) { _description = value; return this; }

  private string _objectType;
  string objectType() { return _objectType; }
  IBimElement objectType(string value) { _objectType = value; return this; }

  private string _tag;
  string tag() { return _tag; }
  IBimElement tag(string value) { _tag = value; return this; }
  // #endregion identity

  // #region classification
  string ifcClass() { return "IfcProduct"; }

  private string[] _classifications;
  string[] classifications() { return _classifications.dup; }

  IBimElement addClassification(string code) {
    import std.algorithm : canFind;
    if (!_classifications.canFind(code)) {
      _classifications ~= code;
    }
    return this;
  }

  IBimElement removeClassification(string code) {
    import std.algorithm : filter;
    import std.array : array;
    _classifications = _classifications.filter!(c => c != code).array;
    return this;
  }
  // #endregion classification

  // #region properties
  private Json[string] _properties;
  Json[string] properties() { return _properties.dup; }
  IBimElement properties(Json[string] value) { _properties = value.dup; return this; }

  IBimElement setProperty(string key, Json value) {
    _properties[key] = value;
    return this;
  }

  Json getProperty(string key, Json defaultValue = Json.undefined) {
    return (key in _properties) ? _properties[key] : defaultValue;
  }

  bool hasProperty(string key) {
    return (key in _properties) !is null;
  }
  // #endregion properties

  // #region relationships
  private string _parentId;
  string parentId() { return _parentId; }
  IBimElement parentId(string value) { _parentId = value; return this; }

  private string[] _childIds;
  string[] childIds() { return _childIds.dup; }

  IBimElement addChildId(string id) {
    import std.algorithm : canFind;
    if (!_childIds.canFind(id)) {
      _childIds ~= id;
    }
    return this;
  }

  IBimElement removeChildId(string id) {
    import std.algorithm : filter;
    import std.array : array;
    _childIds = _childIds.filter!(c => c != id).array;
    return this;
  }
  // #endregion relationships

  // #region serialization
  Json toJson() {
    auto obj = Json.emptyObject;
    obj["globalId"]       = Json(_globalId);
    obj["ifcClass"]       = Json(ifcClass());
    obj["name"]           = Json(_name);
    obj["description"]    = Json(_description);
    obj["objectType"]     = Json(_objectType);
    obj["tag"]            = Json(_tag);
    obj["parentId"]       = Json(_parentId);

    auto clArr = Json.emptyArray;
    foreach (c; _classifications) { clArr ~= Json(c); }
    obj["classifications"] = clArr;

    auto cidArr = Json.emptyArray;
    foreach (id; _childIds) { cidArr ~= Json(id); }
    obj["childIds"] = cidArr;

    auto props = Json.emptyObject;
    foreach (k, v; _properties) { props[k] = v; }
    obj["properties"] = props;

    return obj;
  }

  IBimElement fromJson(Json data) {
    if (data.type != Json.Type.object_) return this;
    if (data["globalId"].type    == Json.Type.string_) _globalId    = data["globalId"].get!string;
    if (data["name"].type        == Json.Type.string_) _name        = data["name"].get!string;
    if (data["description"].type == Json.Type.string_) _description = data["description"].get!string;
    if (data["objectType"].type  == Json.Type.string_) _objectType  = data["objectType"].get!string;
    if (data["tag"].type         == Json.Type.string_) _tag         = data["tag"].get!string;
    if (data["parentId"].type    == Json.Type.string_) _parentId    = data["parentId"].get!string;

    if (data["classifications"].type == Json.Type.array_) {
      _classifications = null;
      foreach (c; data["classifications"].get!(Json[])) {
        if (c.type == Json.Type.string_) _classifications ~= c.get!string;
      }
    }
    if (data["childIds"].type == Json.Type.array_) {
      _childIds = null;
      foreach (id; data["childIds"].get!(Json[])) {
        if (id.type == Json.Type.string_) _childIds ~= id.get!string;
      }
    }
    if (data["properties"].type == Json.Type.object_) {
      foreach (string k, v; data["properties"]) {
        _properties[k] = v;
      }
    }
    return this;
  }
  // #endregion serialization
}
