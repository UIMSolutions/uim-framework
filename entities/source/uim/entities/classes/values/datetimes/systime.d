/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.systime;

import uim.entities;

mixin(ShowModule!());

@safe:
class SystimeValue : UIMValue {
  this() {
    super();
  }
  this(IAttribute attribute, Json configSettings = Json(null)) {
    super(attribute, configSettings);
  }

  protected SysTime _value;  
  alias value = UIMValue.value;
  O value(this O)(SysTime newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  SysTime value() {
    return _value; 
  }
  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this
      .isTimestamp(true);
  }

  // Hooks for setting 
  protected void set(SysTime newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this
        .isNull(isNullable ? true : false) 
        .value(SysTime()); }
    else {
      this
        .isNull(false);
        // .value(fromISOExtString(newValue)); 
    }

    alias opEquals = UIMValue.opEquals;
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = SysTime(); 
      this.isNull(isNullable ? true : false); }
    else {
      // _value = newValue.get!string.fromISOExtString;
      this.isNull(false);
    }
  }

  override UIMValue copy() {
    return new SystimeValue(attribute, toJson);
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toISOExtString); }

  override string toString() { 
    if (isNull) return null; 
    return this.value.toISOExtString; }
}
