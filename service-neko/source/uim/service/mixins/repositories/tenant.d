module uim.service.mixins.repositories.tenant;

import uim.service;

mixin(ShowModule!());

@safe:
template TenantRepositoryTemplate(alias Repository, TEntity, TId) {
	this() {
		super();
	}

    this(ITenantStore!(TEntity, TId) store) {
        super(store);
    }
}