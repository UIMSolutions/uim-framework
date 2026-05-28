# UIM-CDM UML Description

## Overview
The UIM-CDM library models a simple Common Data Model in D and provides a JSON codec plus an async HTTP transport facade. The transport uses vibe.d task scheduling to dispatch responses without blocking the caller.

## Core Types

```plantuml
@startuml CDM_Core

enum CdmObjectKind {
  entity
  attribute
  relationship
  document
  profile
}

enum CdmDataType {
  string
  boolean
  integer
  decimal
  dateTime
  identifier
  json
}

interface ICdmField {
  + name(): string
  + dataType(): CdmDataType
  + value(): string
}

interface ICdmEntity {
  + name(): string
  + description(): string
  + fields(): ICdmField[]
  + metadata(): string[string]
  + addField(field: ICdmField): ICdmEntity
}

interface ICdmDocument {
  + id(): string
  + name(): string
  + namespaceUri(): string
  + version(): string
  + created(): SysTime
  + entities(): ICdmEntity[]
  + metadata(): string[string]
  + addEntity(entity: ICdmEntity): ICdmDocument
}

class UIMCdmField {
  - _name: string
  - _dataType: CdmDataType
  - _value: string
}

class UIMCdmEntity {
  - _name: string
  - _description: string
  - _fields: ICdmField[]
  - _metadata: string[string]
}

class UIMCdmDocument {
  - _id: string
  - _name: string
  - _namespaceUri: string
  - _version: string
  - _created: SysTime
  - _entities: ICdmEntity[]
  - _metadata: string[string]
}

UIMCdmField ..|> ICdmField
UIMCdmEntity ..|> ICdmEntity
UIMCdmDocument ..|> ICdmDocument

@enduml
```

## Codec Layer

```plantuml
@startuml CDM_Codec

class CDMCodec {
  + cdmEncodeJson(document: ICdmDocument): string
  + cdmDecodeJson(payload: string): ICdmDocument
}

ICdmDocument --> CDMCodec : serialize/deserialize

@enduml
```

## Sequence

```plantuml
@startuml CDM_Sequence

actor Application
participant Transport as "UIMCdmTransport"
participant Codec as "CDMCodec"
participant Task as "vibe.d runTask"
participant HTTP as "requestHTTP"

Application -> Codec: cdmEncodeJson(document)
Codec --> Application: payload

Application -> Transport: sendAsync(document, handler)
Transport -> Task: runTask(callback)
Task -> HTTP: POST JSON payload
HTTP --> Task: response body
Task --> Application: handler(response)

@enduml
```
