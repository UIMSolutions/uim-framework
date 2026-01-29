/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.mole;

/* Unit of measure for amount in moles

Inheritance
any <- float <- double <- mole
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.amount
means.measurement.units.si.mole
has.measurement.fundamentalComponent.mole */

import uim.entities;

mixin(ShowModule!());

@safe:
class MoleAttribute : DoubleAttribute {
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

    this.name("mole");
    this.registerPath("mole");

    return true;
  }
}