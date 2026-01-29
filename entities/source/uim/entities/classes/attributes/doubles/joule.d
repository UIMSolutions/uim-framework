/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.joule;

/* Unit of measure for energy, work or heat in joules

Inheritance
any <- float <- double <- joule
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.energy
means.measurement.units.si.joule
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second */

import uim.entities;

mixin(ShowModule!());

@safe:
class JouleAttribute : DoubleAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("joule");
    this.registerPath("joule");
  }
}