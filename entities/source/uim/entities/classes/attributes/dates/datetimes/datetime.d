/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.datetimes.datetime;

import uim.entities;

@safe:
class DDatetimeAttribute : DDateAttribute {
  mixin(AttributeThis!("DatetimeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .addDataFormats(["time"])
      .name("datetime")
      .registerPath("datetime");
      // means.measurement.date
      // means.measurement.time
  }
  override UIMValue createValue() {
    return DatetimeValue(this); }
}
mixin(AttributeCalls!"DatetimeAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DDatetimeAttribute);
    testAttribute(DatetimeAttribute);
  }
}