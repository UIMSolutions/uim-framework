/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.volts.volt;

/* Unit of measure for voltage, EMF, electrical potantial difference in volts

Inheritance
any <- float <- double <- volt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electromotiveForce
means.measurement.units.si.volt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.volt
has.measurement.fundamentalComponent.ampere */

import uim.entities;

@safe:
class VoltAttribute : DDoubleAttribute {
  mixin(AttributeThis!("VoltAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("volt");
    this.registerPath("volt");
  }
}

