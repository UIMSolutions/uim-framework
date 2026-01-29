/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.names.middle;

/* any <- char <- string <- middleName
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.person.middleName */

import uim.entities;

mixin(ShowModule!());

@safe:
class MiddleNameAttribute : StringAttribute {
  mixin(AttributeThis!("MiddleNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("middleName");
    this.registerPath("middleName");
  }
}

