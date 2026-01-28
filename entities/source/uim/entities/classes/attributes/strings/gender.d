/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.gender;

import uim.entities;
@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.demographic.gender */
class DGenderAttribute : DStringAttribute {
  mixin(AttributeThis!("GenderAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("gender")
    this.registerPath("gender");
  }
}
mixin(AttributeCalls!("GenderAttribute"));

///
unittest {
  auto attribute = new DGenderAttribute;
  assert(attribute.name == "gender");
  assert(attribute.registerPath == "gender");
}