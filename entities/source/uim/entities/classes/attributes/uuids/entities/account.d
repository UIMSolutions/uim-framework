/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.account;

import uim.entities;

@safe:
class AccountIDAttribute : EntityIDAttribute {
  mixin(AttributeThis!("AccountIDAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("accountId");
    this.registerPath("accountId");
  }  
}
///
unittest {
  auto attribute = new AccountIDAttribute;
  assert(attribute.name == "accountId");
  assert(attribute.registerPath == "accountId");

  IAttribute generalAttribute = attribute;
  assert(cast(EntityIDAttribute)generalAttribute);
  assert(cast(UUIDAttribute)generalAttribute);
  assert(!cast(IntegerAttribute)generalAttribute);
  
  IValue value = attribute.createValue();
  assert(cast(UUIDValue)value);
}