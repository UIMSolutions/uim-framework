/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.kelvin;

/* Unit of measure for thermodynamic temperature in degrees kelvin

Inheritance
any <- float <- double <- kelvin
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.temperature
means.measurement.units.si.kelvin
has.measurement.fundamentalComponent.kelvin */

import uim.entities;

mixin(ShowModule!());

@safe:
class KelvinAttribute : DoubleAttribute {
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

    this.name("kelvin");
    this.registerPath("kelvin");

    return true;
  }
}