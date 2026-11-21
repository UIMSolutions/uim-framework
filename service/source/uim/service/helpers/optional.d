/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.optional;

import uim.service;

mixin(ShowModule!());

@safe:

bool optionalBoolean(Json data, string key, bool fallback) {
  if (!(key in data) || data[key].isNull)
    return fallback;

  requiredBooleanType(data, key);
  return data[key].get!bool;
}

string optionalString(Json data, string key, string fallback) {
  if (!(key in data) || data[key].isNull)
    return fallback;

  requiredStringType(data, key);
  return data[key].getString;
}

Json optionalObject(Json data, string key, Json fallback = Json.emptyObject) {
  if (!(key in data) || data[key].isNull) {
    return fallback;
  }

  requiredObjectType(data, key);
  return data[key];
}
