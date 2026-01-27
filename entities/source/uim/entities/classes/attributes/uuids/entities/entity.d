/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.entity;

import uim.entities;
@safe:

// A unique identifier for entity instances

class UIMEntityIUIMAttribute : DUUIUIMAttribute {
  mixin(AttributeThis!("EntityIdAttribute"));

/*   is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
is.dataFormat.guid
means.iUIMEntity.entityId */



}
mixin(AttributeCalls!("EntityIdAttribute"));

///
unittest {
  auto attribute = new UIMEntityIdAttribute;

  UIMAttribute generalAttribute = attribute;
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}