/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.ports.storages.tenant;

import uim.service;

mixin(ShowModule!());

@safe:
interface ITenantStore(TEntity, TId) {
    // #region exists
    bool exists(TenantId tenantId);
    bool exists(TenantId tenantId, TId id);
    bool exists(TEntity entity);
    // #endregion exists

    // #region count
    size_t count(TenantId tenantId);
    size_t count(TenantId tenantId, bool delegate(TEntity) @safe predicate);
    // #endregion count

    bool isEmpty(TenantId tenantId);

    // #region filter
    TEntity[] filter(TEntity[] entities, bool delegate(TEntity) @safe predicate);
    // #endregion filter

    // #region find
    TEntity[] find(TenantId tenantId, size_t offset = 0, size_t limit = 0);
    TEntity find(TenantId tenantId, TId id);
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
    void remove(TenantId tenantId);
    void remove(TenantId tenantId, TId id);
    void remove(TEntity entity);
    void remove(TEntity[] entities);
    // #endregion remove
}
