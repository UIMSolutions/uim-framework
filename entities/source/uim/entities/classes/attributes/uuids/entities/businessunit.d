/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.businessunit;

import uim.entities;
@safe:

// A unique identifier for entity instances

class DBusinessUnitIUIMAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("BusinessUnitIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("businessUnitId")
    this.registerPath("businessUnitId");
  }  
}
mixin(AttributeCalls!("BusinessUnitIdAttribute"));

///
unittest {
  auto attribute = new DBusinessUnitIdAttribute;
  assert(attribute.name == "businessUnitId");
  assert(attribute.registerPath == "businessUnitId");

  UIMAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}