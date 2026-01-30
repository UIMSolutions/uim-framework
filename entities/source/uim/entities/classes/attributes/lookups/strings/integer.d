/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.strings.integer;

import uim.entities;

mixin(ShowModule!());

@safe:
/* 
class StringIntegerAttribute : LookupAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  protected int[string] _lookups;

  /// Getter for the 'lookups' property
  int[string] lookups() {
    return _lookups;
  }

  /// Setter for the 'lookups' property
  void lookups(int[string] value) {
    _lookups = value;
  }

  override IValue createValue() {
    auto value = new LookupValue!(string, int);
    value.isNullable(isNullable);
    return value;
  }
}
*/
