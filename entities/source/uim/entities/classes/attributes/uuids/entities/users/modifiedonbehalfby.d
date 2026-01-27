/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.users.modifiedonbehalfby;

import uim.entities;

@safe:
class DModifiedOnBehalfByAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("ModifiedOnBehalfByAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("modifiedOnBehalfBy")
      .registerPath("modifiedOnBehalfBy");
  }  
}
mixin(AttributeCalls!("ModifiedOnBehalfByAttribute"));

///
unittest {
  auto attribute = new DModifiedOnBehalfByAttribute;
  assert(attribute.name == "modifiedOnBehalfBy");
  assert(attribute.registerPath == "modifiedOnBehalfBy");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}