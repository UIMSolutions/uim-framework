/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.time_;

import uim.entities;

mixin(ShowModule!());

@safe:
class TimeValue : UIMValue {
  this() {
    super();
  }
  this(IAttribute attribute, Json configSettings = Json(null)) {
    super(attribute, configSettings);
  }

  protected TimeOfDay _value;  
  alias value = UIMValue.value;
  O value(this O)(TimeOfDay newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  TimeOfDay value() {
    return _value; 
  }
  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this
      .isTime(true);
  }

  // Hooks for setting 
  protected void set(TimeOfDay newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this
        .isNull(isNullable ? true : false) 
        .value(TimeOfDay()); }
    else {
      this
        .isNull(false);
        // .value(fromISOExtString(newValue)); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = TimeOfDay(); 
      this.isNull(isNullable ? true : false); }
    else {
      // _value = newValue.get!string.fromISOExtString;
      this.isNull(false);
    }
  }

  alias opEquals = Object.opEquals;
  alias opEquals = UIMValue.opEquals;

  override UIMValue copy() {
    return new TimeValue(attribute, toJson);
  }

  alias opEquals = Object.opEquals;

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}