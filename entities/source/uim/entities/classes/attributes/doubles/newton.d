/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.newton;

/* Unit of measure for force or weight in newtons

Inheritance
any <- float <- double <- newton
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.force
means.measurement.units.si.newton
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.entities;

mixin(ShowModule!());

@safe:
class NewtonAttribute : DoubleAttribute {
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

    this.name("newton");
    this.registerPath("newton");

    return true;
  }
}