/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.uuid;

import uim.entities;

@safe:
class DUUIDAttribute : DAttribute {
  mixin(AttributeThis!("UUIDAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("uuid")
      .dataFormats(["uuid"])
      .registerPath("uuid");
  }

  override UIMValue createValue() {
    return UUIUIMValue(this); }
}
mixin(AttributeCalls!("UUIDAttribute"));

///
unittest {
  auto attribute = new DUUIDAttribute;
  assert(attribute.name == "uuid");
  assert(attribute.registerPath == "uuid");

  DAttribute generalAttribute = attribute;
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}