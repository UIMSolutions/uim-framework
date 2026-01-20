/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.types.booleans.convert;

import uim.core;

mixin(ShowModule!());

@safe:

bool toBoolean(Json json, size_t index) {
  return json.isBoolean(index) ? json.to!bool : false;
}

bool toBoolean(Json json, string key) {
  return json.isBoolean(key) ? json.to!bool : false;
}

bool toBoolean(Json json) {
  return json.isBoolean ? json.to!bool : false;
}