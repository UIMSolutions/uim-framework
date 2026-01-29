/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.volts.kilo;

/* Unit of power, equivalent to 10E3 volts

Inheritance
any <- float <- double <- volt <- kilovolt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electromotiveForce
means.measurement.units.si.volt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.kilo */

import uim.entities;

mixin(ShowModule!());

@safe:
class KiloVoltAttribute : VoltAttribute {
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

    this.name("kilovolt");
    this.registerPath("kilovolt");

    return true;
  }
}

