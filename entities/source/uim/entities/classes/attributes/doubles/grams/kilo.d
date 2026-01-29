/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.grams.kilo;

/* Unit of measure for mass in kilogram

Inheritance
any <- float <- double <- kilogram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.kilogram
has.measurement.fundamentalComponent.kilogram */

import uim.entities;

mixin(ShowModule!());

@safe:
class KilogramAttribute : GramAttribute {
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

    this.name("kilogram");
    this.registerPath("kilogram");

    return true;
  }
}

