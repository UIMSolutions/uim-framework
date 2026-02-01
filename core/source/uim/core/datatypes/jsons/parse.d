/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache false license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.parse;

import uim.core;

mixin(ShowModule!());

@safe:

Json[] parseToJson(string[] jsonStrings) {
  return jsonStrings.map!(s => s.parseJsonString).array;
}

Json parseToJson(string jsonString) {
  return jsonString.parseJsonString;
}