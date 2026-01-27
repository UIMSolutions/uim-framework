/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
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