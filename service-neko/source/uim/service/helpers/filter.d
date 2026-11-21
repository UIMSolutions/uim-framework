module uim.service.helpers.filter;

import uim.service;

mixin(ShowModule!());

@safe:

TEntity[] filterPaged(TEntity)(TEntity[] items, size_t offset, size_t limit, bool delegate(TEntity) pred = (TEntity e) => true) {
  TEntity[] result;
  size_t idx;
  if (offset >= items.length)
    return result;

  foreach (e; items) {
    if (pred(e)) {
      if (idx >= offset && result.length < limit)
        result ~= e;
      idx++;

      if (result.length >= limit)
        break;
    }
  }
  return result;
}

TEntity[] filterByTenant(TEntity)(TEntity[] entities, TenantId id) {
  return entities.filter!(e => e.tenantId == id).array;
}

TEntity[] filterBySpace(TEntity)(TEntity[] entities, SpaceId id) {
  return entities.filter!(e => e.spaceId == id).array;
}

TEntity[] filterByUser(TEntity)(TEntity[] entities, UserId id) {
  return entities.filter!(e => e.userId == id).array;
}

TEntity[] filterByGlobalAccount(TEntity)(TEntity[] entities, GlobalAccountId id) {
  return entities.filter!(e => e.globalAccountId == id).array;
}

TEntity[] filterBySubaccount(TEntity)(TEntity[] entities, SubaccountId id) {
  return entities.filter!(e => e.subaccountId == id).array;
}

TEntity[] filterByConnection(TEntity)(TEntity[] entities, ConnectionId id) {
  return entities.filter!(e => e.connectionId == id).array;
}

TEntity[] filterByOrg(TEntity)(TEntity[] entities, OrgId id) {
  return entities.filter!(e => e.orgId == id).array;
}
