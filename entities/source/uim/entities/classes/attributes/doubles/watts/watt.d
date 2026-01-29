/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.watts.watt;

/* Unit of measure for power or radiant flux in watts

Inheritance
any <- float <- double <- watt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.entities;

@safe:
class WattAttribute : DDoubleAttribute {
  mixin(AttributeThis!("WattAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("watt");
    this.registerPath("watt");
  }
}
mixin(AttributeCalls!("WattAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}