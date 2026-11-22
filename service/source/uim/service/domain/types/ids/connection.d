/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types;

import uim.service;

mixin(ShowModule!());

@safe:

struct ConnectionId {
    mixin IdTemplate!ConnectionId;
}
ConnectionId[] toConnectionId(string[] ids)
    => ids.map!ConnectionId.array;

string[] toString(ConnectionId[] ids)
    => ids.map!"a.value".array;

///
unittest {
    ConnectionId[] ids = toConnectionId(["1", "2", "3"]);
    assert(hasId(ids, ConnectionId("1")));
    assert(!hasId(ids, ConnectionId("4")));
    assert(ids.hasId(ConnectionId("1")));
    assert(!ids.hasId(ConnectionId("4")));
    assert(hasId(["1", "2", "3"], ConnectionId("2")));
    assert(!hasId(["1", "2", "3"], ConnectionId("4")));
    assert(["1", "2", "3"].hasId(ConnectionId("2")));
    assert(!["1", "2", "3"].hasId(ConnectionId("4")));
}