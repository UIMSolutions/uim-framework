/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.long_;

import uim.entities;

@safe:
class DLongAttribute : UIMAttribute {
  mixin(AttributeThis!("LongAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .addDataFormats(["long"])
      .name("long");
    this.registerPath("long");
  }    
}
mixin(AttributeCalls!("LongAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DLongAttribute);
    testAttribute(LongAttribute);
  }
}