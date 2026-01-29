/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.year;

/* Unit of measure for time in 'one solar orbit' interval

Inheritance
any <- integer <- year
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.years
has.measurement.fundamentalComponent.second */

import uim.entities;

@safe:
class YearAttribute : DIntegerAttribute {
  mixin(AttributeThis!("YearAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("year");
    this.registerPath("year");
  }    
}
mixin(AttributeCalls!("YearAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DYearAttribute);
    testAttribute(YearAttribute);
  }
}