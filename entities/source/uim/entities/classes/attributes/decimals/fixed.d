/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.decimals.fixed;

import uim.entities;
@safe:

// The 64 bit fixed (4) scale numbers used by PBI
class DFixedDecimalAttribute : DDecimalAttribute {
  mixin(AttributeThis!("FixedDecimalAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("fixedDecimal");
    this.registerPath("fixedDecimal");
  }
}
mixin(AttributeCalls!"FixedDecimalAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DFixedDecimalAttribute);
    testAttribute(FixedDecimalAttribute);
  }
}