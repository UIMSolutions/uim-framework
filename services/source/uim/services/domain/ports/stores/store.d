module uim.service.domain.ports.stores.store;

import uim.service;

mixin(ShowModule!());

@safe:

interface IStore {

    size_t count();

}