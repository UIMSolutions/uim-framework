/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.lookup;

import uim.entities;

@safe:
class DLookupAttribute : DAttribute {
  mixin(AttributeThis!("LookupAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.lookup

    this
      .name("lookup")
      .dataFormats(["lookup"])
      .registerPath("lookup");
  }

/*   override UIMValue createValue() {
    return LookupValue(this); } */
}
mixin(AttributeCalls!("LookupAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}