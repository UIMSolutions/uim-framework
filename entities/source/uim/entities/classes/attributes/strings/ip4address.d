/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.ip4address;

/* Internet Protocol V4 Address of the form DDD.DDD.DDD.DDD

Inheritance
any <- char <- string <- IP4Address
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.IP4Address */

import uim.entities;

@safe:
class IP4AddressAttribute : StringAttribute {
  mixin(AttributeThis!("IP4AddressAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("ip4address");
    this.registerPath("ip4address");
  }
}