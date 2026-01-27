/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.classes.attributes.strings.entityname;

import uim.entities;
@safe:

/* Type for trait parameters that take entity names as values
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.entityName
means.entityName */
class UIMEntityNameAttribute : DStringAttribute {
  mixin(AttributeThis!("EntityNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("entityname")
      .registerPath("entityName");
  }
}
mixin(AttributeCalls!("EntityNameAttribute"));

///
unittest {
  auto attribute = new UIMEntityNameAttribute;
  assert(attribute.name == "entityname");
  assert(attribute.registerPath == "entityName");
}