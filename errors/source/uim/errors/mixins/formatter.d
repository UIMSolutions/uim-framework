/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.errors.mixins.formatter;

import uim.errors;

@safe:
string errorFormatterThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "ErrorFormatter";
    return objThis(fullName, overrideMemberNames);
}

template ErrorFormatterThis(string name = null, bool overrideMemberNames = true) {
    const char[] ErrorFormatterThis = errorFormatterThis(name, overrideMemberNames);
}

string errorFormatterCalls(string name) {
    string fullName = name ~ "ErrorFormatter";
    return objCalls(fullName);
}

template ErrorFormatterCalls(string name) {
    const char[] ErrorFormatterCalls = errorFormatterCalls(name);
}
