/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.longitude;

/* any <- float <- double <- longitude
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.location.longitude */

import uim.entities;

mixin(ShowModule!());

@safe:
class LongitudeAttribute : DoubleAttribute {
  mixin(AttributeThis!("LongitudeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("longitude");
    this.registerPath("longitude");
  }
}