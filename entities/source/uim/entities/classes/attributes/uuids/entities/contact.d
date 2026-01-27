/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.contact;

import uim.entities;

@safe:
class DContactIdAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("ContactIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("contactId")
      .registerPath("contactId");
  }  
}
mixin(AttributeCalls!("ContactIdAttribute"));

///
unittest {
  auto attribute = new DContactIdAttribute;
  assert(attribute.name == "contactId");
  assert(attribute.registerPath == "contactId");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}