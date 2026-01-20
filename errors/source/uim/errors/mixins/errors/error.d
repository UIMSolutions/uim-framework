/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.mixins.errors.error;

import uim.errors;

@safe:
string errorThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "Error";
    return objThis(fullName, overrideMemberNames);
}

template ErrorThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorThis = errorThis(name, overrideMemberNames);
}

string errorCalls(string name) {
    string fullName = name ~ "Error";
    return objCalls(fullName);
}

template ErrorCalls(string name) {
    const char[] ErrorCalls = errorCalls(name);
}
