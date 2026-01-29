/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.hertzes.kilo;

/* Unit of frequency equivalent to 10E3 hertz

is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.frequency
means.measurement.units.si.hertz
has.measurement.fundamentalComponent.second
means.measurement.prefix.kilo */

import uim.entities;

@safe:
class KiloHertzAttribute : DHertzAttribute {
  mixin(AttributeThis!("KiloHertzAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("kilohertz");
    this.registerPath("kilohertz");
  }
}

