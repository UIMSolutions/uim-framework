/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.arrays.array_;

import uim.entities;

@safe:
class ArrayValue : UIMValue {
  mixin(ValueThis!("ArrayValue"));  
  this(UIMValue[] values) {
    this();
    _items = values.dup;
  }

  UIMValue[] _items;

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .isArray(true);
  }

  ArrayValue add(UIMValue[] values...) { 
    this.add(values.dup); 
    return this; }

  ArrayValue add(UIMValue[] values) {
    _items ~= values.dup; 
    return this;
  }
  /// 
  unittest {
    writeln(ArrayValue.add(StringValue("1x"), StringValue("2x")).values.map!(v => v.toString).array);
  }
  
  alias opEquals = UIMValue.opEquals;

  UIMValue[] values() { return _items; }

  override UIMValue copy() {
    return new ArrayValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }

  override string toString() {
    return "["~_items.map!(item => item.toString).join(",")~"]";
  }
}