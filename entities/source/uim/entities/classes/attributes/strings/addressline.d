/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.addressline;

import uim.entities;
@safe:
/** 
 * is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.address
 */
class AddressLineAttribute : DStringAttribute {
  mixin(AttributeThis!"AddressLineAttribute");

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    // means.location.address
    this.name("addressLine");
    this.registerPath("addressline");
  }
}