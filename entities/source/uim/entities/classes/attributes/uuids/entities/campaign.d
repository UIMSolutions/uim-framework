/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.classes.attributes.uuids.entities.campaign;

import uim.entities;

@safe:
class DCampaignIUIMAttribute : UIMEntityIUIMAttribute {
  mixin(AttributeThis!("CampaignIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("campaignId")
    this.registerPath("campaignId");
  }  
}
mixin(AttributeCalls!("CampaignIdAttribute"));

///
unittest {
  auto attribute = new DCampaignIdAttribute;
  assert(attribute.name == "campaignId");
  assert(attribute.registerPath == "campaignId");

  UIMAttribute generalAttribute = attribute;
  assert(cast(UIMEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  UIMValue value = attribute.createValue();
  assert(cast(DUUIUIMValue)value);
}