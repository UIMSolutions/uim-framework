/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.currency;

import uim.entities;
@safe:

// A unique identifier for entity instances

class CurrencyIUIMAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("CurrencyIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("currencyId");
    this.registerPath("currencyId");
  }  
}