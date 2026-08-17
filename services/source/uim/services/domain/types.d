/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.domain.types;

import uim.services;

mixin(ShowModule!());

@safe:

struct UserId {
    mixin IdTemplate!UserId;
}
UserId[] toUserId(string[] ids) 
    => ids.map!UserId.array;

string[] toString(UserId[] ids)
    => ids.map!"a.value".array;

bool hasUserId(UserId[] ids, UserId id)
    => ids.canFind(id);

bool hasUserId(string[] ids, UserId id) 
    => ids.canFind(id.value);


struct GlobalAccountId {
    mixin IdTemplate!GlobalAccountId;
}
GlobalAccountId[] toGlobalAccountId(string[] ids) 
    => ids.map!GlobalAccountId.array;

string[] toString(GlobalAccountId[] ids)
    => ids.map!"a.value".array;

bool hasGlobalAccountId(GlobalAccountId[] ids, GlobalAccountId id)
    => ids.canFind(id);

bool hasGlobalAccountId(string[] ids, GlobalAccountId id)
    => ids.canFind(id.value);


struct SubaccountId {
    mixin IdTemplate!SubaccountId;
}
SubaccountId[] toSubaccountId(string[] ids) 
    => ids.map!SubaccountId.array;

string[] toString(SubaccountId[] ids) 
    => ids.map!"a.value".array;

bool hasSubaccountId(SubaccountId[] ids, SubaccountId id)
    => ids.canFind(id);

bool hasSubaccountId(string[] ids, SubaccountId id)
    => ids.canFind(id.value);


struct ApplicationId {
    mixin IdTemplate!ApplicationId;
}
ApplicationId[] toApplicationId(string[] ids)
    => ids.map!ApplicationId.array;

string[] toString(ApplicationId[] ids)
    => ids.map!"a.value".array;

bool hasApplicationId(ApplicationId[] ids, ApplicationId id)
    => ids.canFind(id);

bool hasApplicationId(string[] ids, ApplicationId id)
    => ids.canFind(id.value);


struct ConnectionId {
    mixin IdTemplate!ConnectionId;
}
ConnectionId[] toConnectionId(string[] ids)
    => ids.map!ConnectionId.array;

string[] toString(ConnectionId[] ids)
    => ids.map!"a.value".array;

bool hasConnectionId(ConnectionId[] ids, ConnectionId id)
    => ids.canFind(id);

bool hasConnectionId(string[] ids, ConnectionId id)
    => ids.canFind(id.value);


struct OrganizationId {
    mixin IdTemplate!OrganizationId;
}
OrganizationId[] toOrganizationId(string[] ids)
    => ids.map!OrganizationId.array;

string[] toString(OrganizationId[] ids)
    => ids.map!"a.value".array;

bool hasOrganizationId(OrganizationId[] ids, OrganizationId id)
    => ids.canFind(id);

bool hasOrganizationId(string[] ids, OrganizationId id)
    => ids.canFind(id.value);


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

