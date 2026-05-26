# Library uim-coap

Updated on 26. May 2026

A lightweight CoAP library for dlang built on vibe.d networking primitives. The library provides a type-safe CoAP message model, binary packet codec, and UDP transport adapter for constrained-device communication.

## Features

- CoAP message model (`ICoAPMessage`, `UIMCoAPMessage`)
- CoAP protocol enums (`CoAPType`, `CoAPCode`)
- Binary CoAP packet encoder/decoder (header, token, options, payload)
- UDP transport adapter built on `vibe.core.net.listenUDP`
- Async client callbacks using vibe.d `runTask`
- Confirmable message retransmission with exponential backoff
- Observe registration and cancellation helpers
- Content-Format and JSON payload helper utilities

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:coap" version="*"
```

## Quick Start

```d
import uim.coap;

void main() {
  auto client = CoAPClient();
  assert(client.connect("coap://localhost:5683"));

  client.request(CoAPCode.get, "/sensors/temp", null, (ICoAPMessage response) {
    import std.stdio : writeln;
    import uim.coap.helpers.content_format : coapBytesToString;
    writeln("response code=", cast(ubyte) response.code());
    writeln("payload=", coapBytesToString(response.payload()));
  });

  client.observe("/events", (ICoAPMessage notification) {
    import std.stdio : writeln;
    writeln("observe update on ", notification.path());
  });

  client.cancelObserve("/events");

  client.disconnect();
}
```

## Modules

- `uim.coap`: package entrypoint and re-exports
- `uim.coap.interfaces`: contracts for CoAP message and client components
- `uim.coap.message`: concrete CoAP message implementation
- `uim.coap.client`: async CoAP client with optional UDP transport
- `uim.coap.transport.codec`: CoAP packet encode/decode helpers
- `uim.coap.transport.udp_adapter`: UDP endpoint adapter using vibe-core net
- `uim.coap.helpers.path`: CoAP URI path normalization
- `uim.coap.helpers.options`: CoAP option constants and uint option helpers
- `uim.coap.helpers.content_format`: Content-Format and JSON payload helpers

## Notes

The transport adapter is built for CoAP over UDP (`coap://`). For secure CoAP (`coaps://`), endpoint parsing and defaults are included and can be extended with DTLS integration in a future release.
