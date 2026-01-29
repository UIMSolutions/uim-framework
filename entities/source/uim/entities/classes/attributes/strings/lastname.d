/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.lastname;

import uim.entities;

mixin(ShowModule!());

@safe:

// means.iUIMEntity.person.lastName
class LastNameAttribute : DStringAttribute {
  mixin(AttributeThis!("LastNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("lastname");
    this.registerPath("lastname");
  }
<<<<<<< HEAD
}
=======
}
>>>>>>> c47de0c054ce6f333e5a9caf816cd85e7f333dd3
