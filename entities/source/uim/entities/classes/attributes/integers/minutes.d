/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.minutes;

/* any <- integer <- minutes <- minutess
Traits
is.dataFormat.integer
means.measurement.dimension.time
means.measurement.duration.minutes
has.measurement.fundamentalComponent.second */

import uim.entities;

@safe:
class DMinutesAttribute : DIntegerAttribute {
  mixin(AttributeThis!("MinutesAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("minutes");
    this.registerPath("minutes");
  }    
}
mixin(AttributeCalls!("MinutesAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DMinutesAttribute);
    testAttribute(MinutesAttribute);
  }
}