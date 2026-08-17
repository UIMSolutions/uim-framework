module uim.services.infrastructure.persistence.stores.memory;

import uim.services;

mixin(ShowModule!());

@safe:

class MemoryStore(TEntity, TId) : IStore {
    protected TEntity[TId] _entities;

    this() {
        this.initialize();
    }

    bool initialize(Json initData = Json(null)) {
        return true;
    }

    bool exists(TEntity entity) {
        return (entity.id in _entities) ? true : false;
    }

    bool exists(TId id) {
        return (id in _entities) ? true : false;
    }

    size_t count() {
        return _entities.length;
    }

    size_t count(bool delegate(TEntity) @safe predicate) {
        return this.entities().filter!((TEntity e) => predicate(e)).array.length;
    }

    TEntity[] entities() {
        return _entities.byValue.array;
    }

    TEntity[] entities(bool delegate(TEntity) @safe predicate) {
        return this.entities().filter!((TEntity e) => predicate(e)).array;
    }

    StoreResult update(TEntity entity) {
        if (!this.exists(entity))
            return StoreResult(false, "Entity does not exist.");

        _entities[entity.id] = entity;
        return StoreResult(true, "Entity updated successfully.");
    }

    StoreResult save(TEntity entity) {
        if (this.exists(entity))
            return StoreResult(false, "Entity already exists.");

        _entities[entity.id] = entity;
        return StoreResult(true, "Entity saved successfully.");
    }

    StoreResult remove(TEntity entity) {
        if (!this.exists(entity))
            return StoreResult(false, "Entity does not exist.");

        _entities.remove(entity.id);
        return StoreResult(true, "Entity removed successfully.");
    }

    StoreResult removeById(TId id) {
        if (!this.exists(id))
            return StoreResult(false, "Entity does not exist.");

        _entities.remove(id);
        return StoreResult(true, "Entity removed successfully.");
    }
}
///
unittest {
    struct TestId {
        string value;
    }

    struct TestEntity {
        TestId id;
        string name;
    }

    void testFileStore() {
        auto store = new MemoryStore!(TestEntity, TestId)();
        auto entity1 = TestEntity(TestId("1"), "Entity 1");
        auto entity2 = TestEntity(TestId("2"), "Entity 2");

        // testStore(store, [entity1, entity2]);
        assert(store.count == 0);
    }
}
