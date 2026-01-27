/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.entities.tests.events;

import uim.entities;

mixin(ShowModule!());

@safe:

unittest {
    writeln("Testing entity events...");
    
    auto ent = entity("Test");
    auto event = new EntityAfterCreateEvent(ent);
    
    assert(event.entity !is null);
    assert(event.name() == "entity.afterCreate");
    
    writeln("✓ Entity events tests passed!");
}
