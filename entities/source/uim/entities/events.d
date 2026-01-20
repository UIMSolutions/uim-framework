/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.events;

import uim.core;
import uim.events;
import uim.entities.entity;

@safe:

/**
 * Entity lifecycle events
 */

/**
 * Event fired before an entity is created
 */
@Event("entity.beforeCreate")
class EntityBeforeCreateEvent : DEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.beforeCreate");
        entity = e;
    }
}

/**
 * Event fired after an entity is created
 */
@Event("entity.afterCreate")
class EntityAfterCreateEvent : DEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.afterCreate");
        entity = e;
    }
}

/**
 * Event fired before an entity is updated
 */
@Event("entity.beforeUpdate")
class EntityBeforeUpdateEvent : DEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.beforeUpdate");
        entity = e;
    }
}

/**
 * Event fired after an entity is updated
 */
@Event("entity.afterUpdate")
class EntityAfterUpdateEvent : DEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.afterUpdate");
        entity = e;
    }
}

/**
 * Event fired before an entity is deleted
 */
@Event("entity.beforeDelete")
class EntityBeforeDeleteEvent : DEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.beforeDelete");
        entity = e;
    }
}

/**
 * Event fired after an entity is deleted
 */
@Event("entity.afterDelete")
class EntityAfterDeleteEvent : DEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.afterDelete");
        entity = e;
    }
}

/**
 * Event fired when an entity is validated
 */
@Event("entity.validated")
class EntityValidatedEvent : DEvent {
    IEntity entity;
    bool isValid;
    
    this(IEntity e, bool valid) {
        super("entity.validated");
        entity = e;
        isValid = valid;
    }
}

/**
 * Event fired when entity state changes
 */
@Event("entity.stateChanged")
class EntityStateChangedEvent : DEvent {
    IEntity entity;
    EntityState oldState;
    EntityState newState;
    
    this(IEntity e, EntityState old, EntityState current) {
        super("entity.stateChanged");
        entity = e;
        oldState = old;
        newState = current;
    }
}

unittest {
    writeln("Testing entity events...");
    
    auto entity = uim.entities.entity.Entity("Test");
    auto event = new EntityAfterCreateEvent(entity);
    
    assert(event.entity !is null);
    assert(event.name() == "entity.afterCreate");
    
    writeln("✓ Entity events tests passed!");
}
