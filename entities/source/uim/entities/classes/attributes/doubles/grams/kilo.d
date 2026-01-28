/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.grams.kilo;

/* Unit of measure for mass in kilogram

Inheritance
any <- float <- double <- kilogram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.kilogram
has.measurement.fundamentalComponent.kilogram */

import uim.entities;

@safe:
class DKilogramAttribute : DGramAttribute {
  mixin(AttributeThis!("KilogramAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("kilogram");
    this.registerPath("kilogram");
  }
}
mixin(AttributeCalls!("KilogramAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}