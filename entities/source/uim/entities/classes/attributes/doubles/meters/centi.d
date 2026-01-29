/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.meters.centi;

// Unit of measure for length in 10E-2 meters
/* any <- float <- double <- meter <- centimeter
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.length
means.measurement.units.si.meter
has.measurement.fundamentalComponent.meter
means.measurement.prefix.centi */

import uim.entities;

mixin(ShowModule!());

@safe:
class CentimeterAttribute : MeterAttribute {
  mixin(AttributeThis!("CentimeterAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("centimeter");
    this.registerPath("centimeter");
  }
}

