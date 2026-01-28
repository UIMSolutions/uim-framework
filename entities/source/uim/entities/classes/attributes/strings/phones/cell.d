/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.phones.cell;

/* any <- char <- string <- phoneCell
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.service.phone.cell */

import uim.entities;

@safe:
class DPhoneCellAttribute : DStringAttribute {
  mixin(AttributeThis!("PhoneCellAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("phonecell")
    this.registerPath("phonecell");
  }
}
mixin(AttributeCalls!("PhoneCellAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}