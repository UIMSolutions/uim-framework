module uim.service.helpers.request;

import uim.service;

mixin(ShowModule!());

@safe:
TenantId tenantFromRequest(scope HTTPServerRequest req) {
    return TenantId("default");
}