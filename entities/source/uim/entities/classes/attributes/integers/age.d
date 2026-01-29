/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.integers.age;

import uim.entities;

@safe:
class AgeAttribute : DIntegerAttribute {
  mixin(AttributeThis!("AgeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    //means.demographic.age
    //means.measurement.age
    this.name("age");
    this.registerPath("age");    
  }
}
mixin(AttributeCalls!"AgeAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DAgeAttribute);
    testAttribute(AgeAttribute);
  }
}