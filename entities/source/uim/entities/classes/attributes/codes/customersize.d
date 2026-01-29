/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.codes.customersize;

import uim.entities;

mixin(ShowModule!());

@safe:
class CustomerSizeCodeAttribute : IntegerStringAttribute {
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

    this.name("customerSizeCode");
    this.display("Customer Size");
    this.lookups([
      0: "0-100 (small)",
      1: "100-1000 (middle)",
      2: "1000-10000 (large)"
    ]);
    this.isNullable(true);
    this.registerPath("customerSizeCode");

    return true;
  }
}
