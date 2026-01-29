module uim.entities.classes.attributes.doubles.volts.mega;

/* Unit of power, equivalent to 10E6 volts

Inheritance
any <- float <- double <- volt <- megavolt
Traits
is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electromotiveForce
means.measurement.units.si.volt
has.measurement.fundamentalComponent.kilogram
has.measurement.fundamentalComponent.meter
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere
means.measurement.prefix.mega */

import uim.entities;

mixin(ShowModule!());

@safe:
class MegaVoltAttribute : VoltAttribute {
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

    this.name("megavolt");
    this.registerPath("megavolt");

    return true;
  }
}

