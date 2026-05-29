/****************************************************************************************************************
* Copyright: (c) 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.unixconnect.helpers.channel;

import std.string : strip;

@safe:

string unixconnectNormalizeChannel(string value) {
  auto channel = value.strip();
  if (channel.length == 0) {
    return channel;
  }

  if (channel[0] != '/') {
    channel = "/" ~ channel;
  }

  return channel;
}

unittest {
  assert(unixconnectNormalizeChannel("events/logistics") == "/events/logistics");
  assert(unixconnectNormalizeChannel("/events/logistics") == "/events/logistics");
}
