/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.grams.gram;

/* Unit of measure for mass in grams

Inheritance
any <- float <- double <- gram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.gram
has.measurement.fundamentalComponent.gram */

import uim.entities;

mixin(ShowModule!());

@safe:
class GramAttribute : DoubleAttribute {
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

    this.name("gram");
    this.registerPath("gram");

    return true;
  }
}

