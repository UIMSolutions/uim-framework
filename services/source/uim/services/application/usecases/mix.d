/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.services.application.usecases.mix;

import uim.services;

mixin(ShowModule!());

@safe:

@safe:
string usecaseThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "Usecase";
    return objThis(fullName, overrideMemberNames);
}

template UsecaseThis(string name = null, bool overrideMemberNames = true) {
    const char[] UsecaseThis = usecaseThis(name, overrideMemberNames);
}

string usecaseCalls(string name) {
    string fullName = name ~ "Usecase";
    return objCalls(fullName);
}

template UsecaseCalls(string name) {
    const char[] UsecaseCalls = usecaseCalls(name);
}
