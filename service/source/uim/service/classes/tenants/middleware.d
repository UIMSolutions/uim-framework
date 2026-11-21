/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.tenants.middleware;
import uim.service;

mixin(ShowModule!());

@safe:
/*
class UIMTenantMiddleware {
  protected SAPTenantRepository tenantRepository;

  this(SAPTenantRepository tenantRepository) {
  this.tenantRepository = tenantRepository;
  }

  void handleRequest(HttpServerRequest req, HttpServerResponse res) {
  TenantId tenantId = req.getHeader("X-Tenant-ID");
  if (!tenantId.isEmpty && tenantId.length > 0) {
    auto tenant = tenantRepository.findById(tenantId);
    if (!tenant.isNull) {
    req.setUserData(tenant);
    } else {
    res.statusCode = HttpStatus.notFound;
    res.writeBody("Tenant not found");
    res.send();
    return;
    }
  } else {
    res.statusCode = HttpStatus.badRequest;
    res.writeBody("Missing Tenant ID");
    res.send();
    return;
  }
  }
}
*/
