/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.entity;

import uim.entities;
@safe:

// A unique identifier for entity instances

class UIMEntityIdAttribute : DUUIDAttribute {
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

  DAttribute generalAttribute = attribute;
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}