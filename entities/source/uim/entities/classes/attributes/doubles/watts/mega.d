/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.watts.mega;

/* megawatt
Description

Unit of power, equivalent to 10E6 watts

Inheritance
any <- float <- double <- watt <- megawatt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.power
means.measurement.units.si.watt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
means.measurement.prefix.mega */

import uim.entities;

mixin(ShowModule!());

@safe:
class MegaWattAttribute : WattAttribute {
  mixin(AttributeThis!("MegaWattAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("megawatt");
    this.registerPath("megawatt");
  }
}

