/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Süel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-gRPC UML Description

## Overview
The UIM-gRPC library provides a focused architecture for unary gRPC workflows in D. It includes typed request/response contracts, wire framing helpers, method path utilities, and an in-process channel with vibe.d task-based asynchronous dispatch.

## Core Contracts

```plantuml
@startuml GRPC_Core

enum GrpcStatusCode {
  ok
  canceled
  unknown
  invalidArgument
  deadlineExceeded
  notFound
  alreadyExists
  permissionDenied
  resourceExhausted
  failedPrecondition
  aborted
  outOfRange
  unimplemented
  internal
  unavailable
  dataLoss
  unauthenticated
}

class GrpcMetadataEntry {
  + name: string
  + value: string
}

class GrpcUnaryRequest {
  + methodPath: string
  + payload: ubyte[]
  + metadata: GrpcMetadataEntry[]
  + timeoutMs: uint
}

class GrpcUnaryResponse {
  + status: GrpcStatusCode
  + statusMessage: string
  + payload: ubyte[]
  + metadata: GrpcMetadataEntry[]
  + ok(): bool
}

interface IGrpcUnaryChannel {
  + registerUnary(methodPath: string, handler: GrpcUnaryHandler): bool
  + unregisterUnary(methodPath: string): bool
  + hasUnary(methodPath: string): bool
  + invoke(request: GrpcUnaryRequest): GrpcUnaryResponse
  + invokeAsync(request: GrpcUnaryRequest, callback: GrpcUnaryCallback): void
}

class UIMGrpcUnaryChannel {
  - _handlers: GrpcUnaryHandler[string]
}

UIMGrpcUnaryChannel ..|> IGrpcUnaryChannel

@enduml
```

## Helper Layer

```plantuml
@startuml GRPC_Helpers

class GrpcPathHelpers {
  + grpcNormalizeMethodPath(methodPath: string): string
  + grpcBuildMethodPath(serviceName: string, methodName: string): string
  + grpcTrySplitMethodPath(path: string, out service: string, out method: string): bool
}

class GrpcFramingHelpers {
  + grpcFrameMessage(payload: ubyte[], compressed: bool): ubyte[]
  + grpcPayloadLength(frame: ubyte[]): uint
  + grpcTryUnframeMessage(frame: ubyte[], out compressed: bool, out payload: ubyte[]): bool
}

@enduml
```

## Transport Facade

```plantuml
@startuml GRPC_Transport

class UIMGrpcLoopbackTransport {
  - _channel: UIMGrpcUnaryChannel
  + unary(request: GrpcUnaryRequest): GrpcUnaryResponse
  + unaryAsync(request: GrpcUnaryRequest, callback: GrpcUnaryCallback): void
}

UIMGrpcLoopbackTransport --> UIMGrpcUnaryChannel : delegates unary calls

@enduml
```

## Unary Sequence

```plantuml
@startuml GRPC_Sequence

actor Application
participant Channel as "UIMGrpcUnaryChannel"
participant Handler as "GrpcUnaryHandler"

Application -> Channel: invoke(GrpcRequest("/demo.Greeter/SayHello", payload))
Channel -> Channel: grpcNormalizeMethodPath()
Channel -> Handler: handler(request)
Handler --> Channel: GrpcOk(payload)
Channel --> Application: GrpcUnaryResponse(status=ok)

@enduml
```
