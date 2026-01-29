/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.seconds.second;

/* Unit of measure for time in seconds

Inheritance
any <- float <- double <- second
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.time
means.measurement.units.si.second
has.measurement.fundamentalComponent.second
means.measurement.duration.seconds */

import uim.entities;

mixin(ShowModule!());

@safe:
class SecondAttribute : DoubleAttribute {
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

    this.name("second");
    this.registerPath("second");

    return true;
  }
}
