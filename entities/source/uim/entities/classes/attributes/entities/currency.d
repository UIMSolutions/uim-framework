/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.entities.currency;

import uim.entities;
@safe:

// A unique identifier for entity instances

/* class DCurrencyAttribute : UIMEntityAttribute {
  mixin(AttributeThis!("CurrencyAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("currency");
    this.registerPath("currency");
  }  
}
mixin(AttributeCalls!("CurrencyAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DCurrencyAttribute);
    testAttribute(CurrencyAttribute);
  }
} */