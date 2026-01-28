/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.slas.invoked;

import uim.entities;

@safe:
class DSLAInvokedIUIMAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("SLAInvokedIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("slainvokedid");
    this.registerPath("slaInvokedId");
  }  
}
mixin(AttributeCalls!("SLAInvokedIdAttribute"));

///
unittest {
  auto attribute = new DSLAInvokedIdAttribute;
  assert(attribute.name == "slainvokedid");
  assert(attribute.registerPath == "slaInvokedId");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DSLAInvokedIdAttribute)generalAttribute);
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}