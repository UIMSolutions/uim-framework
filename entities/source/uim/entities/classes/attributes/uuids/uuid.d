/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.uuid;

import uim.entities;

@safe:
class UUIDAttribute : UIMAttribute {
  mixin(AttributeThis!("UUIDAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("uuid")
      .dataFormats(["uuid"]);
    this.registerPath("uuid");
  }

  override UIMValue createValue() {
    return UUIDValue(this); }
}