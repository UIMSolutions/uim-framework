/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.entities.tenant;

import uim.service;

mixin(ShowModule!());

@safe:

class UIMTenantEntity : UIMEntity {
  mixin(UIMEntityTemplate!UIMTenantEntity);

  this(UUID tenantId) {
    super();
    this.tenantId(tenantId);
  }

  this(UUID tenantId, Json[string] initData) {
    super(initData);
    this.tenantId(tenantId);
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    if (initData.hasKey("tenant_id")) {
      _tenantId = UUID(initData["tenant_id"].getString);
    }

    return true;
  }

  override Json toJson() {
    return super.toJson()
      .set("tenantId", _tenantId.toString());
  }
  ///
  unittest {
    UUID id = randomUUID();
    UIMTenantEntity obj = new UIMTenantEntity(id);
    Json json = obj.toJson();
    assert(json["tenantId"].get!string == obj.tenantId.toString());
  }

  // #region tenantId
  protected UUID _tenantId;
  UUID tenantId() const {
    return _tenantId;
  }

  void tenantId(UUID id) {
    _tenantId = id;
  }
  ///
  unittest {
    UUID id = randomUUID();
    UIMTenantEntity obj = new UIMTenantEntity(id);
    assert(obj.tenantId == id);

    UUID id2 = randomUUID();
    obj.tenantId(id2);
    assert(obj.tenantId == id2);
  }
  // #endregion tenantId
}
