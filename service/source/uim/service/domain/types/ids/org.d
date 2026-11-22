/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types.ids.org;

import uim.service;

mixin(ShowModule!());

@safe:

struct OrgId {
    mixin IdTemplate!OrgId;
}
OrgId[] toOrgId(string[] ids)
    => ids.map!(id => OrgId(id)).array;

string[] toString(OrgId[] ids) 
    => ids.map!"a.value".array;


