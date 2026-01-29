/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.decimals.currencies.base;

import uim.entities;

@safe:
class BaseCurrencyAttribute : DCurrencyAttribute {
  mixin(AttributeThis!("BaseCurrencyAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    /* 
Value is expressed in the base currency units for the system

Inheritance
any <- decimal <- currency <- baseCurrency
Traits
is.dataFormat.numeric.shaped
means.measurement.currency
means.measurement.currency
    */
    this.name("baseCurrency");
    this.registerPath("baseCurrency");
  }
}
  