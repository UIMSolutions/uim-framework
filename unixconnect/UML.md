# UIM-UNIXCONNECT UML Description

## Overview

The UIM-UNIXCONNECT library provides a compact architecture for UNIX-CONNECT style IPC messaging in D applications with vibe.d asynchronous callback dispatch.

## Core Types

```plantuml
@startuml UNIXCONNECT_Core

enum UnixConnectSocketType {
  stream
  datagram
}

struct UnixConnectMessage {
  + sessionId: string
  + channel: string
  + payload: string
  + headers: string[string]
}

interface IUnixConnectSession {
  + id(): string
  + socketPath(): string
  + socketType(): UnixConnectSocketType
  + connected(): bool
  + metadata(): string[string]
  + isValid(): bool
}

interface IUnixConnectService {
  + connect(socketPath: string, socketType: UnixConnectSocketType): IUnixConnectSession
  + disconnect(sessionId: string): bool
  + connected(sessionId: string): bool
  + sessions(): IUnixConnectSession[]
  + send(message: UnixConnectMessage): bool
  + subscribe(channel: string, handler: UnixConnectMessageHandler): bool
  + unsubscribe(channel: string): bool
}

class UIMUnixConnectSession
class UIMUnixConnectService

UIMUnixConnectSession ..|> IUnixConnectSession
UIMUnixConnectService ..|> IUnixConnectService
UIMUnixConnectService --> UIMUnixConnectSession : tracks

@enduml
```

## Helper Layer

```plantuml
@startuml UNIXCONNECT_Helpers

class ChannelHelpers {
  + unixconnectNormalizeChannel(value: string): string
}

UIMUnixConnectService --> ChannelHelpers : normalize route

@enduml
```

## Sequence

```plantuml
@startuml UNIXCONNECT_Sequence

actor Application
participant Service as "UIMUnixConnectService"
participant Task as "vibe.d runTask"
participant Handler as "UnixConnectMessageHandler"

Application -> Service: connect("/tmp/uim.sock")
Application -> Service: subscribe("events/logistics", handler)
Application -> Service: send(message)
Service -> Task: runTask(callback)
Task -> Handler: on message

@enduml
```
