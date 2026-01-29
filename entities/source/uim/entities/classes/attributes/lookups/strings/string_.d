/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.strings.string_;

import uim.entities;

mixin(ShowModule!());

@safe:
class StringStringAttribute : LookupAttribute {
  mixin(AttributeThis!("StringStringAttribute"));
  
  mixin(OProperty!("string[string]", "lookups"));

  override UIMValue createValue() {
    return LookupValue!(string, string).isNullable(isNullable);
  }
}

