module uim.entities.classes.attributes.doubles.celsius;

// Unit of measure for temperature in degrees celsius
/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.temperature
means.measurement.units.si.celsius
has.measurement.fundamentalComponent.kelvin */

import uim.entities;

mixin(ShowModule!());

@safe:
class CelsiusAttribute : DoubleAttribute {
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

    this.name("celsius");
    this.registerPath("celsius");

    return true;
  }
}