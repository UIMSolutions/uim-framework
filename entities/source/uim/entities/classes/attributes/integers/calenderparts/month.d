/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.calenderparts.month;

/* any <- integer <- integerCalendarPart <- month
Traits
is.dataFormat.integer
means.calendar
means.calendar.month */

import uim.entities;
@safe:

/* means.calendar
means.calendar.day */
class DMonthpartAttribute : DIntegerCalendarPart {
  mixin(AttributeThis!("MonthpartAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("monthpart");
    this.registerPath("monthpart");
  }
}
mixin(AttributeCalls!("MonthpartAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DMonthpartAttribute);
    testAttribute(MonthpartAttribute);
  }
}