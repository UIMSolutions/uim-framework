/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.booleans.boolean;

import uim.entities;

@safe:
class DBooleanBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("BooleanBooleanAttribute"));

  mixin(OProperty!("bool[bool]", "lookups"));

  override DValue createValue() {
    return LookupValue!(bool, bool)(this).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("BooleanBooleanAttribute"));

///
unittest {  
  auto lookupAttribute = BooleanBooleanAttribute;
  lookupAttribute.lookups[true] = false;
  lookupAttribute.lookups[false] = true;
  assert(!lookupAttribute.isNullable);

  lookupAttribute.isNullable(true);
  assert(lookupAttribute.isNullable);

  auto lookupValue = lookupAttribute.createValue;
}