/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.codes.state;

import uim.entities;

mixin(ShowModule!());

@safe:
class StateCodeAttribute : IntegerStringAttribute {
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

    this.name("stateCode");
    this.display("Status Reason");
    this.lookups([
      0: "Active",  
      1: "Inactive"
    ]);
    this.isNullable(true);
    this.registerPath("statecode");

    return true;
  }
}

