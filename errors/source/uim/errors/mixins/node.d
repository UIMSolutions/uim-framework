/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.mixins.node;

import uim.errors;

@safe:
string errorNodeThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "ErrorNode";
    return objThis(fullName, overrideMemberNames);
}

template ErrorNodeThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorNodeThis = errorNodeThis(name, overrideMemberNames);
}

string errorNodeCalls(string name) {
    string fullName = name ~ "ErrorNode";
    return objCalls(fullName);
}

template ErrorNodeCalls(string name) {
    const char[] ErrorNodeCalls = errorNodeCalls(name);
}
