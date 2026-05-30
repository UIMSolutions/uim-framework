# UIM-LLRP UML Description

## Overview

The UIM-LLRP library provides a compact architecture for Low Level Reader Protocol workflows in D. It combines typed contracts, frame codec helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml LLRP_Core

enum LLRPVersion {
  v10_1
  v11
}

struct LLRPConfig {
  + host: string
  + port: ushort
  + readerName: string
  + clientId: string
  + llrpVersion: LLRPVersion
  + keepaliveMs: uint
  + timeoutMs: uint
  + strictMode: bool
}

struct LLRPMessage {
  + messageType: string
  + messageId: uint
  + payload: string
  + encodedFrame: string
}

struct LLRPResult {
  + success: bool
  + statusCode: ushort
  + message: string
  + responseFrame: string
}

interface ILLRPService {
  + configure(config: LLRPConfig): bool
  + encodeMessage(messageType: string, messageId: uint, payload: string): LLRPMessage
  + decodeFrame(frame: string): LLRPMessage
  + sendMessage(message: LLRPMessage): LLRPResult
  + decodeFrameAsync(frame: string, handler: LLRPMessageHandler): bool
  + sendMessageAsync(message: LLRPMessage, handler: LLRPResultHandler): bool
}

class UIMLLRPService

UIMLLRPService ..|> ILLRPService

@enduml
```

## Helper Layer

```plantuml
@startuml LLRP_Helpers

class CodecHelpers {
  + llrpEncodeMessage(messageType: string, messageId: uint, payload: string): LLRPMessage
  + llrpDecodeFrame(frame: string): LLRPMessage
}

UIMLLRPService --> CodecHelpers : encode and decode frame

@enduml
```

## Sequence

```plantuml
@startuml LLRP_Sequence

actor Application
participant Service as "UIMLLRPService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "LLRPResultHandler"

Application -> Service: configure(llrpConfig)
Application -> Service: encodeMessage(type, id, payload)
Service -> Helpers: build frame
Helpers --> Service: LLRPMessage
Service --> Application: LLRPMessage

Application -> Service: sendMessage(message)
Service --> Application: LLRPResult

Application -> Service: sendMessageAsync(message, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(result)

@enduml
```
