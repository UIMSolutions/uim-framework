/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.radian;

/* Unit of measure for angle in radians

Inheritance
any <- float <- double <- radian
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.angle
means.measurement.units.si.radian
has.measurement.fundamentalComponent */

import uim.entities;

mixin(ShowModule!());

@safe:
class RadianAttribute : DoubleAttribute {
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

    this.name("radian");
    this.registerPath("radian");

    return true;
  }
}