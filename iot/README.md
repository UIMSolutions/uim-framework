# Library uim-iot

Updated on 28. May 2026

uim-iot is a lightweight IoT library for D projects using vibe.d patterns. It provides a typed device model, topic filter helpers, and an async in-memory publish/subscribe client that can be used for IoT integration layers and protocol adapters.

## Features

* Typed IoT model contracts (`IIoTDevice`, `IIoTClient`)
* Protocol and connection enums (`IoTProtocol`, `IoTConnectionState`)
* Topic normalization and wildcard filter matching (`+`, `#`)
* Async telemetry callback dispatch using vibe.d `runTask`
* Simple broker-oriented IoT client abstraction for application integration

## Installation

Add this dependency to your dub.sdl:

```d
dependency "uim-framework:iot" version="*"
```

## Quick Start

```d
import std.stdio : writeln;
import uim.iot;

void main() {
  auto client = IoTClient("mqtt://broker.local:1883");
  auto dev = IoTDevice("dev-001", "Room Sensor", IoTProtocol.mqtt, "mqtt://broker.local:1883");

  client.registerDevice(dev);
  client.connect();

  client.subscribe("building/a1/sensors/+", (IIoTDevice d, IoTTelemetry t) @safe {
    writeln("device=", d.id(), " topic=", t.topic, " payload=", t.payload);
  });

  client.publish("dev-001", "building/a1/sensors/temperature", "21.7", ["unit": "C"]);
  client.disconnect();
}
```

## Modules

* `uim.iot`: package entrypoint and re-exports
* `uim.iot.interfaces`: protocol enums and IoT contracts
* `uim.iot.models`: concrete IoT device implementation
* `uim.iot.helpers`: topic normalization and filter matching
* `uim.iot.client`: async IoT client orchestration

## Notes

* The default client implementation is transport-agnostic and useful for app/service integration flows.
* You can wrap protocol-specific transports (MQTT, CoAP, HTTP) behind the same `IIoTClient` contract.
