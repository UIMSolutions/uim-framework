/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.governmentid;

import uim.entities;
@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.governmentID */
class DGovernmentIUIMAttribute : DStringAttribute {
  mixin(AttributeThis!("GovernmentIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("governmentId")
      .registerPath("governmentId");
  }
}
mixin(AttributeCalls!("GovernmentIdAttribute"));

///
unittest {
  assert(GovernmentIdAttribute.name == "governmentId");
  assert(GovernmentIdAttribute.registerPath == "governmentId");
}