/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.manager;

import uim.entities;

mixin(ShowModule!());

@safe:

/**
 * Entity manager that coordinates entity lifecycle with events
 */
class UIMEntityManager : UIMObject {
    protected UIMEntityRepository _repository;
    protected UIMEntityValidator _validator;
    protected UIMEventDispatcher _eventDispatcher;
    
    this() {
        super();
        _repository = entityRepository();
        _eventDispatcher = EventDispatcher();
    }
    
    this(UIMEntityRepository repository) {
        super();
        _repository = repository;
        _eventDispatcher = EventDispatcher();
    }
    
    /**
     * Set validator for entities
     */
    UIMEntityManager validator(UIMEntityValidator val) {
        _validator = val;
        return this;
    }
    
    /**
     * Get event dispatcher
     */
    UIMEventDispatcher eventDispatcher() {
        return _eventDispatcher;
    }
    
    /**
     * Create a new entity with lifecycle events - optimized
     */
    IEntity create(IEntity entity) {
        // Fire before create event
        _eventDispatcher.dispatch(new EntityBeforeCreateEvent(entity));
        
        // Validate if validator is set
        bool validationPassed = true;
        if (_validator !is null) {
            validationPassed = _validator.validate(entity);
            _eventDispatcher.dispatch(new EntityValidateUIMEvent(entity, validationPassed));
            
            if (!validationPassed) {
                return entity; // Return without saving
            }
        }
        
        // Save entity
        _repository.save(entity);
        
        // Fire after create event
        _eventDispatcher.dispatch(new EntityAfterCreateEvent(entity));
        
        return entity;
    }
    
    /**
     * Update an existing entity with lifecycle events - optimized
     */
    IEntity update(IEntity entity) {
        // Fire before update event
        _eventDispatcher.dispatch(new EntityBeforeUpdateEvent(entity));
        
        // Validate if validator is set
        bool validationPassed = true;
        if (_validator !is null) {
            validationPassed = _validator.validate(entity);
            _eventDispatcher.dispatch(new EntityValidateUIMEvent(entity, validationPassed));
            
            if (!validationPassed) {
                return entity; // Return without saving
            }
        }
        
        // Save entity
        _repository.save(entity);
        
        // Fire after update event
        _eventDispatcher.dispatch(new EntityAfterUpdateEvent(entity));
        
        return entity;
    }
    
    /**
     * Delete an entity with lifecycle events
     */
    void remove(IEntity entity) {
        // Fire before delete event
        _eventDispatcher.dispatch(new EntityBeforeDeleteEvent(entity));
        
        // Remove entity
        _repository.remove(entity);
        
        // Fire after delete event
        _eventDispatcher.dispatch(new EntityAfterDeleteEvent(entity));
    }
    
    /**
     * Find entity by ID
     */
    IEntity find(UUID id) {
        return _repository.find(id);
    }
    
    /**
     * Find all entities
     */
    IEntity[] findAll() {
        return _repository.findAll();
    }
    
    /**
     * Find entity by name
     */
    IEntity findByName(string name) {
        return _repository.findByName(name);
    }
    
    /**
     * Find entities by attribute
     */
    IEntity[] findByAttribute(string key, string value) {
        return _repository.findByAttribute(key, value);
    }
    
    /**
     * Get repository
     */
    UIMEntityRepository repository() {
        return _repository;
    }
}

import std.uuid : UUID;

// Factory function
auto entityManager() {
    return new UIMEntityManager();
}

auto entityManager(UIMEntityRepository repository) {
    return new UIMEntityManager(repository);
}

unittest {
    writeln("Testing UIMEntityManager class...");
    
    auto manager = entityManager();
    
    // Test create with events
    bool beforeCreateCalled = false;
    bool afterCreateCalled = false;
    
    manager.eventDispatcher().on("entity.beforeCreate", (IEvent event) @trusted {
        beforeCreateCalled = true;
    });
    
    manager.eventDispatcher().on("entity.afterCreate", (IEvent event) @trusted {
        afterCreateCalled = true;
    });
    
    auto ent = entity("Test Entity");
    manager.create(ent);
    
    assert(beforeCreateCalled);
    assert(afterCreateCalled);
    writeln("Entity ID after creation: ", ent.id());
    writeln("Ent is Clean? " ~ ent.isClean().to!string);
    writeln("Entity is Clean? " ~ entity.isClean().to!string);
    
    // Test update with events
    bool beforeUpdateCalled = false;
    bool afterUpdateCalled = false;
    
    manager.eventDispatcher().on("entity.beforeUpdate", (IEvent event) @trusted {
        beforeUpdateCalled = true;
    });
    
    manager.eventDispatcher().on("entity.afterUpdate", (IEvent event) @trusted {
        afterUpdateCalled = true;
    });
    
    entity.setAttribute("updated", "yes");
    manager.update(entity);
    
    assert(beforeUpdateCalled);
    assert(afterUpdateCalled);
    
    writeln("UIMEntityManager tests passed!");
}
