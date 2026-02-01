/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.oop.formatters.interfaces;

import uim.oop;

mixin(ShowModule!());

@safe:


interface IFormatter : IObject {
  string format(string input, Json[string] options = null);
}
