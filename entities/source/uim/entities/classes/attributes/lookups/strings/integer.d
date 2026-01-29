/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.strings.integer;

import uim.entities;

@safe:
class StringIntegerAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringIntegerAttribute"));

  mixin(OProperty!("int[string]", "lookups"));

  override UIMValue createValue() {
    return LookupValue!(string, int).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("StringIntegerAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}