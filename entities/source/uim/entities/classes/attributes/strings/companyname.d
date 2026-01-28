/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.companyname;

import uim.entities;
@safe:

// means.iUIMEntity.company.name
class DCompanyNameAttribute : DStringAttribute {
  mixin(AttributeThis!("CompanyNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("companyName");
    this.registerPath("companyName");
  }
}
mixin(AttributeCalls!("CompanyNameAttribute"));

///
unittest {
  auto attribute = new DCompanyNameAttribute;
  assert(attribute.name == "companyName");
  assert(attribute.registerPath == "companyName");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}