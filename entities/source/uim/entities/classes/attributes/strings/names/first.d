/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.names.first;

import uim.entities;

mixin(ShowModule!());

@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.person.firstName */
class FirstNameAttribute : StringAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("firstName");
    this.registerPath("firstname");
  }
}

