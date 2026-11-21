module uim.service.persistence.repositories.tenant;

import uim.service;

mixin(ShowModule!());

@safe:

class TenantRepository(TEntity, TId) : ITenantRepository!(TEntity, TId) {
  protected ITenantStore!(TEntity, TId) _store;

  this() {
    initialize();
  }

  this(ITenantStore!(TEntity, TId) store) {
    initialize();
    _store = store;
  }

  bool initialize(Json initData = Json(null)) {
    // if (!super.initialize(initData)) {
    //   return false;
    // }

    _store = new TenantStore!(TEntity, TId)();
    return true;
  }

  // bool existsByTenant(TenantId tenantId) {
  //   return _store.exists(tenantId);
  // }

  // bool isTenantEmpty(TenantId tenantId) {
  //   return !existsByTenant(tenantId) || _store[tenantId].empty;
  // }

  // TenantId[] findAllTenants() {
  //   return store.byKey.array;
  // }

  // void createTenant(TenantId tenantId) {
  //   if (!existsByTenant(tenantId)) {
  //     TEntity[TId] entities;
  //     _store[tenantId] = entities;
  //   }
  // }

  // #region exists
  bool existsByTenant(TenantId tenantId) {
    return _store.exists(tenantId);
  }

  bool existsById(TenantId tenantId, TId id) {
    return _store.exists(tenantId, id);
  }

  bool exists(TEntity entity) {
    return _store.exists(entity);
  }
  // #endregion exists

  // #region count
  size_t countByTenant(TenantId tenantId) {
    return _store.count(tenantId);
  }

  size_t countByTenant(TenantId tenantId, bool delegate(TEntity) @safe predicate) {
    return _store.count(tenantId, predicate);
  }
  // #endregion count

  bool isEmpty(TenantId tenantId) {
    return _store.isEmpty(tenantId);
  }

  // #region filter
  TEntity[] filterEntities(TEntity[] entities, bool delegate(TEntity) @safe predicate) {
    return _store.filter(entities, predicate);
  }
  // #endregion filter

  // #region find
  TEntity[] findByTenant(TenantId tenantId, size_t offset = 0, size_t limit = 0) {
    return _store.find(tenantId, offset, limit);
  }

  TEntity findById(TenantId tenantId, TId id) {
    return _store.find(tenantId, id);
  }
  // #endregion find

  // #region save
  void save(TEntity entity) {
    _store.save(entity);
  }

  void save(TEntity[] entities) {
    foreach (entity; entities) {
      _store.save(entity);
    }
  }
  // #endregion save

  // #region update
  void update(TEntity entity) {
    _store.update(entity);
  }

  void update(TEntity[] entities) {
    foreach (entity; entities) {
      _store.update(entity);
    }
  }
  // #endregion update

  // #region remove
  void removeByTenant(TenantId tenantId) {
    _store.remove(tenantId);
  }

  void removeById(TenantId tenantId, TId id) {
    _store.remove(tenantId, id);
  }

  void remove(TEntity entity) {
    if (entity.isNull)
      return; // Do not remove null entities

    _store.remove(entity);
  }

  void remove(TEntity[] entities) {
    foreach (entity; entities) {
      remove(entity);
    }
  }
  // #endregion remove
}
///

struct TestEntityId {
  mixin(IdTemplate);
}

struct TestEntity {
  mixin TenantEntity!TestEntityId;
  string name;
  TenantId tenantId;

  bool opEquals(TestEntity other) const {
    return id == other.id && name == other.name && tenantId == other.tenantId;
  }
}

class TestRepository : TenantRepository!(TestEntity, TestEntityId) {
}

unittest {
  mixin(ShowTest!("Running TenantRepository tests..."));
  auto tenantId = TenantId("tenant1");
  
  // Creating test entities for tenant: ", tenantId);
  // writeln("Creating entity1...");
  auto entity1 = TestEntity(tenantId, TestEntityId("1"), UserId("user1"));
  entity1.name = "Entity 1";

  // writeln("Creating entity2...");
  auto entity2 = TestEntity(tenantId, TestEntityId("2"), UserId("user2"));
  entity2.name = "Entity 2";

  // writeln("Saving entities...");
  auto repo = new TestRepository();
  repo.save(entity1);
  repo.save(entity2);

  // writeln("Count after saving: ", repo.countByTenant(entity1.tenantId));
  assert(repo.exists(entity1));
  assert(repo.existsById(entity1.tenantId, entity1.id));
  assert(repo.countByTenant(entity1.tenantId) == 2);

  // writeln("Removing entity1...");
  repo.remove(entity1);
  assert(!repo.exists(entity1));
  // writeln("Count after removal: ", repo.countByTenant(entity1.tenantId));
  assert(repo.countByTenant(entity1.tenantId) == 1);

  // writeln("Removing entity2...");
  repo.remove(entity2);
  assert(!repo.exists(entity2));
  // writeln("Count after removal: ", repo.countByTenant(entity1.tenantId));
  assert(repo.countByTenant(entity1.tenantId) == 0);

}
