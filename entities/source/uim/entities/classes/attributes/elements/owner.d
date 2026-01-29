/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.elements.owner;

import uim.entities;

mixin(ShowModule!());

@safe:
class OwnerElementAttribute : UIMAttribute {
  mixin(AttributeThis!("OwnerElementAttribute"));

  override IValue createValue() {
    return (new ElementValue)
      .attribute(this)
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
