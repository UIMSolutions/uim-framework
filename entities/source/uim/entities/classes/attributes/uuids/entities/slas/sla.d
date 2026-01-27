/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.slas.sla;

import uim.entities;

@safe:
class DSlaIdAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("SlaIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("slaId")
      .registerPath("slaId");
  }  
}
mixin(AttributeCalls!("SlaIdAttribute"));

///
unittest {
  auto attribute = new DSlaIdAttribute;
  assert(attribute.name == "slaId");
  assert(attribute.registerPath == "slaId");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}