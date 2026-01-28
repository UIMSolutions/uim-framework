/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.names.name;

/* any <- char <- string <- name
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.name */

import uim.entities;

@safe:
class DNameAttribute : DStringAttribute {
  mixin(AttributeThis!("NameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("name")
    this.registerPath("name");
  }
}
mixin(AttributeCalls!("NameAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}