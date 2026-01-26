/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.collection;

import uim.entities;

mixin(ShowModule!());

@safe:



/**
 * Entity collection implementation
 */
class UIMEntityCollection : UIMObject, IEntityCollection {
    protected IEntity[UUID] _entities;
    
    this() {
        super();
    }
    
    // Basic operations
    size_t count() {
        return _entities.length;
    }
    
    bool isEmpty() {
        return _entities.length == 0;
    }
    
    void clear() {
        _entities = null;
    }
    
    // Add/Remove
    IEntityCollection add(IEntity entity) {
        _entities[entity.id()] = entity;
        return this;
    }
    
    IEntityCollection remove(IEntity entity) {
        _entities.remove(entity.id());
        return this;
    }
    
    IEntityCollection removeById(UUID id) {
        _entities.remove(id);
        return this;
    }
    
    // Query
    IEntity get(UUID id) {
        return (id in _entities) ? _entities[id] : null;
    }
    
    IEntity findByName(string name) {
        foreach (entity; _entities) {
            if (entity.name() == name) {
                return entity;
            }
        }
        return null;
    }
    
    IEntity[] findByAttribute(string key, string value) @trusted {
        IEntity[] result;
        result.reserve(_entities.length / 4); // Heuristic: expect ~25% matches
        
        foreach (entity; _entities.byValue) {
            if (entity.hasAttribute(key) && entity.getAttribute(key) == value) {
                result ~= entity;
            }
        }
        return result;
    }
    
    IEntity[] getAll() {
        return _entities.byValue.array;
    }
    
    bool contains(IEntity entity) {
        return (entity.id() in _entities) !is null;
    }
    
    bool containsId(UUID id) {
        return (id in _entities) !is null;
    }
    
    // State filtering - optimized with early capacity allocation
    IEntity[] getNew() @trusted {
        IEntity[] result;
        result.reserve(_entities.length / 2);
        foreach (entity; _entities.byValue) {
            if (entity.isNew()) result ~= entity;
        }
        return result;
    }
    
    IEntity[] getDirty() @trusted {
        IEntity[] result;
        result.reserve(_entities.length / 2);
        foreach (entity; _entities.byValue) {
            if (entity.isDirty()) result ~= entity;
        }
        return result;
    }
    
    IEntity[] getClean() @trusted {
        IEntity[] result;
        result.reserve(_entities.length / 2);
        foreach (entity; _entities.byValue) {
            if (entity.isClean()) result ~= entity;
        }
        return result;
    }
    
    IEntity[] getDeleted() @trusted {
        IEntity[] result;
        result.reserve(_entities.length / 4);
        foreach (entity; _entities.byValue) {
            if (entity.isDeleted()) result ~= entity;
        }
        return result;
    }
    
    // Bulk operations
    void markAllClean() {
        foreach (entity; _entities) {
            entity.markClean();
        }
    }
    
    void markAllDirty() {
        foreach (entity; _entities) {
            entity.markDirty();
        }
    }
}

// Factory function
auto entityCollection() {
    return new UIMEntityCollection();
}

unittest {
    writeln("Testing UIMEntityCollection class...");
    
    auto collection = entityCollection();
    assert(collection.isEmpty());
    
    auto entity1 = entity("Entity 1");
    auto entity2 = entity("Entity 2");
    
    collection.add(entity1);
    collection.add(entity2);
    
    assert(collection.count() == 2);
    assert(!collection.isEmpty());
    assert(collection.contains(entity1));
    
    auto retrieved = collection.get(entity1.id());
    assert(retrieved !is null);
    assert(retrieved.name() == "Entity 1");
    
    auto found = collection.findByName("Entity 2");
    assert(found !is null);
    assert(found.id() == entity2.id());
    
    entity1.setAttribute("type", "test");
    auto byAttr = collection.findByAttribute("type", "test");
    assert(byAttr.length == 1);
    
    collection.remove(entity1);
    assert(collection.count() == 1);
    
    writeln("UIMEntityCollection tests passed!");
}
