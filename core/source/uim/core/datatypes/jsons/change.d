module uim.core.datatypes.jsons.change;

import uim.core;

mixin(ShowModule!());

@safe:

/** 
  * Update the Json object with another Json object.
  *
  * Params:
  *   json = The JSON object to update.
  *   map = The JSON object containing key-value pairs to set in the original JSON object.
  *
  * Returns:
  *   The updated JSON object.
  */
Json update(Json json, Json updateMap) {
  if (!json.isObject || !updateMap.isObject) {
    return json;
  }

  foreach (key, value; updateMap.byKeyValue) {
    json = json.update(key, value);
  }
  return json;
}

/** 
  * Update the Json object with a string-keyed associative array.
  *
  * Params:
  *   json = The JSON object to update.
  *   values = An associative array of string keys and values to set in the JSON object.
  *
  * Returns:
  *   The updated JSON object.
  */
Json update(Json json, Json[string] map) {
  if (!json.isObject) {
    return json;
  }

  foreach (key, value; map) {
    json = json.update(key, value);
  }

  return json;
}

/** 
  * Update the Json object at the specified keys with the given value.
  *
  * Params:
  *   json = The JSON object to update.
  *   keys = An array of keys representing the keys to update.
  *   value = The value to set at the specified keys.
  *
  * Returns:
  *   The updated JSON object.
  */
Json update(Json json, string[] keys, Json value) {
  if (!json.isObject) {
    return json;
  }

  keys.each!(key => json.update(key, value));
  return json;
}

Json update(Json json, string key, Json value) {
  Json result  = json;
  if (result.isObject && result.hasKey(key)) {
    result[key] = value;
  }
  return result;
}