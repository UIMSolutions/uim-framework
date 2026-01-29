/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.farads.micro;

/* Unit of capacitance, equivalent to 10E-6 microfarads

Inheritance
any <- float <- double <- microfarad <- micromicrofarad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.microfarad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.microfarad
means.measurement.prefix.micro */

import uim.entities;

mixin(ShowModule!());

@safe:
class MicroFaradAttribute : FaradAttribute {
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

    this.name("microFarad");
    this.registerPath("microFarad");

    return true;
  }
}
