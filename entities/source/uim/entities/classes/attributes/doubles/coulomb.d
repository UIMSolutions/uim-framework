module uim.entities.classes.attributes.doubles.coulomb;

import uim.entities;

mixin(ShowModule!());

@safe:

// Unit of measure for electric charge or amount of electricity in coulombs

/* means.measurement.dimension.electricCharge
means.measurement.units.si.coulomb
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere */
class CoulombAttribute : DoubleAttribute {
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

    this.name("coulomb");
    this.registerPath("coulomb");

    return true;
  }
}