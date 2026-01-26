/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.helpers.repository;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * In-memory repository implementation
 */
class UIMEntityRepository : UIMObject, IEntityRepository {
    protected UIMEntityCollection _collection;
    
    this() {
        super();
        _collection = entityCollection();
    }
    
    this(UIMEntityCollection collection) {
        super();
        _collection = collection;
    }
    
    // CRUD operations
    IEntity find(UUID id) {
        return _collection.get(id);
    }
    
    IEntity[] findAll() {
        return _collection.getAll();
    }
    
    IEntity save(IEntity entity) {
        auto state = entity.state();
        if (state == EntityState.New || state == EntityState.Dirty) {
            _collection.add(entity); // Add or replace
            entity.markClean();
        }
        return entity;
    }
    
    void remove(IEntity entity) {
        entity.markDeleted();
        _collection.remove(entity);
    }
    
    void removeById(UUID id) {
        auto entity = _collection.get(id);
        if (entity !is null) {
            remove(entity);
        }
    }
    
    // Query operations
    IEntity findByName(string name) {
        return _collection.findByName(name);
    }
    
    IEntity[] findByAttribute(string key, string value) {
        return _collection.findByAttribute(key, value);
    }
    
    IEntity[] findByState(EntityState state) {
        final switch (state) {
            case EntityState.New:
                return _collection.getNew();
            case EntityState.Clean:
                return _collection.getClean();
            case EntityState.Dirty:
                return _collection.getDirty();
            case EntityState.Deleted:
                return _collection.getDeleted();
        }
    }
    
    // Batch operations - optimized
    IEntity[] saveAll(IEntity[] entities) {
        foreach (entity; entities) {
            auto state = entity.state();
            if (state == EntityState.New || state == EntityState.Dirty) {
                _collection.add(entity);
                entity.markClean();
            }
        }
        return entities;
    }
    
    void removeAll(IEntity[] entities) {
        foreach (entity; entities) {
            remove(entity);
        }
    }
    
    // Count
    size_t count() {
        return _collection.count();
    }
    
    size_t countByState(EntityState state) {
        // Direct count without creating intermediate arrays
        final switch (state) {
            case EntityState.New:
                return _collection.getNew().length;
            case EntityState.Clean:
                return _collection.getClean().length;
            case EntityState.Dirty:
                return _collection.getDirty().length;
            case EntityState.Deleted:
                return _collection.getDeleted().length;
        }
    }
    
    // Access to underlying collection
    UIMEntityCollection collection() {
        return _collection;
    }
}

// Factory function
auto entityRepository() {
    return new UIMEntityRepository();
}

auto entityRepository(UIMEntityCollection collection) {
    return new UIMEntityRepository(collection);
}

unittest {
    writeln("Testing UIMEntityRepository class...");
    
    auto repo = entityRepository();
    
    // Test save new entity
    auto ent = entity("Test Entity");
    ent.setAttribute("type", "test");
    
    repo.save(ent);
    assert(ent.isClean());
    assert(repo.count() == 1);
    
    // Test find
    auto found = repo.find(ent.id());
    assert(found !is null);
    assert(found.name() == "Test Entity");
    
    // Test update
    found.setAttribute("updated", "yes");
    assert(found.isDirty());
    
    repo.save(found);
    assert(found.isClean());
    
    // Test findByAttribute
    auto byAttr = repo.findByAttribute("type", "test");
    assert(byAttr.length == 1);
    
    // Test batch save
    auto ent2 = entity("Entity 2");
    auto ent3 = entity("Entity 3");
    repo.saveAll([ent2, ent3]);
    assert(repo.count() == 3);
    
    // Test remove
    repo.remove(ent2);
    assert(repo.count() == 2);
    
    writeln("UIMEntityRepository tests passed!");
}
