#!/usr/bin/env dub
/+ dub.sdl:
    name "xmpp-basic-client-example"
    dependency "uim-framework:xmpp" path="../.."
+/
module xmpp.examples.basic_client;

import std.stdio : writeln;
import core.time : msecs;
import vibe.d : sleep;

import uim.xmpp;

void main() {
  writeln("=== uim-xmpp basic client example ===");

  auto client = XMPPClient();
  assert(client.connect("xmpp://localhost:5222", "alice@example.org", "secret"));

  int handled = 0;
  assert(client.on(XMPPStanzaKind.message, (IXMPPStanza stanza) {
    writeln("received message stanza");
    writeln("  from: ", stanza.fromJid());
    writeln("  to: ", stanza.toJid());
    writeln("  body: ", stanza.body());
    handled++;
  }));

  auto message = XMPPStanza(XMPPStanzaKind.message)
    .toJid("bob@example.org")
    .fromJid(client.jid())
    .stanzaType("chat")
    .body("Hello from basic_client example");

  assert(client.send(message));

  sleep(30.msecs);
  assert(handled == 1);
  assert(client.disconnect());

  writeln("handled callbacks: ", handled);
  writeln("=== done ===");
}
