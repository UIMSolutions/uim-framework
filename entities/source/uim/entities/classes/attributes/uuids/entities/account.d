/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.account;

import uim.entities;

mixin(ShowModule!());

@safe:
class AccountIdAttribute : EntityIdAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.name("accountId");
    this.registerPath("accountId");
    return true;
  }
}
///
unittest {
  auto attribute = new AccountIdAttribute;
  assert(attribute.name == "accountId");
  assert(attribute.registerPath == "accountId");

  IAttribute generalAttribute = attribute;
  assert(cast(EntityIdAttribute)generalAttribute);
  assert(cast(UUIDAttribute)generalAttribute);
  assert(!cast(IntegerAttribute)generalAttribute);

  IValue value = attribute.createValue();
  assert(cast(UUIDValue)value);
}
