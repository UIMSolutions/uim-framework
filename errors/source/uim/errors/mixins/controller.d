/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.mixins.controller;

import uim.errors;

@safe:
string errorControllerThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "ErrorController";
    return objThis(fullName, overrideMemberNames);
}

template ErrorControllerThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorControllerThis = errorControllerThis(name, overrideMemberNames);
}

string errorControllerCalls(string name) {
    string fullName = name ~ "ErrorController";
    return objCalls(fullName);
}

template ErrorControllerCalls(string name) {
    const char[] ErrorControllerCalls = errorControllerCalls(name);
}
