/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.city;

import uim.entities;
@safe:

// means.location.city
class DCityNameAttribute : DStringAttribute {
  mixin(AttributeThis!("CityNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("cityName")
      .registerPath("cityName");
  }
}
mixin(AttributeCalls!("CityNameAttribute"));

///
unittest {
  auto attribute = new DCityNameAttribute;
  assert(attribute.name == "cityName");
  assert(attribute.registerPath == "cityName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}