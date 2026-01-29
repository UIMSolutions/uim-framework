/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.hour;

/* Unit of measure for time in 3600 second interval

means.measurement.dimension.time
means.measurement.duration.hours
has.measurement.fundamentalComponent.second */

import uim.entities;

@safe:
class HourAttribute : IntegerAttribute {
  mixin(AttributeThis!("HourAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("hour");
    this.registerPath("hour");
  }    
}