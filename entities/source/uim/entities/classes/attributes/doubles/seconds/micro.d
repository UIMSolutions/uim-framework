/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.seconds.micro;

/* Unit of measure for time in 10E-6 microseconds

any <- float <- double <- microsecond <- microMicroSecond
 
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.time
means.measurement.units.si.microsecond
has.measurement.fundamentalComponent.microsecond
means.measurement.duration.microseconds
means.measurement.prefix.micro */

import uim.entities;

mixin(ShowModule!());

@safe:
class MicroSecondAttribute : SecondAttribute {
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

    this.name("microsecond");
    this.registerPath("microsecond");

    return true;
  }
}

