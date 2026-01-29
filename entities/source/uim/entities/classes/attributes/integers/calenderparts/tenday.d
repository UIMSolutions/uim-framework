/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.calenderparts.tenday;

/* any <- integer <- integerCalendarPart <- tenday
Traits
is.dataFormat.integer
means.calendar
means.calendar.tenday */

import uim.entities;

@safe:
class TendayAttribute : IntegerCalendarPart {
  mixin(AttributeThis!("TendayAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("tenday");
    this.registerPath("tenday");
  }
}