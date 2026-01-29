/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.lookup;

import uim.entities;

mixin(ShowModule!());

@safe:
class LookupAttribute : UIMAttribute {
  mixin(AttributeThis!("LookupAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.lookup

    this.name("lookup")
      .dataFormats(["lookup"]);
    this.registerPath("lookup");
  }

/*   override UIMValue createValue() {
    return LookupValue(this); } */
}

