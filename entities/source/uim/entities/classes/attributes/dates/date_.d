/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.dates.date_;

import uim.entities;

@safe:
class DateAttribute : UIMAttribute {
  mixin(AttributeThis!("DateAttribute"));

  // Initialization hook method.  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.date

    this.name("date");
    this.dataFormats(["date"]);
    this.registerPath("date");
  }

  override UIMValue createValue() {
    return DateValue(this);
  }
}
