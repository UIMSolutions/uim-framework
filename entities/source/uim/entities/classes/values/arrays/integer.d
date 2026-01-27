/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.arrays.integer;

import uim.entities;

@safe:
class DIntegerArrayValue : DArrayValue {
  mixin(ValueThis!("IntegerArrayValue", "int[]"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isInteger(true);
  }

  protected int[] _value;
  alias value = UIMValue.value;
  void set(int[] newValue) {
    _value = newValue;
  }
  O value(this O)(int[] newValue) {
    this.set(newValue);
    return cast(O)this; 
  }
  int[] value() {
    return _value; 
  }

  alias opEquals = UIMValue.opEquals;
  
  override UIMValue copy() {
    return IntegerArrayValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }
}
mixin(ValueCalls!("IntegerArrayValue"));  
