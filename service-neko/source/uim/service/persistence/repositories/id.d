module uim.service.persistence.repositories.id;

import uim.service;

mixin(ShowModule!());

@safe:

class IdRepository(TEntity, TId) : BaseRepository!(TEntity), IIdRepository!(TEntity, TId) {
  protected TEntity[TId] store;

  this() {
    super();
  }

  override bool initialize(Json initData = Json(null)) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  override bool exists(TEntity entity) {
    return store.byValue.any!(e => e == entity);
  }

  // @disable
  override size_t indexOf(TEntity entity) {
    return store.byValue.countUntil!(e => e == entity);
  }

  override size_t countAll() {
    return findAll().length;
  }

  override TEntity[] findAll(size_t offset = 0, size_t limit = 0) {
    return limit == 0
      ? store.byValue.array.skip(offset).array 
      : store.byValue.array.skip(offset).take(limit).array;
  }

  override void removeAll() {
    store.clear();
  }

  bool existsById(TId id) {
    return (id in store) ? true : false;
  }

  TEntity findById(TId id) {
    if (id in store) {
      return store[id];
    }
    return TEntity.init;
  }

  void removeById(TId id) {
    auto e = findById(id);
    remove(e);
  }

  bool existsAllById(TId[] ids) {
    return ids.all!(id => existsById(id));
  }

  TEntity[] findAllById(TId[] ids, bool onlyExisting = true) {
    return onlyExisting
      ? ids.filter!(id => existsById(id)).map!(id => findById(id)).array 
      : ids.map!(id => findById(id)).array;
  }

  void removeAllById(TId[] ids) {
    findAllById(ids).each!(e => remove(e));
  }

  override void save(TEntity entity) {
    store[entity.id] = entity;
  }

  override void update(TEntity entity) {
    if (existsById(entity.id)) {
      store[entity.id] = entity;
    }
  }

  override void remove(TEntity entity) {
    if (existsById(entity.id)) {
      store.remove(entity.id);
    }
  }

  override void saveAll(TEntity[] entities) {
    entities.each!(entity => save(entity));
  }

  override void updateAll(TEntity[] entities) {
    entities.each!(entity => update(entity));
  }

  override void removeAll(TEntity[] entities) {
    entities.each!(entity => remove(entity));
  }
}
///

struct TestEntityId {
    mixin(IdTemplate);
}

struct TestEntity {
  TestEntityId id;
  string name;

  bool opEquals(TestEntity other) const {
    return id == other.id && name == other.name;
  }
}

class TestRepository : IdRepository!(TestEntity, TestEntityId) {
}

unittest {
  TestEntity entity1 = TestEntity(TestEntityId("1"), "Entity 1");
  TestEntity entity2 = TestEntity(TestEntityId("2"), "Entity 2");

  auto repo = new TestRepository();
  repo.save(entity1);
  repo.save(entity2);

  assert(repo.existsById(TestEntityId("1")));
  assert(repo.findById(TestEntityId("1")) == entity1);
  assert(repo.countAll() == 2);

  repo.removeById(TestEntityId("1"));
  assert(!repo.existsById(TestEntityId("1")));
  assert(repo.countAll() == 1);
}
