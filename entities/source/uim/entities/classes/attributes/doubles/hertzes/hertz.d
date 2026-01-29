/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.hertzes.hertz;

/* Unit of measure for frequency in hertz

Inheritance
any <- float <- double <- hertz
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second */

// hertz
// Unit of measure for luminous intensity in hertzs

import uim.entities;

mixin(ShowModule!());

@safe:
class HertzAttribute : DoubleAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second */

    this.name("hertz");
    this.registerPath("hertz");
  }
}

