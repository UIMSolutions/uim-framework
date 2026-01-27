/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
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