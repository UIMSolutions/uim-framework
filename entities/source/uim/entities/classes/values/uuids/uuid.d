/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.uuids.uuid;

import uim.entities;

@safe:
class DUUIDValue : UIMValue {
  mixin(ValueThis!("UUIDValue", "UUID"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isUUID(true);
  }

  protected UUID _value;  
  alias value = UIMValue.value;
  UUID value() {
    return _value; 
  }
  O value(this O)(UUID newValue) {
    this.set(newValue);
    return cast(O)this; 
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      if (!isNullable) return;

      this
        .isNull(true)
        .value(UUID());
      return;
    }

    if (newValue.type != Json.Type.string) {
      set(newValue.get!string);
    }
  }

  override void set(string newValue) {
    if (newValue is null) {
      if (!isNullable) return;

      this
        .isNull(true)
        .value(UUID());
      return;
    }

    if (newValue.isUUID) {
      this
        .isNull(false)
        .value(UUID(newValue));
    }
  }

  void set(UUID newValue) {
    if (newValue == UUID()) {
      if (!isNullable) return;

      this
        .isNull(true)
        .value(UUID());
      return;
    }    

    this.isNull(false);
    _value = newValue;
  }

  alias opEquals = UIMValue.opEquals;
  override bool opEquals(UUID equalValue) {
    return (value == equalValue);
  }
  ///
  unittest {
    auto id = randomUUID;
    auto value = new DUUIDValue(id);
    assert(value == id);
  }

  override UIMValue copy() {
    return UUIDValue(value);
  }
  override UIMValue dup() {
    return UUIDValue(value);
  }

  override Json toJson() { 
    if (isNull) return Json(null); 
    return Json(this.value.toString); 
  }

  override string toString() { 
    if (isNull) return UUID().toString; 
    return this.value.toString; 
  }

  override void fromString(string newValue) { 
    this.value(newValue);
  }
}
