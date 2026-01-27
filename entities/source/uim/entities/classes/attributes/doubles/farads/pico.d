/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.farads.pico;

/* Unit of capacitance, equivalent to 10E-12 farads

Inheritance
any <- float <- double <- farad <- picofarad
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.capacitance
means.measurement.units.si.farad
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.pico */

import uim.entities;

@safe:
class DPicoFaradAttribute : DFaradAttribute {
  mixin(AttributeThis!("PicoFaradAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("picoFarad")
      .registerPath("picoFarad");
  }
}
mixin(AttributeCalls!("PicoFaradAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}