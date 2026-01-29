module uim.entities.classes.attributes.doubles.candela;

// candela
// Unit of measure for luminous intensity in candelas

import uim.entities;

mixin(ShowModule!());

@safe:
class CandelaAttribute : DoubleAttribute {  
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

/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.luminousIntensity
means.measurement.units.si.candela
has.measurement.fundamentalComponent.candela */

    this.name("candela");
    this.registerPath("candela");

    return true;
  }
}
