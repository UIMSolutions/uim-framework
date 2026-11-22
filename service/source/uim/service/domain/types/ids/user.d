/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.user;

import uim.service;

mixin(ShowModule!());

@safe:

/// Represents a user identifier.
struct UserId {
    mixin IdTemplate!UserId;
}
UserId[] toUserId(string[] ids) 
    => ids.map!UserId.array;

string[] toString(UserId[] ids)
    => ids.map!"a.value".array;

///
unittest {
    UserId[] userIds = toUserId(["1", "2", "3"]);
    assert(hasId(userIds, UserId("1")));
    assert(!hasId(userIds, UserId("4")));
    assert(hasId(["1", "2", "3"], UserId("2")));
    assert(!hasId(["1", "2", "3"], UserId("4")));
}