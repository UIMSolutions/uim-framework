/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.booleans.string_;

import uim.entities;

@safe:
class DBooleanStringAttribute : DAttribute {
  mixin(AttributeThis!("BooleanStringAttribute"));

  mixin(OProperty!("string[bool]", "lookups"));

  override UIMValue createValue() {
    return LookupValue!(bool, string)(this).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("BooleanStringAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}