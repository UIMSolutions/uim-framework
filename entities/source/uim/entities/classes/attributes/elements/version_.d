/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.elements.version_;

import uim.entities;

@safe:
class DVersionElementAttribute : DAttribute {
  mixin(AttributeThis!("VersionElementAttribute"));

  override DValue createValue() {
    return ElementValue(this)
      .value(
        Version        
      );
  }
}
mixin(AttributeCalls!"VersionElementAttribute");

version(test_uim_models) { unittest {
  testAttribute(new DVersionElementAttribute);
  testAttribute(VersionElementAttribute);
}}