# Library uim-xmpp

Updated on 27. May 2026

A lightweight XMPP library for dlang built on vibe.d networking primitives. The library provides a typed stanza model, basic XML stanza encode/decode helpers, and an async client abstraction for message, presence, and IQ workflows.

## Features

- Type-safe stanza model (`IXMPPStanza`, `UIMXMPPStanza`)
- Stanza kinds (`message`, `presence`, `iq`)
- Client API (`IXMPPClient`) with connect/disconnect/send/handler registration
- JID helper utilities for bare/full JID normalization
- XML stanza codec helpers for basic stanza serialization and parsing
- Optional TCP transport adapter using `vibe.core.net.connectTCP`
- Async callback dispatch using vibe.d `runTask`

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:xmpp" version="*"
```

## Quick Start

```d
import uim.xmpp;

void main() {
  auto client = XMPPClient();
  assert(client.connect("xmpp://localhost:5222", "alice@example.org", "secret"));

  client.on(XMPPStanzaKind.message, (IXMPPStanza stanza) {
    import std.stdio : writeln;
    writeln("message from=", stanza.fromJid(), " body=", stanza.body());
  });

  auto msg = XMPPStanza(XMPPStanzaKind.message)
    .toJid("bob@example.org")
    .fromJid(client.jid())
    .stanzaType("chat")
    .body("Hello from uim-xmpp");

  client.send(msg);
  client.disconnect();
}
```

## Modules

- `uim.xmpp`: package entrypoint and re-exports
- `uim.xmpp.interfaces`: contracts for stanza and client components
- `uim.xmpp.stanza`: concrete stanza implementation
- `uim.xmpp.client`: async client orchestration and handler dispatch
- `uim.xmpp.transport.xml_codec`: XML stanza encode/decode helpers
- `uim.xmpp.transport.tcp_adapter`: TCP server adapter using vibe-core sockets
- `uim.xmpp.helpers.jid`: JID normalization and parsing helpers

## Examples

Run the included examples from the `xmpp` directory:

```bash
dub --single examples/basic_client.d
dub --single examples/stanza_codec.d
```

## Notes

This initial release focuses on core client-side building blocks and local async dispatch behavior. Full XMPP stream management, SASL/TLS negotiation, and server interoperability flows are intentionally staged for subsequent versions.
