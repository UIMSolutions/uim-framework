/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.entities.entity;

import uim.entities;
@safe:

/* class UIMEntityAttribute : UIMAttribute {
  mixin(AttributeThis!("EntityAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.dataFormats(["time"]);
    // means.measurement.date
    // means.measurement.time
  }

  override IValue createValue() {
    return EntityValue(this); }
}


version(test_uim_models) { unittest {
    testAttribute(new UIMEntityAttribute);
    testAttribute(EntityAttribute);
  }
} */