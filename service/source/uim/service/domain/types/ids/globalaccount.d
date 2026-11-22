/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.globalaccount;

import uim.service;

mixin(ShowModule!());

@safe:

/// Represents a global account identifier.
struct GlobalAccountId {
    mixin IdTemplate!GlobalAccountId;
}
GlobalAccountId[] toGlobalAccountId(string[] ids) 
    => ids.map!GlobalAccountId.array;

string[] toString(GlobalAccountId[] ids)
    => ids.map!"a.value".array;

///
unittest {
    auto id = GlobalAccountId("XXX");
    assert(id.value == "XXX");
    assert(toGlobalAccountId(["XXX"])[0] == id);
    assert(toString([id])[0] == "XXX");
    assert(hasGlobalAccountId([id], id));
    assert(hasGlobalAccountId(["XXX"], id));
}