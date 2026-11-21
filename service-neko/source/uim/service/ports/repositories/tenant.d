module uim.service.ports.repositories.tenant;

import uim.service;

mixin(ShowModule!());

@safe:

interface ITenantRepository(TEntity, TId) {

  // #region exists
  bool existsByTenant(TenantId tenantId);
  bool existsById(TenantId tenantId, TId id);
  bool exists(TEntity entity);
  // #endregion exists

  // #region count
  size_t countByTenant(TenantId tenantId);
  size_t countByTenant(TenantId tenantId, bool delegate(TEntity) @safe predicate);
  // #endregion count

  bool isEmpty(TenantId tenantId);

  // #region filter
  TEntity[] filterEntities(TEntity[] entities, bool delegate(TEntity) @safe  predicate);
  // #endregion filter

  // #region find
  TEntity[] findByTenant(TenantId tenantId, size_t offset = 0, size_t limit = 0);
  TEntity findById(TenantId tenantId, TId id);
  // #endregion find

  // #region save
  void save(TEntity entity);
  void save(TEntity[] entities);
  // #endregion save

  // #region update
  void update(TEntity entity);
  void update(TEntity[] entities);
  // #endregion update

  // #region remove
  void removeById(TenantId tenantId, TId id);
  void remove(TEntity entity);
  void remove(TEntity[] entities);
  // #endregion remove
}
