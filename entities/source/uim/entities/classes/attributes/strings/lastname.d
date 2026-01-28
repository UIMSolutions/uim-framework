/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.lastname;

import uim.entities;
@safe:

// means.iUIMEntity.person.lastName
class DLastNameAttribute : DStringAttribute {
  mixin(AttributeThis!("LastNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("lastname");
    this.registerPath("lastname");
  }
}
mixin(AttributeCalls!("LastNameAttribute"));

///
unittest {
  auto attribute = new DLastNameAttribute;
  assert(attribute.name == "lastname");
  assert(attribute.registerPath == "lastname");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}