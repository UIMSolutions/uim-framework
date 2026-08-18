module uim.core.vibe.http.request;

import uim.core;

mixin(ShowModule!());

@safe:

string idFromRequest(scope HTTPServerRequest req) {
    auto path = req.requestPath.to!string;
    auto idx = path.lastIndexOf('/');
    if (idx < 0 || idx + 1 >= path.length)
        return "";
    return path[idx + 1 .. $];
}

Json bodyFromRequest(scope HTTPServerRequest req) {
    return req.json;
}
