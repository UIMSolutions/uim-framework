/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.watts.milli;

/* Unit of power, equivalent to 10E-3 watts

Inheritance
any <- float <- double <- watt <- milliwatt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
means.measurement.prefix.milli */

import uim.entities;

mixin(ShowModule!());

@safe:
class MilliWattAttribute : WattAttribute {
  mixin(AttributeThis!("MilliWattAttribute"));

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.name("milliwatt");
    this.registerPath("milliwatt");

    return true;
  }
}

