/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.file;

import uim.entities;

@safe:
class DFileIdAttribute : UIMEntityIdAttribute {
  mixin(AttributeThis!("FileIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("fileId")
      .registerPath("fileId");
  }  
}
mixin(AttributeCalls!("FileIdAttribute"));

///
unittest {
  auto attribute = new DFileIdAttribute;
  assert(attribute.name == "fileId");
  assert(attribute.registerPath == "fileId");

  DAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}