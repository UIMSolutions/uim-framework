/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.datetimes.birthdate;

import uim.entities;

@safe:
class DBirthDateAttribute : DDatetimeAttribute {
  mixin(AttributeThis!("BirthDateAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    /* is.dataFormat.date
    means.measurement.date
    is.dataFormat.time
    means.measurement.time
    means.demographic.birthDate
 */
    this
      .dataFormats(["time"])
      .name("birthdate")
      .registerPath("birthdate");

  }
  override DValue createValue() {
    return DatetimeValue(this); }
}
mixin(AttributeCalls!"BirthDateAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DBirthDateAttribute);
    testAttribute(BirthDateAttribute);
  }
}