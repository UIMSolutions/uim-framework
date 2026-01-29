module uim.entities.classes.attributes.doubles.celsius;

// Unit of measure for temperature in degrees celsius
/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.temperature
means.measurement.units.si.celsius
has.measurement.fundamentalComponent.kelvin */

import uim.entities;

@safe:
class CelsiusAttribute : DDoubleAttribute {
  mixin(AttributeThis!("CelsiusAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("celsius");
    this.registerPath("celsius");
  }
}