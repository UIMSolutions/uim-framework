/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.datetimes.birthdate;

import uim.entities;

mixin(ShowModule!());

@safe:
class BirthDateAttribute : DatetimeAttribute {
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
    this.dataFormats(["time"])
      .name("birthdate");
    this.registerPath("birthdate");

  }
  override IValue createValue() {
    return DatetimeValue(this); }
}