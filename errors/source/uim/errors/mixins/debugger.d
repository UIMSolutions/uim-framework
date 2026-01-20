/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.errors.mixins.debugger;

import uim.errors;

@safe:
string errorDebuggerThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "ErrorDebugger";
    return objThis(fullName, overrideMemberNames);
}

template ErrorDebuggerThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorDebuggerThis = errorDebuggerThis(name, overrideMemberNames);
}

string errorDebuggerCalls(string name) {
    string fullName = name ~ "ErrorDebugger";
    return objCalls(fullName);
}

template ErrorDebuggerCalls(string name) {
    const char[] ErrorDebuggerCalls = errorDebuggerCalls(name);
}
