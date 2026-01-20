/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.helpers.repository;

import uim.core;
import uim.oop;
import uim.entities.entity;
import uim.entities.collection;

import std.uuid : UUID;

@safe:

/**
 * Repository interface for entity persistence
 */
interface IEntityRepository {
    // CRUD operations
    IEntity find(UUID id);
    IEntity[] findAll();
    IEntity save(IEntity entity);
    void remove(IEntity entity);
    void removeById(UUID id);
    
    // Query operations
    IEntity findByName(string name);
    IEntity[] findByAttribute(string key, string value);
    IEntity[] findByState(EntityState state);
    
    // Batch operations
    IEntity[] saveAll(IEntity[] entities);
    void removeAll(IEntity[] entities);
    
    // Count
    size_t count();
    size_t countByState(EntityState state);
}

/**
 * In-memory repository implementation
 */
class DEntityRepository : UIMObject, IEntityRepository {
    protected DEntityCollection _collection;
    
    this() {
        super();
        _collection = EntityCollection();
    }
    
    this(DEntityCollection collection) {
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
        if (entity.isNew()) {
            _collection.add(entity);
            entity.markClean();
        } else if (entity.isDirty()) {
            // Update existing entity
            _collection.add(entity); // Replace
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
    
    // Batch operations
    IEntity[] saveAll(IEntity[] entities) {
        foreach (entity; entities) {
            save(entity);
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
        return findByState(state).length;
    }
    
    // Access to underlying collection
    DEntityCollection collection() {
        return _collection;
    }
}

// Factory function
auto EntityRepository() {
    return new DEntityRepository();
}

auto EntityRepository(DEntityCollection collection) {
    return new DEntityRepository(collection);
}

unittest {
    writeln("Testing DEntityRepository class...");
    
    auto repository = EntityRepository();
    
    // Test save new entity
    auto entity = Entity("Test Entity");
    entity.setAttribute("type", "test");
    
    repository.save(entity);
    assert(entity.isClean());
    assert(repository.count() == 1);
    
    // Test find
    auto found = repository.find(entity.id());
    assert(found !is null);
    assert(found.name() == "Test Entity");
    
    // Test update
    found.setAttribute("updated", "yes");
    assert(found.isDirty());
    
    repository.save(found);
    assert(found.isClean());
    
    // Test findByAttribute
    auto byAttr = repository.findByAttribute("type", "test");
    assert(byAttr.length == 1);
    
    // Test batch save
    auto entity2 = Entity("Entity 2");
    auto entity3 = Entity("Entity 3");
    repository.saveAll([entity2, entity3]);
    assert(repository.count() == 3);
    
    // Test remove
    repository.remove(entity2);
    assert(repository.count() == 2);
    
    writeln("DEntityRepository tests passed!");
}
