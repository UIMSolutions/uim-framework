module uim.core.datatypes.uuids.convert;

import uim.core;

mixin(ShowModule!());

@safe:

string[] toString(UUID[] ids) {
  auto result = new string[ids.length];
  foreach (i, id; ids)
    result[i] = id.toString;
  return result;
}

unittest {
  /// TODO
}

string[] toStringCompact(UUID[] ids) {
  auto result = new string[ids.length];
  foreach (i, id; ids)
    result[i] = id.toStringCompact;
  return result;
}

string toStringCompact(UUID id) {
  return id.toString.replace("_", "");
}

unittest {
  /// TODO
}

UUID[] toUUID(string[] ids) {
  auto result = new UUID[ids.length];
  foreach (i, id; ids)
    result[i] = toUUID(id);
  return result;
}

UUID toUUID(string id) {
  import std.string;

  // TODO strip quotes
  // if ((id.indexOf("'") == 0) || (id.indexOf(`"`) == 0)) 

  return UUID(id.strip);
}
///
unittest {
  /// TODO
}

/** 
UUID toUUID(string key, Json json) {
  return json.isObject
    ? UUID(json.getString(key)) : UUID();
}


UUID toUUID(Json value) {
  return value.isString
    ? UUID(value.getString) : UUID();
}

unittest {
  assert(toUUID(Json()) == UUID());
  assert(toUUID(Json("00000000-0000-0000-0000-000000000000")) == UUID());

  auto id = randomUUID;
  assert(Json(id.toString).toUUID == id);
}
**/ 