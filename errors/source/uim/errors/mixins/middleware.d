/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.mixins.middleware;

import uim.errors;

@safe:
string errorMiddlewareThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "ErrorMiddleware";
    return objThis(fullName, overrideMemberNames);
}

template ErrorMiddlewareThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorMiddlewareThis = errorMiddlewareThis(name, overrideMemberNames);
}

string errorMiddlewareCalls(string name) {
    string fullName = name ~ "ErrorMiddleware";
    return objCalls(fullName);
}

template ErrorMiddlewareCalls(string name) {
    const char[] ErrorMiddlewareCalls = errorMiddlewareCalls(name);
}
