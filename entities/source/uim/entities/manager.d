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
class DEntityManager : UIMObject {
    protected DEntityRepository _repository;
    protected DEntityValidator _validator;
    protected DEventDispatcher _eventDispatcher;
    
    this() {
        super();
        _repository = EntityRepository();
        _eventDispatcher = EventDispatcher();
    }
    
    this(DEntityRepository repository) {
        super();
        _repository = repository;
        _eventDispatcher = EventDispatcher();
    }
    
    /**
     * Set validator for entities
     */
    DEntityManager validator(DEntityValidator val) {
        _validator = val;
        return this;
    }
    
    /**
     * Get event dispatcher
     */
    DEventDispatcher eventDispatcher() {
        return _eventDispatcher;
    }
    
    /**
     * Create a new entity with lifecycle events - optimized
     */
    IEntity create(IEntity entity) {\n        // Fire before create event\n        _eventDispatcher.dispatch(new EntityBeforeCreateEvent(entity));\n        \n        // Validate if validator is set\n        bool validationPassed = true;\n        if (_validator !is null) {\n            validationPassed = _validator.validate(entity);\n            _eventDispatcher.dispatch(new EntityValidatedEvent(entity, validationPassed));\n            \n            if (!validationPassed) {\n                return entity; // Return without saving\n            }\n        }\n        \n        // Save entity\n        _repository.save(entity);\n        \n        // Fire after create event\n        _eventDispatcher.dispatch(new EntityAfterCreateEvent(entity));\n        \n        return entity;\n    }\n    \n    /**\n     * Update an existing entity with lifecycle events - optimized\n     */\n    IEntity update(IEntity entity) {\n        // Fire before update event\n        _eventDispatcher.dispatch(new EntityBeforeUpdateEvent(entity));\n        \n        // Validate if validator is set\n        bool validationPassed = true;\n        if (_validator !is null) {\n            validationPassed = _validator.validate(entity);\n            _eventDispatcher.dispatch(new EntityValidatedEvent(entity, validationPassed));\n            \n            if (!validationPassed) {\n                return entity; // Return without saving\n            }\n        }\n        \n        // Save entity\n        _repository.save(entity);\n        \n        // Fire after update event\n        _eventDispatcher.dispatch(new EntityAfterUpdateEvent(entity));\n        \n        return entity;\n    }
    
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
    DEntityRepository repository() {
        return _repository;
    }
}

import std.uuid : UUID;

// Factory function
auto EntityManager() {
    return new DEntityManager();
}

auto EntityManager(DEntityRepository repository) {
    return new DEntityManager(repository);
}

unittest {
    writeln("Testing DEntityManager class...");
    
    auto manager = EntityManager();
    
    // Test create with events
    bool beforeCreateCalled = false;
    bool afterCreateCalled = false;
    
    manager.eventDispatcher().on("entity.beforeCreate", (IEvent event) @trusted {
        beforeCreateCalled = true;
    });
    
    manager.eventDispatcher().on("entity.afterCreate", (IEvent event) @trusted {
        afterCreateCalled = true;
    });
    
    auto entity = uim.entities.entity.Entity("Test Entity");
    manager.create(entity);
    
    assert(beforeCreateCalled);
    assert(afterCreateCalled);
    assert(entity.isClean());
    
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
    
    writeln("DEntityManager tests passed!");
}
