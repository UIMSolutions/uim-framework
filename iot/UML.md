# UIM-IoT UML Description

## Overview

The UIM-IoT library provides a compact architecture for IoT-oriented applications in D using vibe.d runtime primitives. It includes a typed device model, topic helpers, and an asynchronous event dispatch client.

## Core Types

```plantuml
@startuml IoT_Core

enum IoTProtocol {
  mqtt
  coap
  http
  websocket
  custom
}

enum IoTConnectionState {
  disconnected
  connecting
  connected
  error
}

struct IoTTelemetry {
  + topic: string
  + payload: string
  + timestamp: SysTime
  + tags: string[string]
}

interface IIoTDevice {
  + id(): string
  + name(): string
  + protocol(): IoTProtocol
  + state(): IoTConnectionState
  + endpoint(): string
  + metadata(): string[string]
}

interface IIoTClient {
  + connect(): bool
  + disconnect(): bool
  + connected(): bool
  + registerDevice(device: IIoTDevice): IIoTClient
  + subscribe(filter: string, handler: IoTTelemetryHandler): bool
  + publish(deviceId: string, topic: string, payload: string, tags: string[string]): bool
}

class UIMIoTDevice {
  - _id: string
  - _name: string
  - _protocol: IoTProtocol
  - _state: IoTConnectionState
  - _endpoint: string
  - _metadata: string[string]
}

class UIMIoTClient {
  - _connected: bool
  - _broker: string
  - _devices: IIoTDevice[string]
  - _subscriptions: IoTTelemetryHandler[][string]
}

UIMIoTDevice ..|> IIoTDevice
UIMIoTClient ..|> IIoTClient
UIMIoTClient --> UIMIoTDevice : uses

@enduml
```

## Helper Layer

```plantuml
@startuml IoT_Helpers

class TopicHelpers {
  + iotNormalizeTopic(topic: string): string
  + iotTopicMatches(filter: string, topic: string): bool
}

UIMIoTClient --> TopicHelpers : filter check

@enduml
```

## Sequence

```plantuml
@startuml IoT_Sequence

actor Application
participant Client as "UIMIoTClient"
participant Task as "vibe.d runTask"
participant Handler as "IoTTelemetryHandler"

Application -> Client: connect()
Application -> Client: registerDevice(device)
Application -> Client: subscribe("sensors/#", handler)
Application -> Client: publish("dev-1", "sensors/temp", "22.3")
Client -> Task: runTask(callback)
Task -> Handler: on telemetry

@enduml
```
