module uim.entities.events.beforeupdate;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * Event fired before an entity is updated
 */
@UseEvent("entity.beforeUpdate")
class EntityBeforeUpdateEvent : UIMEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.beforeUpdate");
        entity = e;
    }
}
