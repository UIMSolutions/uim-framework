/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.entityname;

import uim.entities;

mixin(ShowModule!());

@safe:

/* Type for trait parameters that take entity names as values
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.entityName
means.entityName */
class UIMEntityNameAttribute : StringAttribute {
  this() {
    super();
  }

  this(Json configSettings) {
    super(configSettings);
  }
  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("entityname");
    this.registerPath("entityName");
  }
}