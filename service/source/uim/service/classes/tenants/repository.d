/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.classes.tenants.repository;

import uim.service;

mixin(ShowModule!());

@safe:
/*
class UIMTenantRepository {
  protected IUIMTenant[UUID] tenants;

  this() {
  // Load tenants from a data source or initialize an empty array
  tenants = null;
  }

  void addTenant(IUIMTenant tenant) {
  tenants[tenant.id] = tenant;
  writeln("Tenant added: ", tenant.name);
  }

  IUIMTenant getTenant(UUID tenantId) {
  return tenantId in tenants ? tenants[tenantId] : null;
  }

  void updateTenant(UUID tenantId, IUIMTenant updatedTenant) {
  if (tenantId in tenants) {
    tenants[tenantId] = updatedTenant;
    writeln("Tenant updated: ", updatedTenant.name);
    return;
  }
  writeln("Tenant not found: ", tenantId);
  }

  void deleteTenant(UUID tenantId) {
  if (tenantId in tenants) {
    tenants.remove(tenantId);
    writeln("Tenant deleted: ", tenantId);
    return;
  }
  writeln("Tenant not found: ", tenantId);
  }

  IUIMTenant[] getAllTenants() {
  return tenants.values.array.toJson;
  }

  void loadTenantsFromJson(string jsonData) {
  auto json = parseJsonString(jsonData);
  foreach (tenantJson; json["tenants"].array.toJson) {
    tenants[Tenant(tenantJson["id"].get!string, tenantJson["name"].getString).id] = Tenant(tenantJson["id"].get!string, tenantJson["name"].getString);
  }
  }
}
*/
