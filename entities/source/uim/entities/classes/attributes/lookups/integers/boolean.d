/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.integers.boolean;

import uim.entities;

mixin(ShowModule!());

@safe:
class IntegerBooleanAttribute : LookupAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  mixin(OProperty!("bool[int]", "lookups"));  
  O addLookup(this O)(int key, string value) {
    _lookups[key] = value;
    return cast(O)this;
  }

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // means.measurement.lookup

    this.name("lookup");
    this.dataFormats(["lookup", "integer", "string"]);
    this.registerPath("lookup");

    return true;
  }

  bool hasLookupKey(int key) {
    return (key in _lookups ? true : false); 
  }
  bool hasLookupValue(bool lookupValue) {
    foreach(k, v; _lookups) { if (v == lookupValue) { return true; } }
    return false; 
  }  

  // override IValue createValue() {
  //   return new LookupValue!(int, bool)(this).isNullable(isNullable); }  
}