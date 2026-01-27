/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.county;

import uim.entities;
@safe:

// means.location.county
class DCountyAttribute : DStringAttribute {
  mixin(AttributeThis!("CountyAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("county")
      .registerPath("county");
  }
}
mixin(AttributeCalls!("CountyAttribute"));

///
unittest {
  auto attribute = new DCountyAttribute;
  assert(attribute.name == "county");
  assert(attribute.registerPath == "county");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}