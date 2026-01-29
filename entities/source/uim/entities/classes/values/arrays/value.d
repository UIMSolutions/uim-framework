/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.arrays.value;

import uim.entities;

mixin(ShowModule!());

@safe:
class UIMValueArrayValue : ArrayValue {
  this() {
    super;
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
      .isString(true);
  }

  protected UIMValue[] _value;
  alias value = UIMValue.value;
  void set(UIMValue[] newValue) {
    _value = newValue;
  }
  O value(this O)(UIMValue[] newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  UIMValue[] value() {
    return _value; 
  }

  alias opEquals = Object.opEquals;
  alias opEquals = UIMValue.opEquals;

  override UIMValue copy() {
    return ValueArrayValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }
}