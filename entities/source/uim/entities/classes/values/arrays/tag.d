/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.arrays.tag;

import uim.entities;

mixin(ShowModule!());

@safe:
class TagArrayValue : StringArrayValue {
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
      .shouldTrim(true)
      .separator("#");
  }

  size_t length() {
    return _values.length;
  }

  alias opEquals = UIMValue.opEquals;

  override UIMValue copy() {
    return TagArrayValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }
  
  override string toString() {
    if (length > 0) return separator~this.value.join(separator);
    return null; 
  }
}