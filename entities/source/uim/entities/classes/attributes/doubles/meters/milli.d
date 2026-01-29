/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.meters.milli;

import uim.entities;

mixin(ShowModule!());

@safe:

/* Unit of measure for length in 10E-3 meters

Inheritance
any <- float <- double <- meter <- millimeter
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter
means.measurement.prefix.milli */

import uim.entities;

mixin(ShowModule!());

@safe:
class MillimeterAttribute : MeterAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("millimeter");
    this.registerPath("millimeter");
  }
}

