module uim.entities.events.afterdelete;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * Event fired after an entity is deleted
 */
@UseEvent("entity.afterDelete")
class EntityAfterDeleteEvent : UIMEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.afterDelete");
        entity = e;
    }
}