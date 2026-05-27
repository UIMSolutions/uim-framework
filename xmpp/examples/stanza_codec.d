#!/usr/bin/env dub
/+ dub.sdl:
    name "xmpp-stanza-codec-example"
    dependency "uim-framework:xmpp" path="../.."
+/
module xmpp.examples.stanza_codec;

import std.stdio : writeln;

import uim.xmpp;

void main() {
  writeln("=== uim-xmpp stanza codec example ===");

  auto outgoing = XMPPStanza(XMPPStanzaKind.iq)
    .id("iq-42")
    .toJid("service.example.org")
    .fromJid("alice@example.org/desktop")
    .stanzaType("get")
    .payloadXml("<query xmlns='jabber:iq:version'/>");

  auto xml = xmppEncodeStanza(outgoing);
  writeln("encoded stanza:");
  writeln(xml);

  IXMPPStanza decoded;
  assert(xmppTryDecodeStanza(
    "<message id='m-1' to='alice@example.org' from='bob@example.org/mobile' type='chat'><body>Hi Alice</body></message>",
    decoded
  ));

  writeln("decoded message:");
  writeln("  id: ", decoded.id());
  writeln("  from: ", decoded.fromJid());
  writeln("  to: ", decoded.toJid());
  writeln("  body: ", decoded.body());
  writeln("  bare from jid: ", xmppBareJid(decoded.fromJid()));
  writeln("  resource: ", xmppResource(decoded.fromJid()));

  writeln("=== done ===");
}
