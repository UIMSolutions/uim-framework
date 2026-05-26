/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.coap.helpers.path;

import std.array : array;
import std.algorithm : filter;
import std.string : split;

@safe:

string[] normalizeCoAPPath(string path) {
  auto p = path;
  while (p.length > 0 && p[0] == '/') {
    p = p[1 .. $];
  }

  if (p.length == 0) {
    return [];
  }

  return p
    .split("/")
    .filter!(s => s.length > 0)
    .array;
}

unittest {
  assert(normalizeCoAPPath("/").length == 0);
  assert(normalizeCoAPPath("/sensors/temp") == ["sensors", "temp"]);
  assert(normalizeCoAPPath("sensors//temp") == ["sensors", "temp"]);
}
