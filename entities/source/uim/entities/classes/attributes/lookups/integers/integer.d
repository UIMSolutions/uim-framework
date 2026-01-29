/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.integers.integer;

import uim.entities;

@safe:
class IntegerIntegerAttribute : DLookupAttribute {
  mixin(AttributeThis!("IntegerIntegerAttribute"));

  mixin(OProperty!("int[int]", "lookups"));  
  O addLookup(this O)(int key, string value) {
    _lookups[key] = value;
    return cast(O)this;
  }

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.lookup

    this.name("lookup")
      .dataFormats(["lookup", "integer", "string"]);
    this.registerPath("lookup");
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false); 
  }
  bool hasLookupValue(int lookupValue) {
    foreach(k, v; _lookups) { if (v == lookupValue) { return true; } }
    return false; 
  }  

  override UIMValue createValue() {
    return LookupValue!(int, int)(this).isNullable(isNullable); }  
}
mixin(AttributeCalls!("IntegerIntegerAttribute"));

