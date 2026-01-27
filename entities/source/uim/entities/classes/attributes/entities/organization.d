/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.entities.classes.attributes.entities.organization;

import uim.entities;
@safe:

/* class DOrganizationAttribute : UIMEntityAttribute {
  mixin(AttributeThis!("OrganizationAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("organization")
      .registerPath("organization");
  }  
}
mixin(AttributeCalls!("OrganizationAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DOrganizationAttribute);
    testAttribute(OrganizationAttribute);
  }
} */