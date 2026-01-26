module uim.entities.events.validated;

import uim.entities;

mixin(ShowModule!());

@safe:
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