/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.datetimes.time;

import uim.entities;

mixin(ShowModule!());

@safe:
class TimeAttribute : UIMAttribute {
  mixin(AttributeThis!("TimeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.dataFormats(["time"])
      .name("time");
    this.registerPath("time");
      // means.measurement.date
      // means.measurement.time
  }
  override IValue createValue() {
    return TimeValue(this); }
}