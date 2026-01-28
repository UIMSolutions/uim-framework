/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.users.createdonbehalfby;

import uim.entities;

@safe:
class DCreatedOnBehalfByAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("CreatedOnBehalfByAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("createdOnBehalfBy")
    this.registerPath("createdOnBehalfBy");
  }  
}
mixin(AttributeCalls!("CreatedOnBehalfByAttribute"));

///
unittest {
  auto attribute = new DCreatedOnBehalfByAttribute;
  assert(attribute.name == "createdOnBehalfBy");
  assert(attribute.registerPath == "createdOnBehalfBy");

  UIMAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}