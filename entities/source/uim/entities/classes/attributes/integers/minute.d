/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.minute;

/* Unit of measure for time in 60 second interval

Inheritance
any <- integer <- minute
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.minutes
has.measurement.fundamentalComponent.second */

import uim.entities;

@safe:
class DMinuteAttribute : DIntegerAttribute {
  mixin(AttributeThis!("MinuteAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("minute")
      .registerPath("minute");
  }    
}
mixin(AttributeCalls!("MinuteAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DMinuteAttribute);
    testAttribute(MinuteAttribute);
  }
}