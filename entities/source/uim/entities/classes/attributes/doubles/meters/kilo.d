/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.meters.kilo;

/* Unit of measure for length in 10E3 meters

is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter
means.measurement.prefix.kilo */

import uim.entities;

mixin(ShowModule!());

@safe:
class KilometerAttribute : MeterAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.name("kilometer");
    this.registerPath("kilometer");

    return true;
  }
}

