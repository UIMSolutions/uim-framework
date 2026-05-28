/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-OPC UML Description

## Overview

The UIM-OPC library provides a typed OPC UA address space model for D. It separates contracts (interfaces) from implementations, uses a tagged variant for typed values, and provides an in-process loopback server for testing without a live OPC UA server.

## Type System

```plantuml
@startuml OPC_Types

enum NodeIdType {
  numeric
  string_
  guid
  opaque
}

class OpcNodeId {
  + namespaceIndex: ushort
  + idType: NodeIdType
  - _numericId: ulong
  - _stringId: string
  + numeric(ns, id): OpcNodeId <<static>>
  + string_(ns, id): OpcNodeId <<static>>
  + numericId(): ulong
  + stringId(): string
  + isNull(): bool
  + toText(): string
  + opEquals(other): bool
  + toHash(): size_t
}

enum NodeClass {
  unspecified = 0
  object_ = 1
  variable_ = 2
  method_ = 4
  objectType = 8
  variableType = 16
  referenceType = 32
  dataType = 64
  view = 128
}

enum OpcAttribute {
  nodeId = 1
  nodeClass = 2
  browseName = 3
  displayName = 4
  value = 13
  dataType = 14
  accessLevel = 17
  ...
}

class QualifiedName {
  + namespaceIndex: ushort
  + name: string
}

class LocalizedText {
  + locale: string
  + text: string
}

interface INode {
  + nodeId(): OpcNodeId
  + nodeClass(): NodeClass
  + browseName(): QualifiedName
  + displayName(): LocalizedText
  + description(): LocalizedText
}

OpcNodeId --> NodeIdType

@enduml
```

## Variant and Status

```plantuml
@startuml OPC_ValueModel

enum OpcDataType {
  null_ = 0
  boolean_ = 1
  sbyte_ = 2
  byte_ = 3
  int16 = 4
  uint16 = 5
  int32 = 6
  uint32 = 7
  int64 = 8
  uint64 = 9
  float_ = 10
  double_ = 11
  string_ = 12
  dateTime = 13
  byteString = 15
  nodeId = 17
  statusCode = 19
  qualifiedName = 20
  localizedText = 21
  ...
}

class OpcVariant {
  + type: OpcDataType
  - _intVal: long
  - _floatVal: double
  - _textVal: string
  - _bytesVal: ubyte[]
  + boolean_(v): OpcVariant <<static>>
  + int32(v): OpcVariant <<static>>
  + double_(v): OpcVariant <<static>>
  + string_(v): OpcVariant <<static>>
  + byteString(v): OpcVariant <<static>>
  + null_(): OpcVariant <<static>>
  + asBoolean(): bool
  + asInt(): long
  + asFloat(): double
  + asString(): string
  + asBytes(): ubyte[]
  + isNull(): bool
}

enum OpcStatusCode {
  good = 0x00000000
  uncertain = 0x40000000
  bad = 0x80000000
  badNodeIdUnknown = 0x80340000
  badNotReadable = 0x803A0000
  badNotWritable = 0x803B0000
  badMethodInvalid = 0x80750000
  ...
}

class OpcStatus {
  + code: OpcStatusCode
  + message: string
  + good(): bool
  + uncertain(): bool
  + bad(): bool
}

OpcVariant --> OpcDataType
OpcStatus --> OpcStatusCode

@enduml
```

## Address Space

```plantuml
@startuml OPC_AddressSpace

class BrowseDescription {
  + nodeId: OpcNodeId
  + browseDirection: BrowseDirection
  + nodeClassMask: NodeClass
  + includeSubtypes: bool
}

class BrowseResult {
  + status: OpcStatus
  + references: ReferenceDescription[]
}

class ReferenceDescription {
  + nodeId: OpcNodeId
  + referenceTypeId: OpcNodeId
  + nodeClass: NodeClass
  + browseName: QualifiedName
  + displayName: LocalizedText
  + isForward: bool
}

class ReadValueId {
  + nodeId: OpcNodeId
  + attributeId: OpcAttribute
}

class DataValue {
  + value: OpcVariant
  + status: OpcStatus
  + sourceTimestampMs: long
  + serverTimestampMs: long
}

class WriteValue {
  + nodeId: OpcNodeId
  + attributeId: OpcAttribute
  + value: OpcVariant
}

class CallResult {
  + status: OpcStatus
  + outputArguments: OpcVariant[]
}

interface IAddressSpace {
  + browse(desc): BrowseResult
  + read(item): DataValue
  + write(item): OpcStatus
  + call(objectId, methodId, inputArgs): CallResult
  + addNode(node): bool
  + removeNode(nodeId): bool
  + findNode(nodeId): INode
}

class UIMOpcLoopbackServer {
  - _nodes: INode[string]
  - _readHandlers: ReadHandler[string]
  - _writeHandlers: WriteHandler[string]
  - _methodHandlers: MethodHandler[string]
  - _subscriptions: UIMOpcSubscription[]
  + registerRead(nodeId, handler)
  + registerWrite(nodeId, handler)
  + registerMethod(methodId, handler)
  + createSubscription(intervalMs): UIMOpcSubscription
  + publishDataChange(nodeId, value)
}

UIMOpcLoopbackServer ..|> IAddressSpace

@enduml
```

## Session and Client

```plantuml
@startuml OPC_Session

enum SecurityMode {
  invalid = 0
  none_ = 1
  sign = 2
  signAndEncrypt = 3
}

class OpcEndpoint {
  + endpointUrl: string
  + securityMode: SecurityMode
  + securityPolicyUri: string
  + transportProfileUri: string
}

class OpcUserIdentity {
  + username: string
  + password: string
  + anonymous: bool
  + anonymous_(): OpcUserIdentity <<static>>
  + userPassword(user, pass): OpcUserIdentity <<static>>
}

interface IOpcSession {
  + sessionId(): string
  + isActive(): bool
  + activate(identity): OpcStatus
  + close(): OpcStatus
}

interface IOpcClient {
  + connect(endpoint): OpcStatus
  + disconnect(): OpcStatus
  + isConnected(): bool
  + endpointUrl(): string
  + createSession(): IOpcSession
}

class UIMOpcSession {
  - _sessionId: string
  - _active: bool
}

class UIMOpcLoopbackClient {
  - _connected: bool
  - _endpointUrl: string
  - _server: UIMOpcLoopbackServer
  + addressSpace(): UIMOpcLoopbackServer
}

UIMOpcSession ..|> IOpcSession
UIMOpcLoopbackClient ..|> IOpcClient
UIMOpcLoopbackClient --> UIMOpcLoopbackServer

@enduml
```

## Subscription Model

```plantuml
@startuml OPC_Subscription

enum MonitoringMode {
  disabled = 0
  sampling = 1
  reporting = 2
}

class MonitoringParameters {
  + samplingIntervalMs: double
  + queueSize: uint
  + discardOldest: bool
}

class OpcDataValue {
  + value: OpcVariant
  + status: OpcStatus
  + sourceTimestampMs: long
  + serverTimestampMs: long
}

interface IMonitoredItem {
  + clientHandle(): uint
  + nodeId(): OpcNodeId
  + attributeId(): OpcAttribute
  + monitoringMode(): MonitoringMode
  + parameters(): MonitoringParameters
  + setCallback(cb): OpcStatus
  + setMonitoringMode(mode): OpcStatus
}

interface IOpcSubscription {
  + subscriptionId(): uint
  + publishingIntervalMs(): double
  + publishingEnabled(): bool
  + setPublishingEnabled(enabled): OpcStatus
  + monitor(nodeId, attr, params): IMonitoredItem
  + removeMonitoredItem(clientHandle): OpcStatus
  + monitoredItems(): IMonitoredItem[]
}

class UIMOpcMonitoredItem {
  - _clientHandle: uint
  - _callback: DataChangeCallback
  + fireDataChange(value)
}

class UIMOpcSubscription {
  - _subscriptionId: uint
  - _items: UIMOpcMonitoredItem[]
  + notifyDataChange(nodeId, value)
}

UIMOpcMonitoredItem ..|> IMonitoredItem
UIMOpcSubscription ..|> IOpcSubscription
UIMOpcSubscription "1" o-- "0..*" UIMOpcMonitoredItem

@enduml
```

## Component Dependency Graph

```plantuml
@startuml OPC_Components

package "uim.opc.types" {
  [status]
  [variant]
}

package "uim.opc.interfaces" {
  [node]
  [session]
  [subscription]
}

package "uim.opc.address" {
  [space]
}

package "uim.opc (impl)" {
  [UIMOpcNode]
  [UIMOpcSubscription]
  [UIMOpcLoopbackServer]
  [UIMOpcSession]
  [UIMOpcLoopbackClient]
}

[node] --> [status]
[node] --> [variant]
[session] --> [status]
[session] --> [node]
[subscription] --> [status]
[subscription] --> [variant]
[subscription] --> [node]
[space] --> [node]
[space] --> [variant]
[space] --> [status]

[UIMOpcNode] --> [node]
[UIMOpcSubscription] --> [subscription]
[UIMOpcLoopbackServer] --> [space]
[UIMOpcLoopbackServer] --> [UIMOpcNode]
[UIMOpcLoopbackServer] --> [UIMOpcSubscription]
[UIMOpcSession] --> [session]
[UIMOpcLoopbackClient] --> [session]
[UIMOpcLoopbackClient] --> [UIMOpcLoopbackServer]

@enduml
```
