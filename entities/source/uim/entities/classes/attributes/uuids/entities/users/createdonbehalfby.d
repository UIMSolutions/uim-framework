/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.users.createdonbehalfby;

import uim.entities;

@safe:
class DCreatedOnBehalfByAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("CreatedOnBehalfByAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("createdOnBehalfBy")
      .registerPath("createdOnBehalfBy");
  }  
}
mixin(AttributeCalls!("CreatedOnBehalfByAttribute"));

///
unittest {
  auto attribute = new DCreatedOnBehalfByAttribute;
  assert(attribute.name == "createdOnBehalfBy");
  assert(attribute.registerPath == "createdOnBehalfBy");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}