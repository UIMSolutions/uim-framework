/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.scalars.double_;

import uim.entities;

mixin(ShowModule!());

@safe:
class oubleValue : UIMValue {
  this() {
    super();
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this
      .isDouble(true);
  }

  protected double _value;  
  alias value = UIMValue.value;
  O value(this O)(double newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  double value() {
    return _value; 
  }

  // Hooks for setting 
  protected void set(double newValue) {
    _value = newValue; 
  }  

  override protected void set(string newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      _value = 0; }
    else {
      this.isNull(false);
      _value = to!double(newValue); 
    }
  }  

  override protected void set(Json newValue) {
    if (newValue.isEmpty) { 
      _value = 0; 
      this.isNull(isNullable ? true : false); }
    else {
      _value = newValue.get!double;
      this.isNull(false);
    }
  }

  alias opEquals = Object.opEquals;
  alias opEquals = UIMValue.opEquals;
  bool opEquals(double aValue) {
    return (_value == aValue);
  }

  double opCall() {
    return _value; 
  }

  O opCall(this O)(double newValue) { 
    _value = newValue;
    return cast(O)this; }
  version(test_uim_models) { unittest {    
      auto value = DoubleValue;
      value(100);
    }
  }  

  override UIMValue copy() {
    return DoubleValue(attribute, toJson);
  }

  double toDouble() { 
    if (isNull) return 0; 
    return _value; }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(_value); }

  override string toString() { 
    if (isNull) return "0"; 
    return to!string(_value); }
}