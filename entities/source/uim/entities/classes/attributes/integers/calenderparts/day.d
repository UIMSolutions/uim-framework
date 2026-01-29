/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.calenderparts.day;

import uim.entities;

@safe:

/* means.calendar
means.calendar.day */
class ayPartAttribute : IntegerCalendarPart {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("daypart");
    this.registerPath("daypart");
  }
}
