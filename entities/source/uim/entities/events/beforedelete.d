module uim.entities.events.beforedelete;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * Event fired before an entity is deleted
 */
@UseEvent("entity.beforeDelete")
class EntityBeforeDeleteEvent : UIMEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.beforeDelete");
        entity = e;
    }
}