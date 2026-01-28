/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.watts.kilo;

/* Unit of power, equivalent to 10E3 watts

Inheritance
any <- float <- double <- watt <- kilowatt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
means.measurement.prefix.kilo */

import uim.entities;

@safe:
class DKiloWattAttribute : DWattAttribute {
  mixin(AttributeThis!("KiloWattAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("kilowatt");
    this.registerPath("kilowatt");
  }
}
mixin(AttributeCalls!("KiloWattAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}