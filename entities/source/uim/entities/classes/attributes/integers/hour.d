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

mixin(ShowModule!());

@safe:
class HourAttribute : IntegerAttribute {

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this.name("hour");
    this.registerPath("hour");

    return true;
  }    
}