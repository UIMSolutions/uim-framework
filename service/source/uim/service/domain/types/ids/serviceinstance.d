/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.serviceinstance;

import uim.service;

mixin(ShowModule!());

@safe:

struct ServiceInstanceId {
    mixin IdTemplate!ServiceInstanceId;
}
ServiceInstanceId[] toServiceInstanceId(string[] ids) {
    return ids.map!ServiceInstanceId.array;
}
string[] toString(ServiceInstanceId[] ids) {
    return ids.map!"a.value".array;
}

