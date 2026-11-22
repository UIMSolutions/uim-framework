/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.organization;

import uim.service;

mixin(ShowModule!());

@safe:

struct OrganizationId {
    mixin IdTemplate!OrganizationId;
}
OrganizationId[] toOrganizationId(string[] ids)
    => ids.map!OrganizationId.array;

string[] toString(OrganizationId[] ids)
    => ids.map!"a.value".array;

