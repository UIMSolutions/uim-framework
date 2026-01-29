/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.codes.status;

import uim.entities;

mixin(ShowModule!());

@safe:
class StatusCodeAttribute : IntegerStringAttribute {
  mixin(AttributeThis!("StatusCodeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("statusCode");
    this.display("Status Reason");
    this.lookups([
        0: "Active",
        1: "Inactive"
      ]);
    this.isNullable(true);
    this.registerPath("statuscode");
  }
}
