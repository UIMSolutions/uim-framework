/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.codes.state;

import uim.entities;

@safe:
class StateCodeAttribute : DIntegerStringAttribute {
  mixin(AttributeThis!("StateCodeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("stateCode");
    this.display("Status Reason");
    this.lookups([
      0: "Active",  
      1: "Inactive"
    ]);
    this.isNullable(true);
    this.registerPath("statecode");
  }
}

