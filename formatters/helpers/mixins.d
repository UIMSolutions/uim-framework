/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.mixins;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

string formatterThis(string name = null, bool overrideMemberNames = true) {
  string fullName = name ~ "Formatter";
  return objThis(fullName, overrideMemberNames);
}

template FormatterThis(string name = null, bool overrideMemberNames = true) {
  const char[] FormatterThis = formatterThis(name, overrideMemberNames);
}

string formatterCalls(string name) {
  string fullName = name ~ "Formatter";
  return objCalls(fullName);
}

template FormatterCalls(string name) {
  const char[] FormatterCalls = formatterCalls(name);
}
