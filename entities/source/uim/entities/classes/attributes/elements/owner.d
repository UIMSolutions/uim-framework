/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.elements.owner;

import uim.entities;

@safe:
class DOwnerElementAttribute : UIMAttribute {
  mixin(AttributeThis!("OwnerElementAttribute"));

  override UIMValue createValue() {
    return ElementValue(this)
      .value(
        Element
          .name("owner")
          .adUIMValues([
            "id": UUIDAttribute, // Owner Id"]),
            "idType": StringAttribute, // The type of owner, either User or Team."
          ])
      );
  }
}
mixin(AttributeCalls!"OwnerElementAttribute");

version(test_uim_models) { unittest {
  testAttribute(new DOwnerElementAttribute);
  testAttribute(OwnerElementAttribute);
}}