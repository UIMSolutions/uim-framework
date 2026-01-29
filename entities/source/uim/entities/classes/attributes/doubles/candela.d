module uim.entities.classes.attributes.doubles.candela;

// candela
// Unit of measure for luminous intensity in candelas

import uim.entities;

mixin(ShowModule!());

@safe:
class CandelaAttribute : DoubleAttribute {
  mixin(AttributeThis!("CandelaAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

/* is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.luminousIntensity
means.measurement.units.si.candela
has.measurement.fundamentalComponent.candela */

    this.name("candela");
    this.registerPath("candela");
  }
}
