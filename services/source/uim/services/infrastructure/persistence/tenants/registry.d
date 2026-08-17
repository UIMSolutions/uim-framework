module uim.services.infrastructure.persistence.tenants.registry;

import uim.services;

mixin(ShowModule!());

@safe:
 
class StoreTenantTegistry {
    private StoreTenant[TenantId] _tenants;

    /// Register store
    void register(TenantId id, StoreTenant tenant) {
        _tenants[id] = tenant;
    }

    void remove(TenantId id) {
        _tenants.remove(id);
    }

    StoreTenant tenant(A, B)(TenantId id) {
        return (id in _tenants) ? _tenants[id] : null;
    }
}

