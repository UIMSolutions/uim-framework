/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.amperes.milli;

/* Unit of capacitance, equivalent to 10E-3 amperes

Inheritance
any <- float <- double <- ampere <- milliampere
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electricCurrent
means.measurement.units.si.ampere
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.milli */

import uim.entities;

mixin(ShowModule!());

@safe:
class DMilliAmpereAttribute : AmpereAttribute {
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

    this.name("milliAmpere");
    this.registerPath("milliAmpere");

    return true;
  }
}
