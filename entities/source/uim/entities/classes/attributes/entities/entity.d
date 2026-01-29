/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.entities.entity;

import uim.entities;

mixin(ShowModule!());

@safe:

/* class UIMEntityAttribute : UIMAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


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