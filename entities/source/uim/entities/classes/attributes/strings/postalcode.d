/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.postalcode;

/* Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.postalCode */

import uim.entities;

@safe:
class PostalCodeAttribute : DStringAttribute {
  mixin(AttributeThis!("PostalCodeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("postalcode");
    this.registerPath("postalcode");
  }
}
mixin(AttributeCalls!("PostalCodeAttribute"));

///
unittest {
  auto attribute = new DPostalCodeAttribute;
  assert(attribute.name == "postalcode");
  assert(attribute.registerPath == "postalcode");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}