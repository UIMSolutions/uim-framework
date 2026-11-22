/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.helper;

import uim.service;

mixin(ShowModule!());

@safe:

bool hasId(T)(T[] ids, T id)
    => ids.canFind(id);

bool hasId(T)(string[] ids, T id)
    => ids.canFind(id.value);

///
unittest {
    ApplicationId[] appIds = toApplicationId(["1", "2", "3"]);
    assert(hasId(appIds, ApplicationId("1")));
    assert(!hasId(appIds, ApplicationId("4")));
}