module uim.services.domain.ports.stores.store;

import uim.services;

mixin(ShowModule!());

@safe:

interface IStore {

    size_t count();

}