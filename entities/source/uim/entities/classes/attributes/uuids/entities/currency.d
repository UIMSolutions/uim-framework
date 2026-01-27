/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.currency;

import uim.entities;
@safe:

// A unique identifier for entity instances

class DCurrencyIdAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("CurrencyIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("currencyId")
      .registerPath("currencyId");
  }  
}
mixin(AttributeCalls!("CurrencyIdAttribute"));

///
unittest {
  auto attribute = new DCurrencyIdAttribute;
  assert(attribute.name == "currencyId");
  assert(attribute.registerPath == "currencyId");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}