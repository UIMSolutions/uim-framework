/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.datetime_;

import uim.entities;

@safe:
class atetimeValue : UIMValue {
  this() {
    super;
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  protected DateTime _value;  
  alias value = UIMValue.value;
  O value(this O)(DateTime newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  DateTime value() {
    return _value; 
  }
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isDatetime(true);
  }

  // Hooks for setting 
  protected void set(DateTime newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      this.value(DateTime()); }
    else {
      this.isNull(false);
      this.value(DateTime.fromISOExtString(newValue)); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = DateTime(); 
      this.isNull(isNullable ? true : false); }
    else {
      this
        .value(newValue.get!string)
        .isNull(false);
    }
  }

  override UIMValue copy() {
    return DatetimeValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}