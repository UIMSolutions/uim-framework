/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.codes.customersize;

import uim.entities;

@safe:
class DCustomerSizeCodeAttribute : DIntegerStringAttribute {
  mixin(AttributeThis!("CustomerSizeCodeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("customerSizeCode")
      .display("Customer Size")
      .lookups([
        0: "0-100 (small)",  
        1: "100-1000 (middle)",
        2: "1000-10000 (large)"
      ])
      .isNullable(true)
      .registerPath("customerSizeCode");
  }
}
mixin(AttributeCalls!("CustomerSizeCodeAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}