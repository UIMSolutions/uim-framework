# UIM-OPCUA UML Description

## Overview

The UIM-OPCUA library provides a compact architecture for OPC UA workflows in D. It combines typed contracts, request/response helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml OPCUA_Core

enum OPCUASecurityMode {
  none
  sign
  signAndEncrypt
}

struct OPCUAConfig {
  + endpointUrl: string
  + applicationUri: string
  + sessionName: string
  + username: string
  + securityMode: OPCUASecurityMode
  + securityPolicyUri: string
  + timeoutMs: uint
  + strictMode: bool
}

struct OPCUANodeRead {
  + nodeId: string
  + attributeId: string
  + value: string
  + dataType: string
  + sourceTimestamp: long
}

struct OPCUAResult {
  + success: bool
  + statusCode: ushort
  + message: string
  + serviceResponse: string
}

interface IOPCUAService {
  + configure(config: OPCUAConfig): bool
  + readNode(nodeId: string, attributeId: string): OPCUANodeRead
  + writeNode(nodeId: string, value: string, dataType: string): OPCUAResult
  + invokeMethod(methodNodeId: string, objectNodeId: string, inputArgs: string[]): OPCUAResult
  + readNodeAsync(nodeId: string, attributeId: string, handler: OPCUANodeReadHandler): bool
  + writeNodeAsync(nodeId: string, value: string, dataType: string, handler: OPCUAResultHandler): bool
}

class UIMOPCUAService

UIMOPCUAService ..|> IOPCUAService

@enduml
```

## Helper Layer

```plantuml
@startuml OPCUA_Helpers

class CodecHelpers {
  + opcuaBuildReadRequest(nodeId: string, attributeId: string): string
  + opcuaBuildWriteRequest(nodeId: string, value: string, dataType: string): string
  + opcuaParseReadResponse(response: string, fallbackNodeId: string): OPCUANodeRead
}

UIMOPCUAService --> CodecHelpers : build and parse service payloads

@enduml
```

## Sequence

```plantuml
@startuml OPCUA_Sequence

actor Application
participant Service as "UIMOPCUAService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "OPCUAResultHandler"

Application -> Service: configure(opcuaConfig)
Application -> Service: readNode(nodeId, "Value")
Service --> Application: OPCUANodeRead

Application -> Service: writeNode(nodeId, value, "Int32")
Service --> Application: OPCUAResult

Application -> Service: writeNodeAsync(nodeId, value, dataType, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(result)

@enduml
```
