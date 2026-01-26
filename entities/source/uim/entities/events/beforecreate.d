module uim.entities.events.beforecreate;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * Event fired before an entity is created
 */
@UseEvent("entity.beforeCreate")
class EntityBeforeCreateEvent : UIMEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.beforeCreate");
        entity = e;
    }
}