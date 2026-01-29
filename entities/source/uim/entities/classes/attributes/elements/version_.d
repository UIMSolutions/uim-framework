/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.elements.version_;

import uim.entities;

mixin(ShowModule!());

@safe:
class VersionElementAttribute : UIMAttribute {
  mixin(AttributeThis!("VersionElementAttribute"));

  override IValue createValue() {
    return new ElementValue(this)
      .value(
        Version        
      );
  }
}