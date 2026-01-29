/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.entity;

import uim.entities;

mixin(ShowModule!());

@safe:

// A unique identifier for entity instances

class EntityIdAttribute : UUIDAttribute {0
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }
/*   is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
is.dataFormat.guid
means.iUIMEntity.entityId */

}