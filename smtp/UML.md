# UIM-SMTP UML Description

## Overview

The UIM-SMTP library provides a compact architecture for building SMTP message flows in D. It combines typed contracts, composable message models, helper codecs, and service-level orchestration with asynchronous callback support using vibe.d.

## Core Types

```plantuml
@startuml SMTP_Core

enum SMTPSecurity {
  none
  startTLS
  tls
}

enum SMTPAuthMode {
  none
  plain
  login
}

struct SMTPAddress {
  + email: string
  + displayName: string
}

struct SMTPServerConfig {
  + host: string
  + port: ushort
  + security: SMTPSecurity
  + authMode: SMTPAuthMode
  + username: string
  + password: string
}

struct SMTPResponse {
  + code: ushort
  + continued: bool
  + text: string
}

struct SMTPResult {
  + success: bool
  + code: ushort
  + message: string
  + transactionId: string
}

interface ISMTPMessage {
  + from(): SMTPAddress
  + to(): SMTPAddress[]
  + cc(): SMTPAddress[]
  + bcc(): SMTPAddress[]
  + subject(): string
  + textBody(): string
  + htmlBody(): string
  + isValid(): bool
}

interface ISMTPService {
  + configure(config: SMTPServerConfig): bool
  + compose(message: ISMTPMessage): string
  + parseResponseLine(line: string): SMTPResponse
  + send(message: ISMTPMessage): SMTPResult
  + sendAsync(message: ISMTPMessage, handler: SMTPResultHandler): bool
}

class UIMSMTPMessage
class UIMSMTPService

UIMSMTPMessage ..|> ISMTPMessage
UIMSMTPService ..|> ISMTPService
UIMSMTPService --> UIMSMTPMessage : consumes

@enduml
```

## Helper Layer

```plantuml
@startuml SMTP_Helpers

class CodecHelpers {
  + smtpIsValidEmail(value: string): bool
  + smtpFormatAddress(address: SMTPAddress): string
  + smtpJoinAddresses(addresses: SMTPAddress[]): string
  + smtpNormalizeTextBody(value: string): string
  + smtpParseResponseLine(line: string): SMTPResponse
}

UIMSMTPService --> CodecHelpers : compose/parse/validate

@enduml
```

## Sequence

```plantuml
@startuml SMTP_Sequence

actor Application
participant Service as "UIMSMTPService"
participant Helpers as "CodecHelpers"
participant Task as "vibe.d runTask"
participant Handler as "SMTPResultHandler"

Application -> Service: configure(serverConfig)
Application -> Service: send(message)
Service -> Helpers: validate + compose payload
Service --> Application: SMTPResult

Application -> Service: sendAsync(message, handler)
Service -> Task: runTask(callback)
Task -> Service: send(message)
Task -> Handler: callback(result)

@enduml
```
