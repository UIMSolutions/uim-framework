/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.calenderparts.quarter;

/* any <- integer <- integerCalendarPart <- quarter
Traits
is.dataFormat.integer
means.calendar
means.calendar.quarter */


import uim.entities;

@safe:
class DQuarterAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("QuarterAttribute"));

  // Initialization hook method.
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("quarter")
      .registerPath("quarter");
  }
}
mixin(AttributeCalls!("QuarterAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DQuarterAttribute);
    testAttribute(QuarterAttribute);
  }
}