/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*) 
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file. 
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.service.helpers.helper;

import std.process : environment;
import std.uuid : randomUUID;

import std.datetime : Clock;
import uim.service;

mixin(ShowModule!());

@safe:

string createId() {
  return generateId;
}

string envOr(string key, string fallback) {
  auto value = environment.get(key, "");
  return value.length > 0 ? value : fallback;
}

ushort readPort(string value, ushort fallback) {
  try {
    auto parsed = to!ushort(value);
    return parsed > 0 ? parsed : fallback;
  } catch (Exception) {
    return fallback;
  }
}

bool readBool(string value, bool fallback) {
  auto normalized = value.toLower;

  if (normalized == "1" || normalized == "true" || normalized == "yes" || normalized == "y") {
    return true;
  }
  if (normalized == "0" || normalized == "false" || normalized == "no" || normalized == "n") {
    return false;
  }
  return fallback;
}
///
unittest {
  assert(readBool("TRUE", false) == true);
  assert(readBool("False", true) == false);
  assert(readBool("YES", false) == true);
  assert(readBool("n", true) == false);
  assert(readBool("1", false) == true);
  assert(readBool("0", true) == false);
  assert(readBool("maybe", true) == true);
  assert(readBool("maybe", false) == false);
}

string[] stringArrayFromJson(Json values) {
  return values.toArray
    .filter!(v => v.isString)
    .map!(v => v.get!string)
    .array;
}

int readInt(string value, int fallback) {
  try {
    auto parsed = to!int(value);
    return parsed > 0 ? parsed : fallback;
  } catch (Exception) {
    return fallback;
  }
}

double readDouble(string value, double fallback) {
  try {
    auto parsed = to!double(value);
    return parsed > 0 ? parsed : fallback;
  } catch (Exception) {
    return fallback;
  }
}

size_t readSize(string value, size_t fallback) {
  try {
    auto parsed = to!size_t(value);
    return parsed > 0 ? parsed : fallback;
  } catch (Exception) {
    return fallback;
  }
}
/// Cosine-similarity between two attribute maps (simple text-match version).
/// Returns a value between 0.0 and 1.0.
double attributeSimilarity(const string[string] a, const string[string] b) {
  if (a.length == 0 || b.length == 0)
    return 0.0;
  size_t matches = 0;
  size_t total = 0;
  foreach (k, v; a) {
    if (k in b) {
      total++;
      if (b[k] == v)
        matches++;
    } else {
      total++;
    }
  }
  foreach (k, v; b) {
    if (k !in a)
      total++;
  }
  if (total == 0)
    return 0.0;
  return cast(double)matches / cast(double)total;
}
/// Simple text-relevance score (case-insensitive substring match).
double textRelevance(string text, string query) {
  

  if (query.length == 0)
    return 0.0;
  auto lt = text.toLower;
  auto lq = query.toLower;
  if (lt == lq)
    return 1.0;
  // import std.algorithm : canFind;

  if (lt.canFind(lq))
    return 0.6;
  return 0.0;
}

string nowTimestamp() {
  try {
    return Clock.currTime(UTC()).toISOExtString;
  } catch (Exception) {
    return "1970-01-01T00:00:00Z";
  }
}

string optionalString(Json request, string key, string fallback) {
  if (key in request && request[key].isString) {
    auto value = request[key].getString;
    return value.length > 0 ? value : fallback;
  }
  return fallback;
}

string[] stringArray(Json request, string key) {
  string[] values;
  if (!(key in request) || !request[key].isArray)
    return values;

  foreach (item; request[key].toArray) {
    if (item.isString) {
      auto value = item.getString;
      if (value.length > 0)
        values ~= value;
    }
  }
  return values;
}

bool contains(string[] values, string expected) {
  return values.canFind(expected);
}

int optionalInt(Json request, string key, int fallback) {
  if (key in request && request[key].isInteger) {
    auto value = cast(int)request[key].get!long;
    return value > 0 ? value : fallback;
  }
  return fallback;
}

Json optionalObject(Json request, string key) {
  if (key in request && request[key].isObject) {
    return request[key];
  }
  return Json.emptyObject;
}
// Composite key generation for tenantId and destinationName.
string compositeKey(UUID a, UUID b) {
  return compositeKey(a.toString(), b.toString());
}

string compositeKey(UUID a, string b) {
  return compositeKey(a.toString(), b);
}

string compositeKey(string a, UUID b) {
  return compositeKey(a, b.toString());
}

string compositeKey(string a, string b) {
  return a ~ ":" ~ b;
}
// Extracts the last segment of a path, e.g. "foo/bar/baz" -> "baz".
string lastSegment(string path) {
  auto parts = path.split("/");
  return parts.length == 0 ? "" : parts[$ - 1];
}

bool matchesBasePath(string path, string basePath) {
  return path == basePath ? true : path.startsWith(basePath ~ "/");
}

bool startsWithTenantId(string key, TenantId tenantId) {
  auto id = tenantId.value;
  return key.length > id.length + 1 && key[0 .. id.length] == id
    && key[id.length] == ':';
}

size_t indexOfSeparator(string key) {
  foreach (i, c; key) {
    if (c == ':') {
      return i;
    }
  }
  return 0;
}

long clockSeconds() {
  

  return currentTimestamp / 10_000_000;
}
// private static long clockSeconds() {

// return Clock.currTime().toUnixTime();
// }
// private static long clockSeconds() {
// 
// return currentTimestamp / MonoTime.ticksPerSecond;
// }

string formatLong(long v) {
  return format("%d", v);
}

T[] skip(T)(T[] items, size_t offset) {
  return items.length > offset ? items[offset .. $] : null;
}

T[] limit(T)(T[] items, size_t limit) {
  return items.length > limit ? items[0 .. limit] : items;
}

T[] flat(T)(T[][] arrays) {
  T[] result;
  foreach (arr; arrays) {
    result ~= arr;
  }
  return result;
}

// private static long currentTimestamp() {
//   import core.time : Duration;
//   import std.datetime.systime : Clock;

//   return Clock.currStdTime();
// }

/// Check if a path starts with the given prefix.
bool pathStartsWith(string path, string prefix) {
  if (prefix.length == 0)
    return true;
  if (path.length < prefix.length)
    return false;
  return path[0 .. prefix.length] == prefix;
}

long currentTimestamp() {
  import std.datetime.systime : Clock;

  return Clock.currStdTime();
}

/*
    string currentTimestamp() {
        import std.datetime : Clock, UTC;
        return Clock.currTime(UTC()).toISOExtString();
    }
*/

string generateId() {
  return randomUUID().toString;
}
/*
  private string generateId() @safe {
    import std.random : uniform;
    return "pol-" ~ currentTimestamp.to!string ~ "-" ~ uniform(1000, 9999).to!string;
  } 
*/ 
