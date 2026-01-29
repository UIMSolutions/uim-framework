/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.decimals.fixed;

import uim.entities;

mixin(ShowModule!());

@safe:

// The 64 bit fixed (4) scale numbers used by PBI
class FixedDecimalAttribute : DecimalAttribute {
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

    this.name("fixedDecimal");
    this.registerPath("fixedDecimal");

    return true;
  }
}


version(test_uim_models) { unittest {
    testAttribute(new DFixedDecimalAttribute);
    testAttribute(FixedDecimalAttribute);
  }
}