module uim.entities.classes.attributes.doubles.coulomb;

import uim.entities;
@safe:

// Unit of measure for electric charge or amount of electricity in coulombs

/* means.measurement.dimension.electricCharge
means.measurement.units.si.coulomb
has.measurement.fundamentalComponent.second
has.measurement.fundamentalComponent.ampere */
class DCoulombAttribute : DDoubleAttribute {
  mixin(AttributeThis!("CoulombAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("coulomb");
    this.registerPath("coulomb");
  }
}
mixin(AttributeCalls!("CoulombAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}