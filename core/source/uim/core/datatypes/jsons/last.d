/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UIManufaktur) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UIManufaktur)
*****************************************************************************************************************/
module uim.core.datatypes.jsons.last;

import uim.core;

mixin(ShowModule!());

@safe:

/*
Json last(Json json) {
  return json.isArray
    ? last(json.toArray) : Json(null);
}

Json lastObject(Json json) {
  return json.isArray
    ? last(json.toArray.filterObjects) : Json(null);
}

Json lastArray(Json json) {
  return json.isArray
    ? last(json.toArray.filterArrays) : Json(null);
}

Json lastScalar(Json json) {
  return json.isArray
    ? last(
      json.toArray.filterScalars) : Json(null);
}

Json lastBoolean(Json json) {
  return json.isArray
    ? last(
      json.toArray.filterBooleans) : Json(null);
}

Json lastInteger(Json json) {
  return json.isArray
    ? last(
      json.toArray.filterIntegers) : Json(null);
}

Json lastDouble(Json json) {
  return json.isArray
    ? last(
      json.toArray.filterDoubles) : Json(null);
}

Json lastString(Json json) {
  return json.isArray
    ? last(
      json.toArray.filterStrings) : Json(null);
}

/* 
Json lastWithAllKey(Json json, string[] keys) {
  return json.isArray
    ? last(json.toArray.filterhasAllKey(keys)) : Json(null);
}

Json lastWithAnyKey(Json json, string[] keys) {
  return json.isArray
    ? last(json.toArray.filterhasAnyKey(keys)) : Json(null);
}

Json lastHasKey(Json json, string key) {
  return json.isArray
    ? last(json.toArray.filterHasKey(key)) : Json(null);
}
*/
