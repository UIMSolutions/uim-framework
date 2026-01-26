/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.events;

import uim.entities;
import uim.events;

mixin(ShowModule!());

@safe:


/**
 * Entity lifecycle events
 */












/**
 * Event fired when an entity is validated
 */
@UseEvent("entity.validated")
class EntityValidateUIMEvent : UIMEvent {
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
@UseEvent("entity.stateChanged")
class EntityStateChangeEvent : UIMEvent {
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
