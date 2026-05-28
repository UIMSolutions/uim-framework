# Library uim-opc

Updated on 28. May 2026

A lightweight OPC UA (Open Platform Communications Unified Architecture) toolkit for dlang built on vibe.d runtime primitives. The library provides a typed OPC UA node model, address space contracts, data variant encoding, subscription and monitored item abstractions, and an in-process loopback server for service-first development and testing.

## Features

- Full OPC UA NodeId model (numeric, string, GUID, opaque) with namespace index support
- OPC UA NodeClass, Attribute, QualifiedName, and LocalizedText types
- Comprehensive status code model (`OpcStatusCode`) — Good, Uncertain, Bad severity layers
- Tagged variant type (`OpcVariant`) covering all OPC UA built-in data types
- Address space contracts: `IAddressSpace` with Browse, Read, Write, Call operations
- `INode` contract and concrete `UIMOpcNode` implementation
- Session model — `IOpcSession`, `IOpcClient`, `UIMOpcSession`, `UIMOpcLoopbackClient`
- Subscription and monitored item model with `DataChangeCallback` support
- In-process `UIMOpcLoopbackServer` — no external OPC server required for tests
- Publish/subscribe data change notification through the loopback server

## Installation

Add this dependency to your `dub.sdl`:

```d
dependency "uim-framework:opc" version="*"
```

## Quick Start

```d
import uim.opc;

void main() {
  // Create a loopback server as a simulated address space
  auto server = OpcLoopbackServer();

  // Define a variable node
  auto tempId = OpcNodeId.numeric(1, 1001);
  server.addNode(OpcNode(
    tempId,
    NodeClass.variable_,
    QualifiedName(1, "Temperature"),
    LocalizedText("en", "Temperature")
  ));

  // Register a read handler
  double temperature = 21.3;
  server.registerRead(tempId, (OpcNodeId nid) {
    return DataValue(OpcVariant.double_(temperature), opcGoodStatus(), 0, 0);
  });

  // Register a write handler
  server.registerWrite(tempId, (OpcNodeId nid, OpcVariant v) {
    temperature = v.asFloat;
    return opcGoodStatus();
  });

  // Read
  auto dv = server.read(ReadValueId(tempId, OpcAttribute.value));
  assert(dv.good);

  // Subscribe to data changes
  auto sub = server.createSubscription(500.0);
  auto item = sub.monitor(tempId, OpcAttribute.value, MonitoringParameters(200.0, 10, true));
  item.setCallback((OpcNodeId nid, OpcDataValue val) {
    // fired whenever the server publishes a change
  });

  // Simulate a server-side data change notification
  server.publishDataChange(tempId,
    OpcDataValue(OpcVariant.double_(25.0), opcGoodStatus(), 0, 0));
}
```

## Modules

| Module | Purpose |
|---|---|
| `uim.opc.types.status` | `OpcStatusCode` enum, `OpcStatus` struct, status factory helpers |
| `uim.opc.types.variant` | `OpcDataType` enum, `OpcVariant` tagged scalar type |
| `uim.opc.interfaces.node` | `NodeIdType`, `OpcNodeId`, `NodeClass`, `OpcAttribute`, `QualifiedName`, `LocalizedText`, `INode` |
| `uim.opc.interfaces.session` | `SecurityMode`, `OpcEndpoint`, `OpcUserIdentity`, `IOpcSession`, `IOpcClient` |
| `uim.opc.interfaces.subscription` | `MonitoringMode`, `MonitoringParameters`, `OpcDataValue`, `DataChangeCallback`, `IMonitoredItem`, `IOpcSubscription` |
| `uim.opc.address.space` | `BrowseDescription`, `ReferenceDescription`, `BrowseResult`, `ReadValueId`, `DataValue`, `WriteValue`, `Argument`, `CallResult`, `IAddressSpace` |
| `uim.opc.node` | `UIMOpcNode`, `OpcNode()` factory |
| `uim.opc.subscription` | `UIMOpcMonitoredItem`, `UIMOpcSubscription`, `OpcSubscription()` factory |
| `uim.opc.server` | `UIMOpcLoopbackServer` (implements `IAddressSpace`), `OpcLoopbackServer()` factory |
| `uim.opc.session` | `UIMOpcSession`, `UIMOpcLoopbackClient`, `OpcSession()` / `OpcLoopbackClient()` factories |

## OPC UA Concepts

OPC UA is an IEC 62541 standard for industrial interoperability. Key concepts implemented:

- **NodeId** — Globally unique node identifier (namespace index + type-tagged identifier)
- **Address Space** — Hierarchical graph of nodes reachable via Browse, Read, Write, Call
- **NodeClass** — Node role: Object, Variable, Method, ObjectType, VariableType, ReferenceType, DataType, View
- **Attribute** — Named property on a node (NodeId, BrowseName, DisplayName, Value, DataType, AccessLevel, …)
- **Variant** — Dynamically-typed scalar value container for all 25 built-in OPC UA data types
- **Session** — Authenticated stateful connection between client and server
- **Subscription** — Periodic publish/subscribe channel between client and server
- **MonitoredItem** — A single (NodeId, Attribute) pair observed within a Subscription

## Roadmap

- HTTP/WebSocket transport adapter (`opc.tcp://` and `ws://` framing)
- Full OPC UA binary encoding/decoding (Part 6)
- Security Policy integration (signing, encryption)
- Certificate-based authentication (`badCertificate*` status codes)
- Historical access (Part 11)
- Alarm and Condition (Part 9)
