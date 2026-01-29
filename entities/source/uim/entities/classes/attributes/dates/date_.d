/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.dates.date_;

import uim.entities;

mixin(ShowModule!());

@safe:
class DateAttribute : UIMAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }


  // Initialization hook method.  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // means.measurement.date

    this.name("date");
    this.dataFormats(["date"]);
    this.registerPath("date");

    return true;
  }

  override IValue createValue() {
    return new DateValue(this);
  }
}
