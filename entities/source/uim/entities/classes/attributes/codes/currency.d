/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.codes.currency;

import uim.entities;
@safe:

// is.dataFormat.character
// is.dataFormat.big
// is.dataFormat.array
// means.measurement.currencyCode
// Value is a ISO 4217 currency code
class CurrencyCodeAttribute : StringStringAttribute {
  mixin(AttributeThis!("CurrencyCodeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("currencyCode");
    this.registerPath("currencyCode");
  }
}

