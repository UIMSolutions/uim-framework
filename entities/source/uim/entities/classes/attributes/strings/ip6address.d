/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.strings.ip6address;

/* Internet Protocol V6 Address of the form XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX

Inheritance
any <- char <- string <- IP6Address
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.iUIMEntity.IP6Address */

import uim.entities;

mixin(ShowModule!());

@safe:
class IP6AddressAttribute : StringAttribute {
  this() {
    super();
  }

  this(Json initData) {
    super(initData.toMap);
  }

  this(Json[string] initData) {
    super(initData);
  }

  // Initialization hook method.
    override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }


    this.name("ip6address");
    this.registerPath("ip6address");

    return true;
  }
}