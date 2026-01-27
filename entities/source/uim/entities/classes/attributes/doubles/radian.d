/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.radian;

/* Unit of measure for angle in radians

Inheritance
any <- float <- double <- radian
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.angle
means.measurement.units.si.radian
has.measurement.fundamentalComponent */

import uim.entities;

@safe:
class DRadianAttribute : DDoubleAttribute {
  mixin(AttributeThis!("RadianAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("radian")
      .registerPath("radian");
  }
}
mixin(AttributeCalls!("RadianAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}