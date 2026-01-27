/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.registry;

import uim.entities;

@safe:
class DAttributeRegistry : DRegistry!UIMAttribute {
  static DAttributeRegistry registry;
}

auto AttributeRegistry() { // SIngleton
  if (DAttributeRegistry.registry is null) {
    DAttributeRegistry.registry = new DAttributeRegistry;
  }
  return DAttributeRegistry.registry;
}