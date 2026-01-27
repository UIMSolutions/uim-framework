/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.arrays.array;

import uim.entities;

@safe:
class DArrayAttribute : DAttribute {
  mixin(AttributeThis!("ArrayAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("arrayAttribute")
      .addDataFormats(["array"])
      .registerPath("arrayAttribute");
  }
}
mixin(AttributeCalls!"ArrayAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DArrayAttribute);
    testAttribute(ArrayAttribute);
  }
}