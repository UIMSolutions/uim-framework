/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.bim.properties.classification;

import uim.bim;

mixin(ShowModule!());

@safe:

/**
 * UIMBimClassification - Concrete implementation of IBimClassification.
 * Supports Uniclass 2015, OmniClass, MasterFormat, UniFormat, ETIM and custom schemes.
 */
class UIMBimClassification : IBimClassification {
  this() {}

  this(string system, string code, string label) {
    _system = system;
    _code   = code;
    _label  = label;
  }

  private string _system;
  string system() { return _system; }
  IBimClassification system(string value) { _system = value; return this; }

  private string _edition;
  string edition() { return _edition; }
  IBimClassification edition(string value) { _edition = value; return this; }

  private string _code;
  string code() { return _code; }
  IBimClassification code(string value) { _code = value; return this; }

  private string _label;
  string label() { return _label; }
  IBimClassification label(string value) { _label = value; return this; }

  private string _location;
  string location() { return _location; }
  IBimClassification location(string value) { _location = value; return this; }

  Json toJson() {
    auto obj = Json.emptyObject;
    obj["system"]   = Json(_system);
    obj["edition"]  = Json(_edition);
    obj["code"]     = Json(_code);
    obj["label"]    = Json(_label);
    obj["location"] = Json(_location);
    return obj;
  }

  IBimClassification fromJson(Json data) {
    if (data["system"].type   == Json.Type.string_) _system   = data["system"].get!string;
    if (data["edition"].type  == Json.Type.string_) _edition  = data["edition"].get!string;
    if (data["code"].type     == Json.Type.string_) _code     = data["code"].get!string;
    if (data["label"].type    == Json.Type.string_) _label    = data["label"].get!string;
    if (data["location"].type == Json.Type.string_) _location = data["location"].get!string;
    return this;
  }
}
