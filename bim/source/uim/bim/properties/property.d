/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.properties.property;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimProperty - Concrete implementation of IBimProperty (IfcProperty).
 * Stores a single named, typed value with an optional unit of measure.
 */
class UIMBimProperty : IBimProperty {
  this() {}

  this(string name, Json value, string unit = "") {
    _name  = name;
    _value = value;
    _unit  = unit;
  }

  private string _name;
  string name() { return _name; }
  IBimProperty name(string value) { _name = value; return this; }

  private string _description;
  string description() { return _description; }
  IBimProperty description(string value) { _description = value; return this; }

  private Json _value = Json.undefined;
  Json value() { return _value; }
  IBimProperty value(Json v) { _value = v; return this; }

  private string _unit;
  string unit() { return _unit; }
  IBimProperty unit(string value) { _unit = value; return this; }

  Json toJson() {
    auto obj = Json.emptyObject;
    obj["name"]        = Json(_name);
    obj["description"] = Json(_description);
    obj["value"]       = _value;
    obj["unit"]        = Json(_unit);
    return obj;
  }

  static UIMBimProperty fromJson(Json data) {
    auto p = new UIMBimProperty();
    if (data["name"].type        == Json.Type.string_) p._name        = data["name"].get!string;
    if (data["description"].type == Json.Type.string_) p._description = data["description"].get!string;
    if (data["unit"].type        == Json.Type.string_) p._unit        = data["unit"].get!string;
    if (data["value"].type       != Json.Type.undefined_) p._value    = data["value"];
    return p;
  }
}
