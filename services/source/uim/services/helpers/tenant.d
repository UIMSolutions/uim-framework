module uim.services.helpers.tenant;

import uim.services;

mixin(ShowModule!());

@safe:
bool containsTenantId(TenantId[] values, TenantId tenantId) {
  return values.any!(v => v == tenantId);
}

bool containsTenantId(string[] values, TenantId tenantId) {
  auto id = tenantId.value;
  return values.any!(v => v == id);
}

bool containsTenant(UUID[] ids, TenantId tenantId) {
  if (!tenantId.value.isUUID) {
    return false;
  }
  auto id = UUID(tenantId.value);
  return ids.any!(i => i == id);
}