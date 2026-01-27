/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.integers.boolean;

import uim.entities;

@safe:
class DIntegerBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerBooleanAttribute"));

  mixin(OProperty!("bool[int]", "lookups"));  
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
      .registerPath("lookup");
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false); 
  }
  bool hasLookupValue(bool lookupValue) {
    foreach(k, v; _lookups) { if (v == lookupValue) { return true; } }
    return false; 
  }  

  override UIMValue createValue() {
    return LookupValue!(int, bool)(this).isNullable(isNullable); }  
}
mixin(AttributeCalls!("IntegerBooleanAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}