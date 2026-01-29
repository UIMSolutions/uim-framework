/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.chars.char_;

import uim.entities;

@safe:
class CharAttribute : UIMAttribute {
  mixin(AttributeThis!"CharAttribute");

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.dataFormats(["character", "big"])
      .name("char");
    this.registerPath("char");
  }
}
mixin(AttributeCalls!"CharAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DCharAttribute);
    testAttribute(CharAttribute);
  }
}