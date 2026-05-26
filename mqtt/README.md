# Library uim-mqtt

Updated on 26. May 2026

A lightweight MQTT library for dlang built on top of vibe.d async primitives. The library focuses on a clean API for connecting, subscribing, and publishing with MQTT-style topic filter matching (`+`, `#`).

## Features

- Type-safe message model (`IMQTTMessage`, `UIMMQTTMessage`)
- MQTT QoS enum (`atMostOnce`, `atLeastOnce`, `exactlyOnce`)
- Client API (`IMQTTClient`) with connect/publish/subscribe/unsubscribe
- Topic filter matching helper with MQTT wildcard support
- Async callback dispatch using vibe.d `runTask`

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:mqtt" version="*"
```

## Quick Start

```d
import uim.mqtt;

void main() {
  auto client = MQTTClient();

  assert(client.connect("mqtt://localhost:1883", "app-client"));

  client.subscribe("sensors/+/temperature", (IMQTTMessage message) {
    import std.stdio : writeln;
    writeln("topic=", message.topic(), ", payload=", message.payload());
  });

  client.publish("sensors/kitchen/temperature", "22.4", MQTTQoS.atLeastOnce);
  client.disconnect();
}
```

## Modules

- `uim.mqtt`: Package entrypoint and re-exports
- `uim.mqtt.interfaces`: Contracts for message and client components
- `uim.mqtt.message`: Concrete MQTT message implementation
- `uim.mqtt.client`: vibe.d async MQTT client implementation
- `uim.mqtt.transport.codec`: MQTT v3.1.1 packet encode/decode helpers
- `uim.mqtt.transport.tcp_adapter`: TCP broker adapter using vibe-core sockets
- `uim.mqtt.helpers.topic`: MQTT topic filter matcher

## Notes

This first version provides an embedded async MQTT programming model and topic routing behavior. It is designed to be a stable base for adding protocol-level TCP transport and broker interoperability in subsequent releases.
