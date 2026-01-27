/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.strings.boolean;

import uim.entities;

@safe:
class DStringBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringBooleanAttribute"));

  mixin(OProperty!("bool[string]", "lookups"));

  override DValue createValue() {
    return LookupValue!(string, bool)(this).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("StringBooleanAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}