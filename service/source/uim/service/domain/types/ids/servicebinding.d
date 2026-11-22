/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.servicebinding;

import uim.service;

mixin(ShowModule!());

@safe:

struct ServiceBindingId {
    mixin IdTemplate!ServiceBindingId;
}
ServiceBindingId[] toServiceBindingId(string[] ids)
    => ids.map!ServiceBindingId.array;

string[] toString(ServiceBindingId[] ids)
    => ids.map!"a.value".array;
