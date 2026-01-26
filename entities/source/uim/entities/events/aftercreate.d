module uim.entities.events.aftercreate;

import uim.entities;

mixin(ShowModule!());

@safe:
/**
 * Event fired after an entity is created
 */
@UseEvent("entity.afterCreate")
class EntityAfterCreateEvent : UIMEvent {
    IEntity entity;
    
    this(IEntity e) {
        super("entity.afterCreate");
        entity = e;
    }
}