/****************************************************************************************************************
* Copyright: © 2018-2026 Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.
* Authors: Ozan Nurettin Suel (aka UI-Manufaktur UG *R.I.P*)
*****************************************************************************************************************/

# UIM-ADatP3 UML Description

## Overview
The UIM-ADatP3 library models NATO ADatP-3 messages in D and provides a codec and async transport facade. The transport uses vibe.d task scheduling to dispatch responses without blocking caller code.

## Core Types

```plantuml
@startuml ADatP3_Core

enum ADatP3MessageType {
  sitrep
  spotrep
  oprep
  frago
  freeText
}

enum ADatP3Priority {
  routine
  priority
  immediate
  flash
}

interface IADatP3Message {
  + messageType(): ADatP3MessageType
  + messageId(): string
  + originator(): string
  + recipient(): string
  + priority(): ADatP3Priority
  + fields(): string[string]
  + setField(key: string, value: string): IADatP3Message
}

interface IADatP3Transport {
  + connect(endpointUrl: string): bool
  + disconnect(): bool
  + connected(): bool
  + endpoint(): string
  + sendAsync(message: IADatP3Message, handler: ADatP3ResponseHandler): void
}

class UIMADatP3Message {
  - _messageType: ADatP3MessageType
  - _messageId: string
  - _originator: string
  - _recipient: string
  - _priority: ADatP3Priority
  - _fields: string[string]
}

class UIMADatP3Transport {
  - _connected: bool
  - _endpoint: string
}

UIMADatP3Message ..|> IADatP3Message
UIMADatP3Transport ..|> IADatP3Transport

@enduml
```

## Codec Layer

```plantuml
@startuml ADatP3_Codec

class ADatP3Codec {
  + adatp3EncodeJson(message: IADatP3Message): string
  + adatp3DecodeJson(payload: string): IADatP3Message
}

IADatP3Message --> ADatP3Codec : serialize/deserialize

@enduml
```

## Sequence

```plantuml
@startuml ADatP3_Sequence

actor Application
participant Transport as "UIMADatP3Transport"
participant Codec as "ADatP3Codec"
participant Task as "vibe.d runTask"

Application -> Codec: adatp3EncodeJson(message)
Codec --> Application: payload

Application -> Transport: sendAsync(message, handler)
Transport -> Task: runTask(callback)
Task --> Application: handler(response)

@enduml
```
