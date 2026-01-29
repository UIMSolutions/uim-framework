/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.users.team;

import uim.entities;

@safe:
class DTeamIUIMAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("TeamIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("teamId");
    this.registerPath("teamId");
  }  
}
mixin(AttributeCalls!("TeamIdAttribute"));

///
unittest {
  auto attribute = new DTeamIdAttribute;
  assert(attribute.name == "teamId");
  assert(attribute.registerPath == "teamId");

  UIMAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}