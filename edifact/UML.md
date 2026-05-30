# UIM-EDIFACT UML Description

## Overview

The UIM-EDIFACT library provides a compact architecture for EDIFACT interchange workflows in D. It combines typed contracts, parser/serializer helpers, result model constructors, and asynchronous orchestration with vibe.d.

## Core Types

```plantuml
@startuml EDIFACT_Core

enum EDIFACTSyntax {
  unoa
  unob
  unoc
}

struct EDIFACTConfig {
  + senderId: string
  + receiverId: string
  + syntax: EDIFACTSyntax
  + controlReference: string
  + strictMode: bool
}

struct EDIFACTSegment {
  + tag: string
  + elements: string[]
}

struct EDIFACTMessage {
  + messageType: string
  + releaseCode: string
  + controllingAgency: string
  + messageReference: string
  + segments: EDIFACTSegment[]
}

struct EDIFACTResult {
  + success: bool
  + statusCode: ushort
  + message: string
  + controlReference: string
}

interface IEDIFACTService {
  + configure(config: EDIFACTConfig): bool
  + parseInterchange(interchange: string): EDIFACTMessage
  + serializeMessage(message: EDIFACTMessage): string
  + generateContrlAck(message: EDIFACTMessage, accepted: bool, reason: string): EDIFACTResult
  + parseInterchangeAsync(interchange: string, handler: EDIFACTMessageHandler): bool
  + serializeMessageAsync(message: EDIFACTMessage, handler: EDIFACTResultHandler): bool
}

class UIMEDIFACTService

UIMEDIFACTService ..|> IEDIFACTService

@enduml
```

## Helper Layer

```plantuml
@startuml EDIFACT_Helpers

class CodecHelpers {
  + edifactParseSegment(line: string): EDIFACTSegment
  + edifactParseSegments(interchange: string): EDIFACTSegment[]
  + edifactSerializeSegments(segments: EDIFACTSegment[]): string
}

UIMEDIFACTService --> CodecHelpers : parse and serialize

@enduml
```

## Sequence

```plantuml
@startuml EDIFACT_Sequence

actor Application
participant Service as "UIMEDIFACTService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "EDIFACTMessageHandler"

Application -> Service: configure(edifactConfig)
Application -> Service: parseInterchange(interchange)
Service -> Helpers: parse segments
Helpers --> Service: EDIFACTSegment[]
Service --> Application: EDIFACTMessage

Application -> Service: generateContrlAck(message, accepted, reason)
Service --> Application: EDIFACTResult

Application -> Service: parseInterchangeAsync(interchange, handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(message)

@enduml
```
