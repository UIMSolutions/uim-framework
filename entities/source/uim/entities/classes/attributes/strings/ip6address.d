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

@safe:
class DIP6AddressAttribute : DStringAttribute {
  mixin(AttributeThis!("IP6AddressAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this.name("ip6address");
    this.registerPath("ip6address");
  }
}
mixin(AttributeCalls!("IP6AddressAttribute"));

///
unittest {
  auto attribute = new DIP6AddressAttribute;
  assert(attribute.name == "ip6address");
  assert(attribute.registerPath == "ip6address");

  UIMAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}