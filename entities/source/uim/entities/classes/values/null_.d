/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.null_;

import uim.entities;

@safe:
class DNullValue : UIMValue {
  mixin(ValueThis!("NullValue"));  

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isNull(true);
  }

  override UIMValue copy() {
    return NullValue;
  }
  override UIMValue dup() {
    return NullValue;
  }
  
  override Json toJson() { return Json(null); }
  override string toString() { return null; }
}
