/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.integers.string_;

import uim.entities;

@safe:
class DIntegerStringAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerStringAttribute"));

  mixin(OProperty!("string[int]", "lookups"));  
  O addLookup(this O)(int key, string value) {
    _lookups[key] = value;
    return cast(O)this;
  }

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.lookup

    this
      .name("lookup")
      .dataFormats(["lookup", "integer", "string"])
    this.registerPath("lookup");
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false); 
  }
  bool hasLookupValue(string lookupValue) {
    foreach(k, v; _lookups) { if (v == lookupValue) { return true; } }
    return false; 
  }  

  override UIMValue createValue() {
    return LookupValue!(int, string)(this).isNullable(isNullable); }  
}
mixin(AttributeCalls!("IntegerStringAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}