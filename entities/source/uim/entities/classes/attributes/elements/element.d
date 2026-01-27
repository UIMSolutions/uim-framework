/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.elements.element;

import uim.entities;

@safe:
class DElementAttribute : DAttribute {
  mixin(AttributeThis!("ElementAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
  }

  override UIMValue createValue() {
    return ElementValue(this); }
}
mixin(AttributeCalls!"ElementAttribute");

version(test_uim_models) { unittest {
  testAttribute(new Attribute);
  testAttribute(ElementAttribute);
}}