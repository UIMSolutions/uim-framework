/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.read;

import uim.service;

mixin(ShowModule!());

@safe:

private SysTime epochTime() nothrow @trusted {
  static bool initialized;
  static SysTime cached;
  if (!initialized) {
    try cached = SysTime.fromISOExtString("1970-01-01T00:00:00Z"); catch (Exception) {}
    initialized = true;
  }
  return cached;
}

SysTime parseTime(string value) {
  try
  {
    return SysTime.fromISOExtString(value);
  }
  catch (Exception) {
    return epochTime;
  }
}

SysTime readTime(Json item, string key) {
  return !(key in item) || !item[key].isString
    ? epochTime : parseTime(item[key].get!string);
}

string[] readStringArray(Json data, string key) {
  if (!(key in data) || data[key].isNull)
    return null;

  requiredArrayType(data, key);

  auto arr = data[key].toArray;
  auto result = appender!(string[]);
  result.reserve(arr.length);

  foreach (item; arr) {
    if (!item.isString)
      throw new UIMValidationException(key ~ " must contain strings");

    result ~= item.getString;
  }
  return result[];
}
/// 
unittest {
  Json data = parseJsonString(`{"names": ["Alice", "Bob", "Charlie"]}`);
  string[] names = readStringArray(data, "names");
  assert(names.length == 3);
  assert(names[0] == "Alice");
  assert(names[1] == "Bob");
  assert(names[2] == "Charlie");

  Json data2 = parseJsonString(`{"timestamp": "2024-01-01T12:00:00Z"}`);
  SysTime time = readTime(data2, "timestamp");
  assert(time.toISOExtString == "2024-01-01T12:00:00Z");
}

Json readObject(Json data, string key, Json fallback = Json.emptyObject) {
  if (!(key in data) || data[key].isNull) {
    return fallback;
  }

  requiredObjectType(data, key);
  return data[key];
}
