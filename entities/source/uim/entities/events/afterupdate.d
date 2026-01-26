module uim.entities.events.afterupdate;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * Event fired after an entity is updated
 */
@UseEvent("entity.afterUpdate")
class EntityAfterUpdateEvent : UIMEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.afterUpdate");
        entity = e;
    }
}