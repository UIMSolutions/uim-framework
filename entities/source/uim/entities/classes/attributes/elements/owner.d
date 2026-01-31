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
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }


  override IValue createValue() {
    auto value = (new ElementValue(this));
      value.value(
       (new UIMElement)
          .name("owner")
          // .addValues([
          //   "id": new UUIDAttribute, // Owner Id"]),
          //   "idType": new StringAttribute, // The type of owner, either User or Team."
          // ])
    );
    return value;
  }
}
