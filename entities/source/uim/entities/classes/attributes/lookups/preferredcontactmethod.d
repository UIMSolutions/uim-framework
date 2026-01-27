/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.lookups.preferredcontactmethod;

import uim.entities;

@safe:
class DPreferredContactMethodAttribute : DAttribute {
  mixin(AttributeThis!("PreferredContactMethodAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.preferredcontactmethod

    this
      .name("preferredcontactmethod")
      .dataFormats(["preferredcontactmethod"])
      .registerPath("preferredcontactmethod");
  }

/*   override DValue createValue() {
    return PreferredContactMethodValue(this); } */
}
mixin(AttributeCalls!("PreferredContactMethodAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}