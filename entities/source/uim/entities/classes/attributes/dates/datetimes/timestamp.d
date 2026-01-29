/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.datetimes.timestamp;

import uim.entities;

@safe:
class TimestampAttribute : DLongAttribute {
  mixin(AttributeThis!("TimestampAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.dataFormats(["timestamp"])
      .name("timestamp");
    this.registerPath("timestamp");
  }
  override UIMValue createValue() {
    return TimestampValue(this); }
}