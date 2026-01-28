/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.timezone;

/* any <- char <- string <- timezone
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.timezone */

import uim.entities;

@safe:
class DTimezoneAttribute : DStringAttribute {
  mixin(AttributeThis!("TimezoneAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("timezone");
    this.registerPath("timezone");
  }
}
mixin(AttributeCalls!("TimezoneAttribute"));

///
unittest {
  auto attribute = new DTimezoneAttribute;
  assert(attribute.name == "timezone");
  assert(attribute.registerPath == "timezone");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}