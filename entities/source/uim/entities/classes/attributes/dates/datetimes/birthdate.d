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

    /* is.dataFormat.date
    means.measurement.date
    is.dataFormat.time
    means.measurement.time
    means.demographic.birthDate
 */
    this.dataFormats(["time"]);
    this.name("birthdate");
    this.registerPath("birthdate");

    return true;
  }
  override IValue createValue() {
    return new DatetimeValue(this); }
}