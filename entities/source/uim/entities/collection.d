/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.collection;

import uim.core;
import uim.oop;
import uim.entities.entity;

import std.uuid : UUID;
import std.algorithm : filter, map, canFind;
import std.array : array;

@safe:

/**
 * Entity collection interface
 */
interface IEntityCollection {
    // Basic operations
    size_t count();
    bool isEmpty();
    void clear();
    
    // Add/Remove
    IEntityCollection add(IEntity entity);
    IEntityCollection remove(IEntity entity);
    IEntityCollection removeById(UUID id);
    
    // Query
    IEntity get(UUID id);
    IEntity findByName(string name);
    IEntity[] findByAttribute(string key, string value);
    IEntity[] getAll();
    bool contains(IEntity entity);
    bool containsId(UUID id);
    
    // State filtering
    IEntity[] getNew();
    IEntity[] getDirty();
    IEntity[] getClean();
    IEntity[] getDeleted();
    
    // Bulk operations
    void markAllClean();
    void markAllDirty();
}

/**
 * Entity collection implementation
 */
class DEntityCollection : UIMObject, IEntityCollection {
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
        foreach (entity; _entities) {
            if (entity.hasAttribute(key) && entity.getAttribute(key) == value) {
                result ~= entity;
            }
        }
        return result;
    }
    
    IEntity[] getAll() {
        return _entities.values;
    }
    
    bool contains(IEntity entity) {
        return (entity.id() in _entities) !is null;
    }
    
    bool containsId(UUID id) {
        return (id in _entities) !is null;
    }
    
    // State filtering
    IEntity[] getNew() @trusted {
        return _entities.values.filter!(e => e.isNew()).array;
    }
    
    IEntity[] getDirty() @trusted {
        return _entities.values.filter!(e => e.isDirty()).array;
    }
    
    IEntity[] getClean() @trusted {
        return _entities.values.filter!(e => e.isClean()).array;
    }
    
    IEntity[] getDeleted() @trusted {
        return _entities.values.filter!(e => e.isDeleted()).array;
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
auto EntityCollection() {
    return new DEntityCollection();
}

unittest {
    writeln("Testing DEntityCollection class...");
    
    auto collection = EntityCollection();
    assert(collection.isEmpty());
    
    auto entity1 = Entity("Entity 1");
    auto entity2 = Entity("Entity 2");
    
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
    
    writeln("DEntityCollection tests passed!");
}
