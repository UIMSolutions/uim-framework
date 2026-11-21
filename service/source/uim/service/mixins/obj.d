/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.mixins.obj;

import uim.service;

mixin(ShowModule!());

@safe:
string uimEntityTemplate() {
  return q{
  this() {
    super();
  }

  this(Json initData) {
    super(initData);
  }


  this(Json[string] initData) {
    super(initData);
  }
  };
}

template UIMEntityTemplate(alias Symbol) {
  const char[] UIMEntityTemplate = uimEntityTemplate();
}

string uimTenantEntityTemplate() {
  return q{
  this() {
    super();
  }

  this(UUID tenantId) {
    super();
    this.tenantId = tenantId;
  }

  this(Json initData) {
    super(initData);
  }

  this(Json[string] initData) {
    super(initData);
  }

  this(UUID tenantId, Json[string] initData) {
    super(initData);
    this.tenantId = tenantId;
  }
  };
}

template UIMTenantEntityTemplate(alias Symbol) {
  const char[] UIMTenantEntityTemplate = uimTenantEntityTemplate();
}
