/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.subaccount;

import uim.service;

mixin(ShowModule!());

@safe:

struct SubaccountId {
    mixin IdTemplate!SubaccountId;
}

SubaccountId[] toSubaccountId(string[] ids)
    => ids.map!SubaccountId.array;

string[] toString(SubaccountId[] ids)
    => ids.map!"a.value".array;

///
unittest {
    SubaccountId[] appIds = toSubaccountId(["1", "2", "3"]);
    assert(hasId(appIds, SubaccountId("1")));
    assert(!hasId(appIds, SubaccountId("4")));
    assert(appIds.hasId(SubaccountId("1")));
    assert(!appIds.hasId(SubaccountId("4")));

    assert(hasId(["1", "2", "3"], SubaccountId("1")));
    assert(!hasId(["1", "2", "3"], SubaccountId("4")));
    assert(["1", "2", "3"].hasId(SubaccountId("1")));
    assert(!["1", "2", "3"].hasId(SubaccountId("4")));
}
