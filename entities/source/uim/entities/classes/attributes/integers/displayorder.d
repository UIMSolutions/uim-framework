/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.displayorder;

import uim.entities;

@safe:
class DDisplayOrderAttribute : DIntegerAttribute {
  mixin(AttributeThis!("DisplayOrderAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("displayOrder")
      .registerPath("displayOrder");    
  }
}
mixin(AttributeCalls!("DisplayOrderAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DDisplayOrderAttribute);
    testAttribute(DisplayOrderAttribute);
  }
}