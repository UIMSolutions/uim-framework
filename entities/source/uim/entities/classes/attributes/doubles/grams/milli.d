/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.grams.milli;

/* Unit of measure for mass in milligrams

Inheritance
any <- float <- double <- gram <- milligram
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.mass
means.measurement.units.si.gram
has.measurement.fundamentalComponent.kilogram
means.measurement.prefix.milli */

import uim.entities;

@safe:
class KilogramAttribute : GramAttribute {
  mixin(AttributeThis!("KilogramAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("kilogram");
    this.registerPath("kilogram");
  }
}