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
