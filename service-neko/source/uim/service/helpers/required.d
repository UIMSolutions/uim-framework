/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.required;

import uim.service;

mixin(ShowModule!());

@safe:

UUID requiredUUID(Json request, string key) {
  requiredKey(request, key);
  requiredStringType(request, key);

  auto value = request[key].getString;
  if (value.length == 0 || !value.isUUID) {
    throw new UIMValidationException(key ~ " must be a valid UUID");
  }

  return UUID(value);
}

/**
  * Validates that the specified key exists in the JSON object and is a non-empty string.
  * Returns the string value if valid, otherwise throws UIMValidationException.
  */
string requiredString(Json data, string key) {
  requiredKey(data, key);
  requiredStringType(data, key);

  auto value = data[key].getString;
  if (value.length == 0) {
    throw new UIMValidationException(key ~ " cannot be empty");
  }

  return value;
}

void requiredBooleanType(Json data, string key) {
  if (!data[key].isBoolean) {
    throw new UIMValidationException(key ~ " must be a boolean");
  }
}

void requiredStringType(Json data, string key) {
  if (!data[key].isString) {
    throw new UIMValidationException(key ~ " must be string");
  }
}

void requiredArrayType(Json data, string key) {
  if (!data[key].isArray) {
    throw new UIMValidationException(key ~ " must be array");
  }
}

void requiredObjectType(Json data, string key) {
  if (!data[key].isObject) {
    throw new UIMValidationException(key ~ " must be object");
  }
}

void requiredKey(Json data, string key) {
  if (!(key in data)) {
    throw new UIMValidationException(key ~ " is required");
  }
}
