/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
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