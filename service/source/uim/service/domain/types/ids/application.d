/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.application;

import uim.service;

mixin(ShowModule!());

@safe:

struct ApplicationId {
    mixin IdTemplate!ApplicationId;
}
ApplicationId[] toApplicationId(string[] ids)
    => ids.map!ApplicationId.array;

string[] toString(ApplicationId[] ids)
    => ids.map!"a.value".array;

///
unittest {
    ApplicationId[] appIds = toApplicationId(["1", "2", "3"]);
    assert(hasId(appIds, ApplicationId("1")));
    assert(!hasId(appIds, ApplicationId("4")));
    assert(appIds.hasId(ApplicationId("1")));
    assert(!appIds.hasId(ApplicationId("4")));
    assert(hasId(["1", "2", "3"], ApplicationId("2")));
    assert(!hasId(["1", "2", "3"], ApplicationId("4")));
    assert(["1", "2", "3"].hasId(ApplicationId("2")));
    assert(!["1", "2", "3"].hasId(ApplicationId("4")));
}