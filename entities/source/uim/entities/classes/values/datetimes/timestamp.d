/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.timestamp;

import uim.entities;

@safe:
class TimestampValue : DLongValue {
  this() {
    super;
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  override UIMValue copy() {
    return TimestampValue(attribute, toJson);
  }
  override UIMValue dup() {
    return copy;
  }

  alias opEquals = DLongValue.opEquals;
}
