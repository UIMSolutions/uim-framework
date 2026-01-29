/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.names.full;

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.person.fullName */

import uim.entities;

mixin(ShowModule!());

@safe:
class FullNameAttribute : StringAttribute {
  mixin(AttributeThis!("FullNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("fullName");
    this.registerPath("fullName");
  }
}

