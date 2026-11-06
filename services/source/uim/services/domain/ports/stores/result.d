module uim.service.domain.ports.stores.result;

import uim.service;

mixin(ShowModule!());

@safe:

struct StoreResult {
    bool success;
    string message;
}