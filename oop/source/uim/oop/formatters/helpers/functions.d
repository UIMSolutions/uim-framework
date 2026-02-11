/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.formatters.helpers.functions;

import uim.oop;

mixin(ShowModule!());

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

auto Null(V:Formatter)() {
  return null;
}