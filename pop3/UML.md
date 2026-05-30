# UIM-POP3 UML Description

## Overview

The UIM-POP3 library provides a compact architecture for POP3 mailbox workflows in D. It combines typed contracts, parser helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml POP3_Core

enum POP3Security {
  none
  startTLS
  tls
}

struct POP3Config {
  + host: string
  + port: ushort
  + security: POP3Security
  + username: string
  + password: string
}

struct POP3Status {
  + success: bool
  + messageCount: uint
  + mailboxSizeBytes: ulong
  + message: string
}

struct POP3MessageMeta {
  + number: uint
  + sizeBytes: ulong
  + uid: string
}

struct POP3Message {
  + number: uint
  + uid: string
  + raw: string
  + headers: string
  + body: string
}

struct POP3Result {
  + success: bool
  + message: string
}

interface IPOP3Service {
  + configure(config: POP3Config): bool
  + stat(): POP3Status
  + list(): POP3MessageMeta[]
  + uidl(): POP3MessageMeta[]
  + retr(number: uint): POP3Message
  + dele(number: uint): POP3Result
  + statAsync(handler: POP3StatusHandler): bool
  + retrAsync(number: uint, handler: POP3MessageHandler): bool
  + deleAsync(number: uint, handler: POP3ResultHandler): bool
}

class UIMPOP3Service

UIMPOP3Service ..|> IPOP3Service

@enduml
```

## Helper Layer

```plantuml
@startuml POP3_Helpers

class CodecHelpers {
  + pop3ParseStatusLine(line: string): POP3Status
  + pop3ParseListLine(line: string): POP3MessageMeta
  + pop3ParseUidlLine(line: string): POP3MessageMeta
  + pop3ParseRetrResponse(number: uint, uid: string, raw: string): POP3Message
}

UIMPOP3Service --> CodecHelpers : parse responses

@enduml
```

## Sequence

```plantuml
@startuml POP3_Sequence

actor Application
participant Service as "UIMPOP3Service"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "POP3StatusHandler"

Application -> Service: configure(pop3Config)
Application -> Service: stat()
Service --> Application: POP3Status

Application -> Service: retr(messageNo)
Service -> Helpers: parseRetrResponse(...)
Service --> Application: POP3Message

Application -> Service: statAsync(handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(status)

@enduml
```
