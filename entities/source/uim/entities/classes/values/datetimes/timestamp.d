/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.values.datetimes.timestamp;

import uim.entities;

@safe:
class DTimestampValue : DLongValue {
  mixin(ValueThis!("TimestampValue", "long"));  

  override DValue copy() {
    return TimestampValue(attribute, toJson);
  }
  override DValue dup() {
    return copy;
  }

  alias opEquals = DLongValue.opEquals;
}
mixin(ValueCalls!("TimestampValue", "long"));  

version(test_uim_models) { unittest {    
    // TODO
}} 