/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.properties.propertyset;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimPropertySet - Named collection of properties (IfcPropertySet).
 * Used to attach discipline-specific data (Pset_WallCommon, Pset_SpaceCommon, etc.)
 * to any BIM element.
 */
class UIMBimPropertySet : IBimPropertySet {
  this() {}
  this(string name) { _name = name; }

  private string _name;
  string name() { return _name; }
  IBimPropertySet name(string value) { _name = value; return this; }

  private string _description;
  string description() { return _description; }
  IBimPropertySet description(string value) { _description = value; return this; }

  private IBimProperty[string] _properties;
  IBimProperty[string] properties() { return _properties.dup; }

  IBimPropertySet addProperty(IBimProperty prop) {
    _properties[prop.name()] = prop;
    return this;
  }

  IBimPropertySet removeProperty(string propName) {
    _properties.remove(propName);
    return this;
  }

  bool hasProperty(string propName) {
    return (propName in _properties) !is null;
  }

  IBimProperty getProperty(string propName) {
    auto ptr = propName in _properties;
    return ptr ? *ptr : null;
  }

  Json toJson() {
    auto obj = Json.emptyObject;
    obj["name"]        = Json(_name);
    obj["description"] = Json(_description);
    auto props = Json.emptyObject;
    foreach (k, p; _properties) { props[k] = p.toJson(); }
    obj["properties"] = props;
    return obj;
  }

  IBimPropertySet fromJson(Json data) {
    if (data["name"].type        == Json.Type.string_) _name        = data["name"].get!string;
    if (data["description"].type == Json.Type.string_) _description = data["description"].get!string;
    if (data["properties"].type  == Json.Type.object_) {
      foreach (string k, v; data["properties"]) {
        _properties[k] = UIMBimProperty.fromJson(v);
      }
    }
    return this;
  }
}
