/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.timestamp;

import uim.entities;

mixin(ShowModule!());

@safe:
class TimestampValue : LongValue {
  this() {
    super();
  }  

  this(IAttribute attribute, Json toJson = Json(null)) {
    super(attribute, toJson);
  }  

  override UIMValue copy() {
    return new TimestampValue(attribute, toJson);
  }

  alias opEquals = LongValue.opEquals;
}
