/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.strings.string_;

import uim.entities;

@safe:
class DStringStringAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringStringAttribute"));
  
  mixin(OProperty!("string[string]", "lookups"));

  override DValue createValue() {
    return LookupValue!(string, string).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("StringStringAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}