/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.day;

import uim.entities;
@safe:

  /* Unit of measure for time in 'one earth rotation' interval
  is.dataFormat.integer
  means.measurement.dimension.time
  means.measurement.duration.days
  has.measurement.fundamentalComponent.second */
class DDayAttribute : DIntegerAttribute {
  mixin(AttributeThis!("DayAttribute"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("day")
      .registerPath("day");    
  }
}
mixin(AttributeCalls!("DayAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DDayAttribute);
    testAttribute(DayAttribute);
  }
}