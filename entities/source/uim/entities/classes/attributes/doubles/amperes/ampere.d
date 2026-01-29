/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.doubles.amperes.ampere;

// Unit of measure for electric current in amperes
/** 
 * is.dataFormat.floatingPoint
is.dataFormat.big
means.measurement.dimension.electricCurrent
means.measurement.units.si.ampere
has.measurement.fundamentalComponent.ampere
 */

import uim.entities;

@safe:
class AmpereAttribute : DDoubleAttribute {
  mixin(AttributeThis!("AmpereAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("ampere");
    this.registerPath("ampere");
  }
}
mixin(AttributeCalls!("AmpereAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}
