/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.functions;

import uim.oop;

mixin(Version!"test_uim_oop");

@safe:

bool isFormatter(IObject obj) {
  if (obj is null) {
    return false;
  }
  return cast(IFormatter)obj !is null;
}

auto Null(V:IFormatter)() {
  return null;
}

auto Null(V:DFormatter)() {
  return null;
}