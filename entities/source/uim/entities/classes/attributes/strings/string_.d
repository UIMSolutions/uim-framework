/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.string_;

import uim.entities;

mixin(ShowModule!());

@safe:
class StringAttribute : CharAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  mixin(OProperty!("size_t", "maxLength"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    this.name("string");
    this.isString(true);
    this.registerPath("string");

    return true;
  }

  override IValue createValue() {
    return new StringValue(this)
      .maxLength(this.maxLength);
  }
}
///
unittest {
  auto attribute = new StringAttribute;
  assert(attribute.name == "string");
  assert(attribute.registerPath == "string");

  UIMAttribute generalAttribute = attribute;
  assert(!cast(IntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}
