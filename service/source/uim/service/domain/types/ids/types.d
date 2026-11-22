/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.domain.types;

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

bool hasOrgId(OrgId[] ids, OrgId id)
    => ids.canFind(id);

bool hasOrgId(string[] ids, OrgId id)
    => ids.canFind(id.value);

struct ServiceBindingId {
    mixin IdTemplate!ServiceBindingId;
}
ServiceBindingId[] toServiceBindingId(string[] ids)
    => ids.map!ServiceBindingId.array;

string[] toString(ServiceBindingId[] ids)
    => ids.map!"a.value".array;

bool hasServiceBindingId(ServiceBindingId[] ids, ServiceBindingId id)
    => ids.canFind(id);
    
bool hasServiceBindingId(string[] ids, ServiceBindingId id)
    => ids.canFind(id.value);


struct SpaceId {
    mixin IdTemplate!SpaceId;
}
SpaceId[] toSpaceId(string[] ids)
    => ids.map!SpaceId.array;

string[] toString(SpaceId[] ids)
    => ids.map!"a.value".array;

bool hasSpaceId(SpaceId[] ids, SpaceId id)
    => ids.canFind(id);

bool hasSpaceId(string[] ids, SpaceId id)
    => ids.canFind(id.value);

struct TenantId {
    mixin IdTemplate!TenantId;
}
TenantId[] toTenantId(string[] ids)
    => ids.map!TenantId.array;

string[] toString(TenantId[] ids)
    => ids.map!"a.value".array;

bool hasTenantId(TenantId[] ids, TenantId id)
    => ids.canFind(id);

bool hasTenantId(string[] ids, TenantId id)
    => ids.canFind(id.value);

///
unittest {
    // auto id = TenantId("XXX");
    // writeln(id);
    // writeln(id.toJson);
    // writeln(TenantId.fromJson(id.toJson));
}

struct ServiceInstanceId {
    mixin IdTemplate!ServiceInstanceId;
}
ServiceInstanceId[] toServiceInstanceId(string[] ids) {
    return ids.map!ServiceInstanceId.array;
}
string[] toString(ServiceInstanceId[] ids) {
    return ids.map!"a.value".array;
}
bool hasServiceInstanceId(ServiceInstanceId[] ids, ServiceInstanceId id)
    => ids.canFind(id);

bool hasServiceInstanceId(string[] ids, ServiceInstanceId id)
    => ids.canFind(id.value);

