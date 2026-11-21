/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.persistence.repositories.repository;

import uim.service;

mixin(ShowModule!());

@safe:

class BaseRepository(TEntity) : IBaseRepository!(TEntity) {
  TEntity[] store;

  this() {
    initialize();
  }

  bool initialize(Json initData = Json(null)) {
    return true;
  }

  bool exists(TEntity entity) {
    return store.any!(e => e.id == entity.id);
  }

  size_t indexOf(TEntity entity) {
    size_t idx = 0;
    foreach (e; store) {
      if (e.id == entity.id) {
        return idx;
      }
      idx++;
    }
    return size_t.max; // Not found
  }

  size_t countAll() {
    return store.length;
  }

  TEntity[] findAll(size_t offset = 0, size_t limit = 0) {
    if (limit == 0) {
      return store.skip(offset);
    }
    return store.skip(offset).take(limit);
  }
  void removeAll() {
    store = null;
  }
  
  void save(TEntity entity) {
    if (exists(entity)) {
      store[indexOf(entity)] = entity;
    }
    else {
      store ~= entity;
    }
  }

  void update(TEntity entity) {
    if (exists(entity)) {
      store[indexOf(entity)] = entity;
    }
  }

  void remove(TEntity entity) {
    if (exists(entity)) {
      auto index = indexOf(entity);
      if (index < store.length) {
        store = store[0..index] ~ store[index + 1 .. $];
      }
      else {
        store = store[0..index];
      }
    }
  }

  void saveAll(TEntity[] entities) {
    entities.each!(entity => save(entity));
  }

  void updateAll(TEntity[] entities) {
    entities.each!(entity => update(entity));
  }

  void removeAll(TEntity[] entities) {
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

class TestRepository : BaseRepository!(TestEntity) {
}

unittest {
  TestEntity entity1 = TestEntity(TestEntityId("1"), "Entity 1");
  TestEntity entity2 = TestEntity(TestEntityId("2"), "Entity 2");

  auto repo = new TestRepository();
  repo.save(entity1);
  repo.save(entity2);

  assert(repo.exists(entity1));
  assert(repo.findAll().canFind(entity1));
  assert(repo.countAll() == 2);

  repo.remove(entity1);
  assert(!repo.exists(entity1));
  // writeln("Count after removal: ", repo.countAll());
  assert(repo.countAll() == 1);
}
