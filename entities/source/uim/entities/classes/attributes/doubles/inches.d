/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.inches;

/* Inheritance
any <- float <- double <- inches
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.distance.inches */

import uim.entities;

@safe:
class DInchesAttribute : DDoubleAttribute {
  mixin(AttributeThis!("InchesAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("inches")
    this.registerPath("inches");
  }
}
mixin(AttributeCalls!("InchesAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}