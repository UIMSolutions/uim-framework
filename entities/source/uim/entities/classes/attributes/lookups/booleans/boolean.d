/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.booleans.boolean;

import uim.entities;

@safe:
class BooleanBooleanAttribute : LookupAttribute {
  mixin(AttributeThis!("BooleanBooleanAttribute"));

  mixin(OProperty!("bool[bool]", "lookups"));

  // override UIMValue createValue() {
  //   return LookupValue!(bool, bool)(this).isNullable(isNullable);
  // }
}