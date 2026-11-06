/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.presentation.http.helpers.json.reader;

import uim.core;

mixin(ShowModule!());

@safe:

string id(Json data) {
    return data.getString("id");
}

Json data(Json data) {
  return "data" in data && data["data"].isObject 
    ? data["data"] : Json.emptyObject;
}

string[string] params(Json data) {
  if ("params" !in data || !data["params"].isObject) return null;

  string[string] result;
  foreach (key, value; data["params"].byKeyValue) {
    result[key] = value.toString;
  }
  return result;
}

string[string] query(Json data) {
  if ("params" !in data || !data["params"].isObject) return null;

  string[string] result;
  foreach (key, value; data["query"].byKeyValue) {
    result[key] = value.toString;
  }
  return result;
}
