/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.properties.material;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimMaterial - Concrete implementation of IBimMaterial (IfcMaterial).
 */
class UIMBimMaterial : IBimMaterial {
  this() {
    import std.uuid : randomUUID;
    _globalId = randomUUID().toString();
  }

  this(string name) {
    this();
    _name = name;
  }

  private string _globalId;
  string globalId() { return _globalId; }
  IBimMaterial globalId(string value) { _globalId = value; return this; }

  private string _name;
  string name() { return _name; }
  IBimMaterial name(string value) { _name = value; return this; }

  private string _description;
  string description() { return _description; }
  IBimMaterial description(string value) { _description = value; return this; }

  private string _category;
  string category() { return _category; }
  IBimMaterial category(string value) { _category = value; return this; }

  private double _density;
  double density() { return _density; }
  IBimMaterial density(double value) { _density = value; return this; }

  private double _thermalConductivity;
  double thermalConductivity() { return _thermalConductivity; }
  IBimMaterial thermalConductivity(double value) { _thermalConductivity = value; return this; }

  private double _specificHeat;
  double specificHeat() { return _specificHeat; }
  IBimMaterial specificHeat(double value) { _specificHeat = value; return this; }

  private string _colour = "#CCCCCC";
  string colour() { return _colour; }
  IBimMaterial colour(string value) { _colour = value; return this; }

  private Json[string] _properties;
  Json[string] properties() { return _properties.dup; }
  IBimMaterial setProperty(string key, Json value) { _properties[key] = value; return this; }

  Json toJson() {
    auto obj = Json.emptyObject;
    obj["globalId"]            = Json(_globalId);
    obj["name"]                = Json(_name);
    obj["description"]         = Json(_description);
    obj["category"]            = Json(_category);
    obj["density"]             = Json(_density);
    obj["thermalConductivity"] = Json(_thermalConductivity);
    obj["specificHeat"]        = Json(_specificHeat);
    obj["colour"]              = Json(_colour);
    auto props = Json.emptyObject;
    foreach (k, v; _properties) { props[k] = v; }
    obj["properties"] = props;
    return obj;
  }

  IBimMaterial fromJson(Json data) {
    if (data["globalId"].type            == Json.Type.string_) _globalId            = data["globalId"].get!string;
    if (data["name"].type                == Json.Type.string_) _name                = data["name"].get!string;
    if (data["description"].type         == Json.Type.string_) _description         = data["description"].get!string;
    if (data["category"].type            == Json.Type.string_) _category            = data["category"].get!string;
    if (data["density"].type             == Json.Type.float_)  _density             = data["density"].get!double;
    if (data["thermalConductivity"].type == Json.Type.float_)  _thermalConductivity = data["thermalConductivity"].get!double;
    if (data["specificHeat"].type        == Json.Type.float_)  _specificHeat        = data["specificHeat"].get!double;
    if (data["colour"].type              == Json.Type.string_) _colour              = data["colour"].get!string;
    if (data["properties"].type          == Json.Type.object_) {
      foreach (string k, v; data["properties"]) { _properties[k] = v; }
    }
    return this;
  }
}
