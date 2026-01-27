/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.dates.datetimes.datetimeoffset;

import uim.entities;

@safe:
class DDatetimeOffsetAttribute : DDatetimeAttribute {
  mixin(AttributeThis!("DatetimeOffsetAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .addDataFormats(["timeOffset"])
      .name("datetimeOffset")
      .registerPath("datetimeOffset");
        /* means.measurement.date
        means.measurement.time
        is.dataFormat.timeOffset */
  }
}
mixin(AttributeCalls!"DatetimeOffsetAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DDatetimeOffsetAttribute);
    testAttribute(DatetimeOffsetAttribute);
  }
}