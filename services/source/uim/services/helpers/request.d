module uim.services.helpers.request;

import uim.services;

mixin(ShowModule!());

@safe:
TenantId tenantFromRequest(scope HTTPServerRequest req) {
    return TenantId("default");
}