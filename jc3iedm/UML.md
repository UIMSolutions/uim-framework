# UIM-JC3IEDM UML Description

## Overview

The UIM-JC3IEDM library models command-and-control information entities aligned with JC3IEDM concepts and provides a service API for query and asynchronous stream workflows.

## Core Types

```plantuml
@startuml JC3IEDM_Core

enum JC3IEDMEntityType {
  unit
  person
  equipment
  facility
  action
  event_
  location
  organization
}

enum JC3IEDMAffiliation {
  unknown
  friendly
  hostile
  neutral
}

struct JC3IEDMPosition {
  + latitude: double
  + longitude: double
  + altitude: double
}

interface IJC3IEDMEntity {
  + id(): string
  + name(): string
  + entityType(): JC3IEDMEntityType
  + affiliation(): JC3IEDMAffiliation
  + position(): JC3IEDMPosition
  + attributes(): string[string]
  + isValid(): bool
}

interface IJC3IEDMService {
  + connect(endpointUrl: string): bool
  + disconnect(): bool
  + upsertEntity(entity: IJC3IEDMEntity): bool
  + queryByType(value: JC3IEDMEntityType): IJC3IEDMEntity[]
  + queryByAffiliation(value: JC3IEDMAffiliation): IJC3IEDMEntity[]
  + queryByAttribute(key: string, value: string): IJC3IEDMEntity[]
  + streamEntities(handler: JC3IEDMEntityHandler): bool
}

class UIMJC3IEDMEntity
class UIMJC3IEDMService

UIMJC3IEDMEntity ..|> IJC3IEDMEntity
UIMJC3IEDMService ..|> IJC3IEDMService
UIMJC3IEDMService --> UIMJC3IEDMEntity : stores

@enduml
```

## Helper Layer

```plantuml
@startuml JC3IEDM_Helpers

class TextHelpers {
  + jc3iedmNormalizeId(value: string): string
}

UIMJC3IEDMEntity --> TextHelpers : normalize IDs
UIMJC3IEDMService --> TextHelpers : lookup normalization

@enduml
```

## Sequence

```plantuml
@startuml JC3IEDM_Sequence

actor Application
participant Service as "UIMJC3IEDMService"
participant Task as "vibe.d runTask"
participant Handler as "JC3IEDMEntityHandler"

Application -> Service: connect("memory://jc3iedm")
Application -> Service: upsertEntity(entity)
Application -> Service: queryByType(unit)
Service --> Application: matching entities

Application -> Service: streamEntities(handler)
Service -> Task: runTask(callback)
Task -> Handler: on entity

@enduml
```
