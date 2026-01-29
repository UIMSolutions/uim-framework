/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.entity;

import uim.entities;

mixin(ShowModule!());

@safe:
class UIMEntityValue : UIMValue {
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
      .isNull(false)
      .isEntity(true);
  }

  protected UIMEntity _value;
  alias value = UIMValue.value;
  O value(this O)(UIMEntity newValue) {
    _value = newValue;
    return cast(O)this; 
  }
  UIMEntity value() {
    return _value; 
  }
  version(test_uim_eUIMEntityntities) {
    unittest {    
      auto entity = SystemUser; // some kind of entity
      assert(EntityValue.value(entity).value.id == entity.id);
  }}

  protected void set(UIMEntity newValue) {
    if (newValue is null) { 
      this.isNull(isNullable ? true : false); 
      _value = null; }
    else {
      this.isNull(false);
      _value = newValue; 
    }
  }  

  override protected void set(string newValue) {
    /// TODO
  }  

  override protected void set(Json newValue) {
    /// TODO
  }

/*   bool opEquals(UIMEntity otherValue) {
    return (this.value.id == otherValue.id);
  }

  int opCmp(UIMEntity otherValue) {
    /// TODO
    return 1;
  }  */

  alias opEquals = UIMValue.opEquals;

  override UIMValue copy() {
    return EntityValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return this.value.toJson; 
  }

  // EntityValue converts to a JsonSTtring
  override string toString() { 
    if (isNull) return null; 
    return toJson.toString; 
  }

  override void fromString(string newValue) { 
    /// TODO this.value(newValue);
  }
}
