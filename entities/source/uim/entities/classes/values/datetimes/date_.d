/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.date_;

import uim.entities;
@safe:

class DateValue : UIMValue {
  this() {
    super();
  }
  this(IAttribute attribute, Json configSettings = Json(null)) {
    super(attribute, configSettings);
  }

  protected Date _value;  
  alias value = UIMValue.value;
  O value(this O)(Date newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  Date value() {
    return _value; 
  }
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isDate(true);
  }

  void set(Date newValue) {
    _value = newValue;
  }
  override void set(string newValue) {
    _value = Date.fromISOExtString(newValue);
  }
  override void set(Json newValue) {
    if (newValue.isEmpty) { 
      this
        .value(Date()) 
        .isNull(isNullable ? true : false); }
    else {
      this
        .value(newValue.get!string)
        .isNull(false);
    }
  }

  override UIMValue copy() {
    return DateValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null);
    auto json = Json.emptyObject;
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}