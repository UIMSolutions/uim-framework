/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.seconds.micro;

/* Unit of measure for time in 10E-6 microseconds

any <- float <- double <- microsecond <- microMicroSecond
 
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.time
means.measurement.units.si.microsecond
has.measurement.fundamentalComponent.microsecond
means.measurement.duration.microseconds
means.measurement.prefix.micro */

import uim.entities;

@safe:
class MicroSecondAttribute : DSecondAttribute {
  mixin(AttributeThis!("MicroSecondAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("microsecond");
    this.registerPath("microsecond");
  }
}
mixin(AttributeCalls!("MicroSecondAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}