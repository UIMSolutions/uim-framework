/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.integer;

import uim.entities;

@safe:
class DIntegerAttribute : UIMAttribute {
  mixin(AttributeThis!"IntegerAttribute");

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .addDataFormats(["integer"])
      .name("integer")
    this.registerPath("integer");
  }    
}
mixin(AttributeCalls!"IntegerAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DIntegerAttribute);
    testAttribute(IntegerAttribute);
  }
}