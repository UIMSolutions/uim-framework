/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.booleans.string_;

import uim.entities;

mixin(ShowModule!());

@safe:
class BooleanStringAttribute : UIMAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  mixin(OProperty!("string[bool]", "lookups"));

  // override IValue createValue() {
  //   return new LookupValue!(bool, string)(this).isNullable(isNullable);
  // }
}