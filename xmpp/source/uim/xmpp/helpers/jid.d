/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/
module uim.xmpp.helpers.jid;

import std.string : strip;

import uim.xmpp;

mixin(ShowModule!());

@safe:

string xmppNormalizeJid(string jid) {
  return jid.strip.idup;
}

string xmppBareJid(string jid) {
  auto normalized = xmppNormalizeJid(jid);
  foreach (i, ch; normalized) {
    if (ch == '/') {
      return normalized[0 .. i].idup;
    }
  }
  return normalized;
}

string xmppResource(string jid) {
  auto normalized = xmppNormalizeJid(jid);
  foreach (i, ch; normalized) {
    if (ch == '/' && i + 1 < normalized.length) {
      return normalized[i + 1 .. $].idup;
    }
  }
  return "";
}

unittest {
  assert(xmppNormalizeJid("  alice@example.org/home ") == "alice@example.org/home");
  assert(xmppBareJid("alice@example.org/home") == "alice@example.org");
  assert(xmppResource("alice@example.org/home") == "home");
}
