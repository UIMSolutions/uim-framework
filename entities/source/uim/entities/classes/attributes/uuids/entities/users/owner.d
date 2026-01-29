/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.users.owner;

import uim.entities;

@safe:
class DOwnerIUIMAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("OwnerIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("ownerId");
    this.registerPath("ownerId");
  }  
}
mixin(AttributeCalls!("OwnerIdAttribute"));

///
unittest {
  auto attribute = new DOwnerIdAttribute;
  assert(attribute.name == "ownerId");
  assert(attribute.registerPath == "ownerId");

  UIMAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}