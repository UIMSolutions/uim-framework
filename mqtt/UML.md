/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-MQTT UML Description

## Overview
The UIM-MQTT library provides a clean and asynchronous MQTT programming interface for D applications. It models messages and client behavior through interfaces and concrete implementations, and uses vibe.d tasks for asynchronous delivery.

## Core Types

```plantuml
@startuml MQTT_Core

interface IMQTTMessage {
  + topic(): string
  + topic(value: string): IMQTTMessage
  + payload(): string
  + payload(value: string): IMQTTMessage
  + qos(): MQTTQoS
  + qos(value: MQTTQoS): IMQTTMessage
  + retain(): bool
  + retain(value: bool): IMQTTMessage
  + duplicate(): bool
  + duplicate(value: bool): IMQTTMessage
}

enum MQTTQoS {
  atMostOnce
  atLeastOnce
  exactlyOnce
}

interface IMQTTClient {
  + connect(brokerUrl: string, clientId: string = ""): bool
  + disconnect(): bool
  + publish(topic: string, payload: string, qos: MQTTQoS, retain: bool): bool
  + subscribe(topicFilter: string, handler: MQTTMessageHandler): bool
  + unsubscribe(topicFilter: string): bool
  + connected(): bool
  + clientId(): string
}

class UIMMQTTMessage {
  - _topic: string
  - _payload: string
  - _qos: MQTTQoS
  - _retain: bool
  - _duplicate: bool
}

class UIMMQTTClient {
  - _connected: bool
  - _brokerUrl: string
  - _clientId: string
  - _subscriptions: MQTTMessageHandler[][string]
  # handleMessage(message: IMQTTMessage): void
}

UIMMQTTMessage ..|> IMQTTMessage
UIMMQTTClient ..|> IMQTTClient

@enduml
```

## Message Delivery Flow

```plantuml
@startuml MQTT_Message_Flow

actor Application
participant Client as "UIMMQTTClient"
participant Matcher as "topicMatches"
participant Task as "vibe.d runTask"
participant Handler as "MQTTMessageHandler"

Application -> Client: connect("mqtt://localhost:1883", "my-client")
Client --> Application: true

Application -> Client: subscribe("sensors/+/temperature", handler)
Client --> Application: true

Application -> Client: publish("sensors/kitchen/temperature", "22.4")
activate Client
Client -> Matcher: topicMatches(filter, topic)
Matcher --> Client: true
Client -> Task: runTask(handler(message))
deactivate Client

Task -> Handler: callback(message)
Handler --> Application: consume message

@enduml
```

## Topic Matching Rules

```plantuml
@startuml MQTT_Topic_Matching

class TopicFilterMatcher {
  + topicMatches(filter: string, topic: string): bool
}

note right of TopicFilterMatcher
  Supported wildcards:
  + : one level
  # : all remaining levels

  Examples:
  sensors/+/temperature matches sensors/kitchen/temperature
  sensors/# matches sensors/f1/r2/humidity
end note

@enduml
```
