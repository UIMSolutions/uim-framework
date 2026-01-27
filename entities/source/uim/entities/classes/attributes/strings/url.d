/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.url;

import uim.entities;

@safe:
class DUrlAttribute : DStringAttribute {
  mixin(AttributeThis!("UrlAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("url")
      .registerPath("url");
  }
}
mixin(AttributeCalls!("UrlAttribute"));

///
unittest {
  auto attribute = new DUrlAttribute;
  assert(attribute.name == "url");
  assert(attribute.registerPath == "url");

  DAttribute generalAttribute = attribute;
  assert(cast(DUrlAttribute)generalAttribute);
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}