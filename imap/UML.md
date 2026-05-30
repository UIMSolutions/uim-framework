# UIM-IMAP UML Description

## Overview

The UIM-IMAP library provides a compact architecture for IMAP mailbox workflows in D. It combines typed contracts, parser helpers, model constructors, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml IMAP_Core

enum IMAPSecurity {
  none
  startTLS
  tls
}

struct IMAPConfig {
  + host: string
  + port: ushort
  + security: IMAPSecurity
  + username: string
  + password: string
}

struct IMAPMailboxInfo {
  + name: string
  + messages: uint
  + recent: uint
  + unseen: uint
}

struct IMAPMessageMeta {
  + sequence: uint
  + uid: ulong
  + sizeBytes: ulong
  + flags: string[]
}

struct IMAPMessage {
  + sequence: uint
  + uid: ulong
  + raw: string
  + headers: string
  + body: string
}

struct IMAPResult {
  + success: bool
  + message: string
}

interface IIMAPService {
  + configure(config: IMAPConfig): bool
  + listMailboxes(): IMAPMailboxInfo[]
  + selectMailbox(mailbox: string): IMAPMailboxInfo
  + search(mailbox: string, criteria: string): ulong[]
  + fetch(mailbox: string, uid: ulong): IMAPMessage
  + deleteMessage(mailbox: string, uid: ulong): IMAPResult
  + selectMailboxAsync(mailbox: string, handler: IMAPMailboxInfoHandler): bool
  + fetchAsync(mailbox: string, uid: ulong, handler: IMAPMessageHandler): bool
  + deleteMessageAsync(mailbox: string, uid: ulong, handler: IMAPResultHandler): bool
}

class UIMIMAPService

UIMIMAPService ..|> IIMAPService

@enduml
```

## Helper Layer

```plantuml
@startuml IMAP_Helpers

class CodecHelpers {
  + imapParseListLine(line: string): IMAPMailboxInfo
  + imapParseSearchLine(line: string): ulong[]
  + imapParseFetchResponse(uid: ulong, raw: string): IMAPMessage
}

UIMIMAPService --> CodecHelpers : parse responses

@enduml
```

## Sequence

```plantuml
@startuml IMAP_Sequence

actor Application
participant Service as "UIMIMAPService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "IMAPMailboxInfoHandler"

Application -> Service: configure(imapConfig)
Application -> Service: search("INBOX", "UNSEEN")
Service --> Application: uid[]

Application -> Service: fetch("INBOX", uid)
Service -> Helpers: parseFetchResponse(...)
Service --> Application: IMAPMessage

Application -> Service: selectMailboxAsync("INBOX", handler)
Service -> Task: runTask(callback)
Task -> Handler: callback(mailboxInfo)

@enduml
```
