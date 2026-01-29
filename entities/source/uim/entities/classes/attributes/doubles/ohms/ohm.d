/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.ohms.ohm;

/* Description

Unit of measure for electrical resistance, impedance, reactance in ohms

Inheritance
any <- float <- double <- ohm
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.resistance
means.measurement.units.si.ohm
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere */

import uim.entities;

mixin(ShowModule!());

@safe:
class OhmAttribute : DoubleAttribute {
  mixin(AttributeThis!("OhmAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("ohm");
    this.registerPath("ohm");
  }
}

