/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-MQTT

This document maps `uim-mqtt` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM MQTT Library |
| Version | 26.x |
| Date | 26 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d 0.10.x |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| MQTT | Lightweight publish/subscribe protocol for IoT and telemetry |
| Topic | Hierarchical subject path for routing messages |
| Topic Filter | Subscription expression using MQTT wildcards `+` and `#` |
| QoS | Quality of Service level controlling delivery guarantees |
| Retain | MQTT flag indicating broker should retain the last message |
| Client | Endpoint that publishes and subscribes to topics |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
MQTT Messaging
|- Session Management
|  |- Connect/disconnect lifecycle
|  |- Client identity
|- Publish/Subscribe
|  |- Topic-based publish
|  |- Topic-filter subscriptions
|  |- Unsubscribe management
|- Message Modeling
|  |- Topic and payload
|  |- QoS levels
|  |- Retain and duplicate flags
|- Async Dispatch
   |- Non-blocking callback execution via vibe.d tasks
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Subscription Routing | Topic filter matcher |
| Async Callback Dispatch | vibe.d `runTask` |
| Message Model | `IMQTTMessage` contract |
| Client Operations | `IMQTTClient` contract |

## OV - Operational View

### OV-1 Operational Concept

1. Application creates a `UIMMQTTClient`.
2. Client connects using broker URL and optional client ID.
3. Application registers topic filters with callbacks.
4. Application publishes messages to topics.
5. Client matches each message against active filters.
6. Matching callbacks run asynchronously in vibe.d tasks.

### OV-5 Activity Model

| Step | Activity | Input | Output |
|---|---|---|---|
| 1 | Connect client | brokerUrl, clientId | Connected session |
| 2 | Subscribe filter | topicFilter, callback | Stored subscription |
| 3 | Publish message | topic, payload, qos, retain | Message instance |
| 4 | Match routes | filter + topic | target callback set |
| 5 | Dispatch callbacks | message | Async handler execution |
| 6 | Unsubscribe/disconnect | topicFilter or session | Cleaned runtime state |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+--------------------------+
| Application Layer        |
|  uses uim.mqtt API       |
+------------+-------------+
             |
             v
+--------------------------+
| uim.mqtt                 |
| - IMQTTClient            |
| - IMQTTMessage           |
| - UIMMQTTClient          |
| - UIMMQTTMessage         |
| - topicMatches helper    |
+------------+-------------+
             |
             v
+--------------------------+
| vibe.d Runtime           |
| - runTask                |
+--------------------------+
```

### SV-4 Function Mapping

| Module | Function |
|---|---|
| `uim.mqtt.interfaces.message` | Message data contract + QoS typing |
| `uim.mqtt.interfaces.client` | MQTT client behavior contract |
| `uim.mqtt.message` | Concrete message implementation |
| `uim.mqtt.client` | Session + pub/sub + async callback dispatch |
| `uim.mqtt.helpers.topic` | MQTT wildcard topic matching |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
|---|---|---|
| MQTT Topic Filter Semantics | 3.1.1/5.0 compatible subset | `+` and `#` matching |
| D Language | 2.x | Library implementation |
| vibe.d | 0.10.3 | Async task runtime |
| Apache License | 2.0 | Distribution and reuse |

### TV-2 Technical Roadmap

| Item | Status | Description |
|---|---|---|
| Embedded pub/sub API | Implemented | Async dispatch and wildcard routing |
| TCP protocol adapter | Planned | MQTT packet encoding/decoding over sockets |
| Broker interoperability tests | Planned | Integration tests with Mosquitto/EMQX |
| Reconnect strategy | Planned | Backoff and connection recovery |

## L - Logical Model

### L-1 Logical Data Model

```text
UIMMQTTClient
  |- brokerUrl: string
  |- clientId: string
  |- connected: bool
  |- subscriptions: topicFilter -> handlers[]

UIMMQTTMessage
  |- topic: string
  |- payload: string
  |- qos: MQTTQoS
  |- retain: bool
  |- duplicate: bool
```

### L-2 Constraints

- Publish, subscribe, and unsubscribe require an active connection.
- Empty topics and filters are rejected.
- Wildcard routing follows MQTT-style `+` and `#` semantics.
- Callback delivery is asynchronous and non-blocking.
