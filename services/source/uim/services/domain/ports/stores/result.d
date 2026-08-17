module uim.services.domain.ports.stores.result;

import uim.services;

mixin(ShowModule!());

@safe:

struct StoreResult {
    bool success;
    string message;
}