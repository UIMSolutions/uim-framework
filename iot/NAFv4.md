# NAF v4 Architecture - UIM-IoT

This document maps uim-iot capabilities to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
| --- | --- |
| Architecture Name | UIM IoT Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Domain | IoT device telemetry and event orchestration |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
| --- | --- |
| IoT | Internet of Things |
| Telemetry | Device-generated event or measurement payload |
| Topic Filter | MQTT-style topic expression used for subscription matching |
| Broker | Logical endpoint coordinating message exchange |
| Device State | Connection lifecycle status for an IoT device |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
IoT Event Management
|- Device Lifecycle
|  |- register device
|  |- connect/disconnect state handling
|- Topic Routing
|  |- topic normalization
|  |- wildcard filter matching (+, #)
|- Telemetry Dispatch
|  |- publish telemetry
|  |- async callback scheduling via runTask
|- Integration Abstraction
   |- protocol-neutral client interface
   |- extension point for MQTT/CoAP/HTTP adapters
```

### CV-2 Capability Dependencies

| Capability | Depends On |
| --- | --- |
| Async callback dispatch | vibe.d runTask |
| Topic parsing | D string utilities |
| Typed domain model | IoT interfaces and enums |
| In-process routing | Subscription matching helpers |

## OV - Operational View

### OV-1 Operational Concept

1. Application creates an IoT client and registers one or more devices.
2. Application connects the client to a logical broker endpoint.
3. Application subscribes handlers using topic filters.
4. Device payloads are published into the client.
5. Matching subscriptions receive telemetry callbacks asynchronously.

### OV-5 Activity Model

| Step | Activity | Input | Output |
| --- | --- | --- | --- |
| 1 | Register device | device model | tracked device registry |
| 2 | Open client session | broker endpoint | connected client state |
| 3 | Add subscriptions | topic filters, handlers | subscription table |
| 4 | Publish telemetry | device ID, topic, payload | routed telemetry event |
| 5 | Dispatch callbacks | matched subscriptions | async handler execution |

## SV - Systems View

### SV-1 Systems Interface Description

```text
+---------------------------+
| Application Layer         |
| - IoT business services   |
+-------------+-------------+
              |
              v
+---------------------------+
| uim.iot                   |
| - interfaces              |
| - device model            |
| - topic helpers           |
| - async client            |
+-------------+-------------+
              |
              v
+---------------------------+
| vibe.d runtime            |
| - runTask scheduling      |
+---------------------------+
```

### SV-4 Function Mapping

| Module | Function |
| --- | --- |
| uim.iot.interfaces.device | IoT contracts, enums, telemetry struct |
| uim.iot.models.device | Concrete IoT device implementation |
| uim.iot.helpers.topic | Topic normalization and filter matching |
| uim.iot.client | Device registry and async publish/subscribe orchestration |

## TV - Technical View

### TV-1 Standards Profile

| Standard / Technology | Version | Use |
| --- | --- | --- |
| D Language | 2.x | implementation language |
| vibe.d | 0.10.x | async runtime and task dispatch |
| MQTT Topic Semantics | common pattern | wildcard filter behavior (+, #) |

### TV-2 Technical Roadmap

| Item | Status | Description |
| --- | --- | --- |
| Device model | Implemented | Typed IoT device metadata and state |
| Topic filter engine | Implemented | Wildcard topic routing |
| Async telemetry client | Implemented | Non-blocking callback dispatch |
| MQTT adapter | Planned | Real broker transport implementation |
| CoAP/HTTP gateways | Planned | Protocol bridge integrations |

## L - Logical Model

### L-1 Logical Data Model

```text
IIoTDevice
  |- id: string
  |- name: string
  |- protocol: IoTProtocol
  |- state: IoTConnectionState
  |- endpoint: string
  |- metadata: string[string]

IoTTelemetry
  |- topic: string
  |- payload: string
  |- timestamp: SysTime
  |- tags: string[string]
```

### L-2 Constraints

* Publishing requires a connected client state.
* Topic filters are normalized before routing.
* Telemetry dispatch is asynchronous and handler failures are isolated.
