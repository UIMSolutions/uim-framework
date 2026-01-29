/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.decimals.currencies.currency;

import uim.entities;

mixin(ShowModule!());

@safe:
class CurrencyAttribute : DecimalAttribute {
  mixin(AttributeThis!("CurrencyAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    /* is.dataFormat.numeric.shaped
    means.measurement.currency */
  }
}