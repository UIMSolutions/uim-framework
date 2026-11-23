module uim.service.infrastructure.tests.store;

import uim.service;

mixin(ShowModule!());

@safe:

bool testStore() {
    return true;
}

bool testIdStore() {
    return true;
}

bool testTenantStore(TEntity, TId)(ITenantStore!(TEntity, TId) store) {
    return true;
}