/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.jc3iedm.helpers.text;

import std.string : strip;

@safe:

string jc3iedmNormalizeId(string value) {
  auto trimmed = value.strip();
  if (trimmed.length == 0) {
    return trimmed;
  }

  auto id = trimmed.dup;

  foreach (i; 0 .. id.length) {
    auto c = id[i];
    if (c == ' ') {
      id[i] = '_';
    }
  }

  return id.idup;
}

unittest {
  assert(jc3iedmNormalizeId(" UNIT 42 ") == "UNIT_42");
}
