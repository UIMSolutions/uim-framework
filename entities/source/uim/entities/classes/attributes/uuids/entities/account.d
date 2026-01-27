/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.account;

import uim.entities;

@safe:
class DAccountIdAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("AccountIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("accountId")
      .registerPath("accountId");
  }  
}
mixin(AttributeCalls!("AccountIdAttribute"));

///
unittest {
  auto attribute = new DAccountIdAttribute;
  assert(attribute.name == "accountId");
  assert(attribute.registerPath == "accountId");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}