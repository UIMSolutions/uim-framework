/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.patterns.commands.helpers.mixins;

import uim.oop;

mixin(ShowModule!());

@safe:

string commandThis(string name = null, bool overrideMemberNames = true) {
    string fullName = name ~ "Command";
    return objThis(fullName, overrideMemberNames);
}

template CommandThis(string name = null, bool overrideMemberNames = true) {
    const char[] CommandThis = commandThis(name, overrideMemberNames);
}

string commandCalls(string name) {
    string fullName = name ~ "Command";
    return objCalls(fullName);
}

template CommandCalls(string name) {
    const char[] CommandCalls = commandCalls(name);
}
