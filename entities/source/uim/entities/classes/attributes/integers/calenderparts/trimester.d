/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.calenderparts.trimester;

/* any <- integer <- integerCalendarPart <- trimester
Traits
is.dataFormat.integer
means.calendar
means.calendar.trimester */

import uim.entities;

@safe:
class DTrimesterAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("TrimesterAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("trimester");
    this.registerPath("trimester");
  }
}
mixin(AttributeCalls!("TrimesterAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DTrimesterAttribute);
    testAttribute(TrimesterAttribute);
  }
}