module uim.entities.events.statechanged;

import uim.entities;

mixin(ShowModule!());

@safe:
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
