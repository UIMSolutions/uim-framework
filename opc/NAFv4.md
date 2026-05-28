/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# NAF v4 Architecture - UIM-OPC

This document maps `uim-opc` to NATO Architecture Framework v4 viewpoints.

## AV - All Views

### AV-1 Overview

| Attribute | Value |
|---|---|
| Architecture Name | UIM OPC UA Library |
| Version | 26.x |
| Date | 28 May 2026 |
| Language | D (dlang) |
| Runtime | vibe.d |
| Standard | IEC 62541 (OPC UA) |
| License | Apache-2.0 |
| Status | Initial Release |

### AV-2 Integrated Dictionary

| Term | Definition |
|---|---|
| OPC UA | Open Platform Communications Unified Architecture — IEC 62541 industrial interoperability standard |
| NodeId | Globally unique identifier for a node: namespace index + typed identifier (numeric, string, GUID, opaque) |
| Address Space | The collection of all nodes exposed by an OPC UA server, traversable via Browse |
| NodeClass | Role classification of a node: Object, Variable, Method, ObjectType, VariableType, ReferenceType, DataType, View |
| Attribute | Named property on a node (NodeId, BrowseName, DisplayName, Value, DataType, AccessLevel, etc.) |
| Variant | Dynamically-typed scalar value container for any OPC UA built-in data type |
| StatusCode | 32-bit quality indicator with three severity tiers: Good, Uncertain, Bad |
| Session | Authenticated, stateful communication channel between an OPC UA client and server |
| Subscription | Server-managed publish/subscribe channel that delivers data changes to a client |
| MonitoredItem | A (NodeId, Attribute) pair being observed within a Subscription |
| DataChangeCallback | Client-side delegate invoked when a monitored attribute changes value or quality |
| Loopback Server | In-process address space implementation used for testing without a live OPC UA endpoint |

## CV - Capability View

### CV-1 Capability Taxonomy

```text
OPC UA Address Space Access
|- Node Identity
|  |- Numeric NodeIds (namespace:index + integer)
|  |- String NodeIds (namespace:index + string)
|  |- NodeClass classification
|  |- Attribute enumeration
|- Address Space Operations
|  |- Browse — traverse the node hierarchy
|  |- Read  — retrieve attribute values with quality stamps
|  |- Write — update attribute values
|  |- Call  — invoke method nodes with typed arguments
|- Value Representation
|  |- Boolean, integer, float scalar types
|  |- String, ByteString, DateTime scalar types
|  |- Null value representation
|  |- Quality status (Good/Uncertain/Bad + sub-code)
|- Session and Security
|  |- Anonymous and username/password identities
|  |- Security mode declaration (None/Sign/SignAndEncrypt)
|  |- Endpoint URL management
|- Subscriptions
|  |- Subscribe to individual (NodeId, Attribute) pairs
|  |- Configurable sampling interval and queue depth
|  |- Enable/disable publishing per subscription
|  |- Remove monitored items
|  |- DataChangeCallback notification
|- In-Process Testing
   |- Loopback server with handler registration
   |- Method handler registration
   |- Programmatic data change publication
   |- Subscription + monitored item wiring
```

### CV-2 Capability Dependencies

| Capability | Depends On |
|---|---|
| Typed read/write | `OpcVariant` tagged type, `OpcStatus` quality model |
| Node routing in Browse | `OpcNodeId` equality and hashing |
| DataChange notification | `UIMOpcSubscription.notifyDataChange`, `DataChangeCallback` delegate |
| Session lifecycle | `OpcUserIdentity`, `OpcEndpoint` |
| In-process testing | `UIMOpcLoopbackServer` (IAddressSpace), `UIMOpcLoopbackClient` |

## OV - Operational View

### OV-1 Operational Concept

1. A server adds nodes to its address space via `addNode`.
2. Per-node read and write handlers are registered to supply live values.
3. A client connects to the server via `IOpcClient.connect`.
4. The client creates and activates a session via `IOpcSession.activate`.
5. The client browses the address space to discover nodes.
6. The client reads individual attributes via `IAddressSpace.read`.
7. The client writes attribute values via `IAddressSpace.write`.
8. The client creates a subscription and registers monitored items with callbacks.
9. The server publishes data changes; callbacks fire in the client.
10. The client closes the session and disconnects.

### OV-5 Activity Model

```text
[Server Init]
  addNode(variable node)
  registerRead(nodeId, handler)
  registerWrite(nodeId, handler)
  registerMethod(methodId, handler)

[Client Connect]
  connect(OpcEndpoint)
  createSession() -> IOpcSession
  activate(OpcUserIdentity)

[Browse]
  browse(BrowseDescription) -> BrowseResult
    foreach reference in BrowseResult.references
      -> ReferenceDescription { nodeId, nodeClass, browseName, displayName }

[Read / Write]
  read(ReadValueId)  -> DataValue { value, status, timestamps }
  write(WriteValue)  -> OpcStatus

[Method Call]
  call(objectId, methodId, inputArgs) -> CallResult { status, outputArguments }

[Subscribe]
  createSubscription(intervalMs) -> IOpcSubscription
  monitor(nodeId, attr, params)  -> IMonitoredItem
  setCallback(DataChangeCallback)

[Publish]
  publishDataChange(nodeId, OpcDataValue)
    -> IOpcSubscription.notifyDataChange
      -> IMonitoredItem.fireDataChange
        -> DataChangeCallback invoked

[Teardown]
  session.close()
  client.disconnect()
```

## SV - Systems View

### SV-1 Systems Interface Description

| Interface | Provider | Consumer | Contract |
|---|---|---|---|
| `IAddressSpace` | `UIMOpcLoopbackServer` | Any OPC UA client | Browse, Read, Write, Call |
| `INode` | `UIMOpcNode` | `IAddressSpace` | Node identity and attributes |
| `IOpcSession` | `UIMOpcSession` | `IOpcClient` | Session lifecycle |
| `IOpcClient` | `UIMOpcLoopbackClient` | Application code | Connect/disconnect |
| `IOpcSubscription` | `UIMOpcSubscription` | Application code | Subscribe to data changes |
| `IMonitoredItem` | `UIMOpcMonitoredItem` | Application code | Per-attribute data change callback |

### SV-4 Systems Functionality Description

| System | Functionality |
|---|---|
| `UIMOpcLoopbackServer` | Hosts nodes, dispatches reads/writes/calls, notifies subscriptions |
| `UIMOpcNode` | Concrete node carrying NodeId, NodeClass, BrowseName, DisplayName |
| `UIMOpcSession` | Session ID generation, activate/close lifecycle |
| `UIMOpcLoopbackClient` | Connects to loopback server, creates sessions |
| `UIMOpcSubscription` | Manages monitored items, publishes data changes |
| `UIMOpcMonitoredItem` | Holds callback, filters by MonitoringMode |

## TV - Technical Standards View

| Standard | Applicability |
|---|---|
| IEC 62541-1 | OPC UA Concepts |
| IEC 62541-3 | OPC UA Address Space Model |
| IEC 62541-4 | OPC UA Services (Read, Write, Browse, Call, Subscribe) |
| IEC 62541-6 | OPC UA Binary Encoding (built-in data types, Variant) |
| IEC 62541-8 | OPC UA Data Access (Variable nodes, value quality) |
| Apache-2.0 | License |
| D Language Specification | Implementation language |
| vibe.d 0.10.x | Async I/O runtime |

## Roadmap

| Feature | Priority | Notes |
|---|---|---|
| opc.tcp:// transport framing | High | Binary UA-TCP channel framing (HEL/ACK/MSG) |
| OPC UA binary encoding | High | Part 6 encoding for all built-in types |
| Security Policy None transport | Medium | uasc/uabinary profile |
| Certificate-based authentication | Low | Signing + encryption modes |
| Historical access | Low | Part 11 (ReadRaw, ReadProcessed) |
| Alarm and Condition | Low | Part 9 (A&C events) |
| ODBC/SQL node provider | Medium | Bridge to `uim-sql` for database-backed nodes |
