/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.link;

import uim.entities;

@safe:
class DLinkAttribute : DStringAttribute {
  mixin(AttributeThis!("LinkAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("link");
    this.registerPath("link");
  }
}
mixin(AttributeCalls!("LinkAttribute"));

///
unittest {
  auto attribute = new DLinkAttribute;
  assert(attribute.name == "link");
  assert(attribute.registerPath == "link");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}