/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.county;

import uim.entities;

mixin(ShowModule!());

@safe:

// means.location.county
class CountyAttribute : StringAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("county");
    this.registerPath("county");
  }
}