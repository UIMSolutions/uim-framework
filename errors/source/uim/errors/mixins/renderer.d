/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.mixins.renderer;

import uim.errors;

@safe:
string errorRendererThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "ErrorRenderer";
    return objThis(fullName, overrideMemberNames);
}

template ErrorRendererThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorRendererThis = errorRendererThis(name, overrideMemberNames);
}

string errorRendererCalls(string name) {
    string fullName = name ~ "ErrorRenderer";
    return objCalls(fullName);
}

template ErrorRendererCalls(string name) {
    const char[] ErrorRendererCalls = errorRendererCalls(name);
}
