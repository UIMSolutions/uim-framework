module uim.services.presentation.http.helpers.uuid.id;

import uim.core;

mixin(ShowModule!());

@safe:
UUID newUUID() {
    return randomUUID();
}

string newId() {
    return newUUID.to!string;
}