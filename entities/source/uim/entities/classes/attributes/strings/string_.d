/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.string_;

import uim.entities;

@safe:
class StringAttribute : CharAttribute {
  mixin(AttributeThis!"StringAttribute");

  mixin(OProperty!("size_t", "maxLength"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("string");
this.isString(true);
    this.registerPath("string");
  }
  override UIMValue createValue() {
    return StringValue(this)
      .maxLength(this.maxLength); }
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